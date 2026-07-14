-- 013_indexes.sql
-- Índices de performance complementares
-- (os índices primários já foram criados junto com cada tabela)

-- ============================================================
-- BOOKING
-- ============================================================
CREATE INDEX idx_appointments_customer_active ON appointments(customer_id) WHERE status NOT IN ('cancelled', 'no_show');
CREATE INDEX idx_appointments_date_range ON appointments(tenant_id, start_at, end_at);

-- ============================================================
-- FINANCIAL
-- ============================================================
CREATE INDEX idx_commissions_status_date ON commission_entries(tenant_id, status, created_at);
CREATE INDEX idx_transactions_reconciled ON financial_transactions(tenant_id) WHERE reconciled = false;
CREATE INDEX idx_expenses_date ON expenses(tenant_id, due_date);

-- ============================================================
-- LOYALTY
-- ============================================================
CREATE INDEX idx_ledger_expiring ON points_ledger(expires_at) WHERE expires_at IS NOT NULL;
CREATE INDEX idx_loyalty_tier_tenant ON loyalty_accounts(tenant_id, tier);

-- ============================================================
-- COMMERCE
-- ============================================================
CREATE INDEX idx_movements_date ON inventory_movements(tenant_id, created_at DESC);
CREATE INDEX idx_sales_date ON product_sales(tenant_id, created_at DESC);

-- ============================================================
-- CRM
-- ============================================================
CREATE INDEX idx_interactions_date ON customer_interactions(tenant_id, created_at DESC);
CREATE INDEX idx_customers_birth_month ON customers(tenant_id, EXTRACT(MONTH FROM birth_date));

-- ============================================================
-- ENGAGEMENT
-- ============================================================
CREATE INDEX idx_campaigns_active_dates ON campaigns(tenant_id, start_at, end_at) WHERE status = 'active';
CREATE INDEX idx_coupons_expiring ON coupons(tenant_id, expires_at) WHERE is_active = true;
CREATE INDEX idx_memberships_next_billing ON customer_memberships(next_billing_at) WHERE status = 'active';

-- ============================================================
-- PLATFORM
-- ============================================================
CREATE INDEX idx_automation_trigger ON automation_rules(trigger_event) WHERE is_active = true;
CREATE INDEX idx_audit_user_action ON audit_logs(user_id, action);
CREATE INDEX idx_events_tenant_type ON product_events(tenant_id, event_type);
