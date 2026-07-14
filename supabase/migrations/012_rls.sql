-- 012_rls.sql
-- RLS Policies — segurança multi-tenant
-- Depende de: 011_functions.sql (helper functions)

-- ============================================================
-- ATIVAR RLS EM TODAS AS TABELAS
-- ============================================================

-- CORE
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_themes ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_features ENABLE ROW LEVEL SECURITY;

-- IDENTITY
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;

-- BEAUTY
ALTER TABLE service_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_experience_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_addons ENABLE ROW LEVEL SECURITY;
ALTER TABLE professionals ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_specialties ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_commission_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_work_days ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_interactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_insights ENABLE ROW LEVEL SECURITY;

-- BOOKING
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointment_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointment_reminders ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointment_history ENABLE ROW LEVEL SECURITY;

-- FINANCIAL
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE commission_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_registers ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- LOYALTY
ALTER TABLE loyalty_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE points_ledger ENABLE ROW LEVEL SECURITY;
ALTER TABLE loyalty_rewards ENABLE ROW LEVEL SECURITY;

-- COMMERCE
ALTER TABLE product_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_sales ENABLE ROW LEVEL SECURITY;

-- ENGAGEMENT
ALTER TABLE brand_experiences ENABLE ROW LEVEL SECURITY;
ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE gallery ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaign_audience ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupon_usages ENABLE ROW LEVEL SECURITY;
ALTER TABLE membership_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_memberships ENABLE ROW LEVEL SECURITY;

-- PLATFORM
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE automation_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE integrations ENABLE ROW LEVEL SECURITY;

-- roles é tabela de sistema — sem RLS
-- points_ledger segue a account (herdado da loyalty_account)

-- ============================================================
-- POLICIES
-- ============================================================

-- === CORE ===
CREATE POLICY tenant_select ON tenants
  FOR SELECT USING (
    id = get_user_tenant_id() OR get_user_role_level() >= 7
  );
CREATE POLICY tenant_themes_select ON tenant_themes
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY tenant_features_select ON tenant_features
  FOR SELECT USING (tenant_id = get_user_tenant_id());

-- === IDENTITY ===
CREATE POLICY users_select ON users
  FOR SELECT USING (
    id = auth.uid() OR
    (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6)
  );
CREATE POLICY users_insert ON users
  FOR INSERT WITH CHECK (get_user_role_level() >= 6);
CREATE POLICY users_update ON users
  FOR UPDATE USING (
    id = auth.uid() OR
    (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6)
  );
-- user_sessions: próprio user
CREATE POLICY sessions_select ON user_sessions
  FOR SELECT USING (user_id = auth.uid());
CREATE POLICY sessions_insert ON user_sessions
  FOR INSERT WITH CHECK (user_id = auth.uid());

-- === BEAUTY ===
-- service_categories: todos do tenant vêem; admin+ (level >= 6) altera
CREATE POLICY categories_select ON service_categories
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY categories_insert ON service_categories
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);
CREATE POLICY categories_update ON service_categories
  FOR UPDATE USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);

-- services: todos do tenant vêem; admin+ altera
CREATE POLICY services_select ON services
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY services_insert ON services
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);
CREATE POLICY services_update ON services
  FOR UPDATE USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);

-- professionals: todos do tenant vêem; admin+ altera
CREATE POLICY professionals_select ON professionals
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY professionals_insert ON professionals
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);
CREATE POLICY professionals_update ON professionals
  FOR UPDATE USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);
CREATE POLICY professionals_delete ON professionals
  FOR DELETE USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);

-- professional_work_days: professional vê os seus; admin vê todos
CREATE POLICY work_days_select ON professional_work_days
  FOR SELECT USING (
    professional_id = get_user_professional_id() OR
    get_user_role_level() >= 6
  );

-- customers: todos do tenant vêem; professional+ (level >= 3) altera
CREATE POLICY customers_select ON customers
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY customers_insert ON customers
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 3);
CREATE POLICY customers_update ON customers
  FOR UPDATE USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 3);

-- customer_interactions: professional+ vê e cria interações
CREATE POLICY interactions_select ON customer_interactions
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 3);
CREATE POLICY interactions_insert ON customer_interactions
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 3);

-- === BOOKING ===
-- appointments: professional vê os seus; admin vê todos; customer vê os próprios
CREATE POLICY appointments_select ON appointments
  FOR SELECT USING (
    tenant_id = get_user_tenant_id() AND (
      professional_id = get_user_professional_id() OR
      get_user_role_level() >= 6
    )
  );
CREATE POLICY appointments_insert ON appointments
  FOR INSERT WITH CHECK (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 3
  );
CREATE POLICY appointments_update ON appointments
  FOR UPDATE USING (
    tenant_id = get_user_tenant_id() AND (
      professional_id = get_user_professional_id() OR
      get_user_role_level() >= 6
    )
  );

-- === FINANCIAL ===
-- payments: admin+ vê tudo; professional vê os seus appointments
CREATE POLICY payments_select ON payments
  FOR SELECT USING (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5
  );
CREATE POLICY payments_insert ON payments
  FOR INSERT WITH CHECK (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5
  );

-- financial_transactions: apenas admin+ (level >= 6)
CREATE POLICY transactions_select ON financial_transactions
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);
CREATE POLICY transactions_insert ON financial_transactions
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);

-- cash_registers: apenas admin+ (level >= 6)
CREATE POLICY registers_select ON cash_registers
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);

-- === LOYALTY ===
-- loyalty_accounts: customer vê o próprio; admin vê todos do tenant
CREATE POLICY loyalty_select ON loyalty_accounts
  FOR SELECT USING (
    tenant_id = get_user_tenant_id() AND (
      customer_id = get_user_customer_id() OR
      get_user_role_level() >= 5
    )
  );

-- pontos: customer vê o próprio ledger; admin vê todos
CREATE POLICY ledger_select ON points_ledger
  FOR SELECT USING (
    account_id IN (
      SELECT id FROM loyalty_accounts
      WHERE customer_id = get_user_customer_id()
    ) OR get_user_role_level() >= 6
  );

-- === COMMERCE ===
-- products: todos do tenant vêem; admin+ (level >= 6) altera
CREATE POLICY products_select ON products
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY products_insert ON products
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);
CREATE POLICY products_update ON products
  FOR UPDATE USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);

-- product_sales: professional+ (level >= 3) vê e cria
CREATE POLICY sales_select ON product_sales
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 3);
CREATE POLICY sales_insert ON product_sales
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 3);

-- === ENGAGEMENT ===
-- brand_experience: todos do tenant vêem; admin+ altera
CREATE POLICY brand_select ON brand_experiences
  FOR SELECT USING (tenant_id = get_user_tenant_id());

-- testimonials: todos do tenant vêem
CREATE POLICY testimonials_select ON testimonials
  FOR SELECT USING (tenant_id = get_user_tenant_id());

-- gallery: todos do tenant vêem; admin+ altera
CREATE POLICY gallery_select ON gallery
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY gallery_insert ON gallery
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);

-- campaigns: apenas manager+ (level >= 5)
CREATE POLICY campaigns_select ON campaigns
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5);
CREATE POLICY campaigns_insert ON campaigns
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5);

-- coupons: manager+ vê; sistema valida no uso
CREATE POLICY coupons_select ON coupons
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5);
CREATE POLICY coupons_usage_select ON coupon_usages
  FOR SELECT USING (get_user_role_level() >= 3);

-- membership_plans: todos do tenant vêem; admin+ altera
CREATE POLICY plans_select ON membership_plans
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY plans_insert ON membership_plans
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);

-- customer_memberships: customer vê próprio; admin vê todos
CREATE POLICY memberships_select ON customer_memberships
  FOR SELECT USING (
    tenant_id = get_user_tenant_id() AND (
      customer_id = get_user_customer_id() OR
      get_user_role_level() >= 5
    )
  );

-- === PLATFORM ===
-- notification_templates: manager+ gerencia
CREATE POLICY notif_templates_select ON notification_templates
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5);
CREATE POLICY notif_templates_insert ON notification_templates
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5);

-- automation_rules: manager+ gerencia
CREATE POLICY automation_select ON automation_rules
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5);

-- integrations: apenas super admin (level >= 7)
CREATE POLICY integrations_select ON integrations
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 7);
CREATE POLICY integrations_insert ON integrations
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 7);

-- product_events: INSERT apenas via trigger ou edge function; SELECT admin+
CREATE POLICY events_select ON product_events
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);

-- audit_logs: admin+ vê logs do tenant
CREATE POLICY audit_select ON audit_logs
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6);
