-- 011_functions.sql
-- Helper functions + Triggers
-- Depende de: todas as tabelas criadas (002-010)

-- ============================================================
-- HELPER FUNCTIONS (usadas por RLS e triggers)
-- ============================================================

CREATE OR REPLACE FUNCTION get_user_tenant_id()
RETURNS UUID
LANGUAGE sql STABLE
AS $$
  SELECT COALESCE(
    (current_setting('request.jwt.claims', true)::json->>'tenant_id')::uuid,
    (current_setting('request.jwt.claims', true)::json->'app_metadata'->>'tenant_id')::uuid
  );
$$;

CREATE OR REPLACE FUNCTION get_user_role_level()
RETURNS INTEGER
LANGUAGE sql STABLE
AS $$
  SELECT COALESCE(
    (current_setting('request.jwt.claims', true)::json->'app_metadata'->>'role_level')::integer,
    0
  );
$$;

CREATE OR REPLACE FUNCTION get_user_professional_id()
RETURNS UUID
LANGUAGE sql STABLE
AS $$
  SELECT id FROM professionals WHERE user_id = auth.uid() AND is_active = true;
$$;

CREATE OR REPLACE FUNCTION get_user_customer_id()
RETURNS UUID
LANGUAGE sql STABLE
AS $$
  SELECT id FROM customers WHERE user_id = auth.uid() AND deleted_at IS NULL;
$$;

-- ============================================================
-- AUTO TENANT_ID (aplicado via trigger nas tabelas business)
-- ============================================================

CREATE OR REPLACE FUNCTION set_tenant_id()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  NEW.tenant_id := get_user_tenant_id();
  RETURN NEW;
END;
$$;

-- ============================================================
-- AUTO UPDATED_AT
-- ============================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

-- ============================================================
-- CALCULAR COMISSÃO NO APPOINTMENT.COMPLETED
-- ============================================================

CREATE OR REPLACE FUNCTION calculate_commission()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
  total_commission DECIMAL(10,2) := 0;
  service_pct DECIMAL(5,2);
  rule_pct DECIMAL(5,2);
  service_record RECORD;
BEGIN
  IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
    FOR service_record IN
      SELECT ap.price, ap.commission_pct, ap.service_id
      FROM appointment_services ap
      WHERE ap.appointment_id = NEW.id
    LOOP
      SELECT COALESCE(
        (SELECT percentage FROM professional_commission_rules
         WHERE professional_id = NEW.professional_id
           AND rule_type = 'per_service'
           AND service_id = service_record.service_id),
        (SELECT percentage FROM professional_commission_rules
         WHERE professional_id = NEW.professional_id
           AND rule_type = 'per_category'
           AND category_id = (SELECT category_id FROM services WHERE id = service_record.service_id)),
        (SELECT percentage FROM professional_commission_rules
         WHERE professional_id = NEW.professional_id
           AND rule_type = 'default'),
        service_record.commission_pct
      ) INTO rule_pct;

      total_commission := total_commission + (service_record.price * rule_pct / 100);
    END LOOP;

    NEW.commission_amount := total_commission;
  END IF;
  RETURN NEW;
END;
$$;

-- ============================================================
-- ATUALIZAR ESTOQUE NA VENDA DE PRODUTO
-- ============================================================

CREATE OR REPLACE FUNCTION update_stock_on_sale()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
  item RECORD;
  current_stock INTEGER;
BEGIN
  FOR item IN SELECT * FROM jsonb_to_recordset(NEW.items) AS x(product_id uuid, quantity int)
  LOOP
    SELECT stock_quantity INTO current_stock FROM products WHERE id = item.product_id;
    IF current_stock < item.quantity THEN
      RAISE EXCEPTION 'Estoque insuficiente para o produto %', item.product_id;
    END IF;
    UPDATE products SET stock_quantity = stock_quantity - item.quantity
    WHERE id = item.product_id;
    INSERT INTO inventory_movements (tenant_id, product_id, type, quantity, quantity_after, reference_id, reference_type, description)
    VALUES (NEW.tenant_id, item.product_id, 'sale', -item.quantity, current_stock - item.quantity, NEW.id, 'product_sale', 'Venda #' || NEW.id);
  END LOOP;
  RETURN NEW;
END;
$$;

-- ============================================================
-- CRIAR LOYALTY ACCOUNT PARA NOVO CUSTOMER
-- ============================================================

CREATE OR REPLACE FUNCTION create_loyalty_account()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO loyalty_accounts (tenant_id, customer_id)
  VALUES (NEW.tenant_id, NEW.id);
  RETURN NEW;
END;
$$;

-- ============================================================
-- AUDITAR MUDANÇAS CRÍTICAS
-- ============================================================

CREATE OR REPLACE FUNCTION audit_changes()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO audit_logs (tenant_id, user_id, action, entity_type, entity_id, before, after)
  VALUES (
    COALESCE(NEW.tenant_id, OLD.tenant_id),
    auth.uid(),
    TG_OP,
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    CASE WHEN TG_OP = 'DELETE' THEN row_to_json(OLD)::jsonb ELSE NULL END,
    CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN row_to_json(NEW)::jsonb ELSE NULL END
  );
  RETURN COALESCE(NEW, OLD);
END;
$$;

-- ============================================================
-- REGISTRAR PRODUCT_EVENT AUTOMATICAMENTE
-- ============================================================

CREATE OR REPLACE FUNCTION register_product_event()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO product_events (tenant_id, event_type, source, properties, user_id)
  VALUES (
    NEW.tenant_id,
    CASE TG_TABLE_NAME
      WHEN 'appointments' THEN 'appointment.' || NEW.status
      WHEN 'payments' THEN 'payment.' || NEW.status
      WHEN 'customers' THEN 'customer.' || TG_OP
      ELSE TG_TABLE_NAME || '.' || TG_OP
    END,
    'edge_function',
    jsonb_build_object(
      'id', NEW.id,
      'table', TG_TABLE_NAME,
      'action', TG_OP
    ),
    auth.uid()
  );
  RETURN NEW;
END;
$$;

-- ============================================================
-- APLICAÇÃO DOS TRIGGERS
-- ============================================================

-- set_tenant_id em todas as tabelas business
CREATE TRIGGER trg_set_tenant_id_tenant_themes
  BEFORE INSERT ON tenant_themes
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_tenant_features
  BEFORE INSERT ON tenant_features
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_users
  BEFORE INSERT ON users
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_service_categories
  BEFORE INSERT ON service_categories
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_services
  BEFORE INSERT ON services
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_service_addons
  BEFORE INSERT ON service_addons
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_professionals
  BEFORE INSERT ON professionals
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_customers
  BEFORE INSERT ON customers
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_interactions
  BEFORE INSERT ON customer_interactions
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_appointments
  BEFORE INSERT ON appointments
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_payments
  BEFORE INSERT ON payments
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_transactions
  BEFORE INSERT ON financial_transactions
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_commissions
  BEFORE INSERT ON commission_entries
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_cash_registers
  BEFORE INSERT ON cash_registers
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_expenses
  BEFORE INSERT ON expenses
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_loyalty
  BEFORE INSERT ON loyalty_accounts
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_rewards
  BEFORE INSERT ON loyalty_rewards
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_product_categories
  BEFORE INSERT ON product_categories
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_products
  BEFORE INSERT ON products
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_inventory
  BEFORE INSERT ON inventory_movements
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_product_sales
  BEFORE INSERT ON product_sales
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_brand
  BEFORE INSERT ON brand_experiences
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_testimonials
  BEFORE INSERT ON testimonials
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_gallery
  BEFORE INSERT ON gallery
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_campaigns
  BEFORE INSERT ON campaigns
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_coupons
  BEFORE INSERT ON coupons
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_membership_plans
  BEFORE INSERT ON membership_plans
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_customer_memberships
  BEFORE INSERT ON customer_memberships
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_audit
  BEFORE INSERT ON audit_logs
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_events
  BEFORE INSERT ON product_events
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_notif_templates
  BEFORE INSERT ON notification_templates
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_automation
  BEFORE INSERT ON automation_rules
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
CREATE TRIGGER trg_set_tenant_id_integrations
  BEFORE INSERT ON integrations
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();

-- set_updated_at em todas as tabelas com updated_at
CREATE TRIGGER trg_updated_at_tenants BEFORE UPDATE ON tenants FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_tenant_themes BEFORE UPDATE ON tenant_themes FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_tenant_features BEFORE UPDATE ON tenant_features FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_users BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_service_categories BEFORE UPDATE ON service_categories FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_services BEFORE UPDATE ON services FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_service_addons BEFORE UPDATE ON service_addons FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_professionals BEFORE UPDATE ON professionals FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_customers BEFORE UPDATE ON customers FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_preferences BEFORE UPDATE ON customer_preferences FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_insights BEFORE UPDATE ON customer_insights FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_appointments BEFORE UPDATE ON appointments FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_payments BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_transactions BEFORE UPDATE ON financial_transactions FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_commissions BEFORE UPDATE ON commission_entries FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_cash_registers BEFORE UPDATE ON cash_registers FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_expenses BEFORE UPDATE ON expenses FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_loyalty BEFORE UPDATE ON loyalty_accounts FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_rewards BEFORE UPDATE ON loyalty_rewards FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_product_categories BEFORE UPDATE ON product_categories FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_products BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_product_sales BEFORE UPDATE ON product_sales FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_brand BEFORE UPDATE ON brand_experiences FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_campaigns BEFORE UPDATE ON campaigns FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_coupons BEFORE UPDATE ON coupons FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_membership_plans BEFORE UPDATE ON membership_plans FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_customer_memberships BEFORE UPDATE ON customer_memberships FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_notif_templates BEFORE UPDATE ON notification_templates FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_automation BEFORE UPDATE ON automation_rules FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_updated_at_integrations BEFORE UPDATE ON integrations FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Triggers de negócio
CREATE TRIGGER trg_calculate_commission
  BEFORE UPDATE OF status ON appointments
  FOR EACH ROW
  WHEN (NEW.status = 'completed' AND OLD.status != 'completed')
  EXECUTE FUNCTION calculate_commission();

CREATE TRIGGER trg_update_stock_on_sale
  AFTER INSERT ON product_sales
  FOR EACH ROW
  EXECUTE FUNCTION update_stock_on_sale();

CREATE TRIGGER trg_create_loyalty_account
  AFTER INSERT ON customers
  FOR EACH ROW
  EXECUTE FUNCTION create_loyalty_account();

CREATE TRIGGER trg_audit_appointments
  AFTER INSERT OR UPDATE OR DELETE ON appointments
  FOR EACH ROW EXECUTE FUNCTION audit_changes();

CREATE TRIGGER trg_audit_payments
  AFTER INSERT OR UPDATE ON payments
  FOR EACH ROW EXECUTE FUNCTION audit_changes();

CREATE TRIGGER trg_audit_customers
  AFTER INSERT OR UPDATE OR DELETE ON customers
  FOR EACH ROW EXECUTE FUNCTION audit_changes();

CREATE TRIGGER trg_events_appointments
  AFTER INSERT OR UPDATE ON appointments
  FOR EACH ROW EXECUTE FUNCTION register_product_event();
