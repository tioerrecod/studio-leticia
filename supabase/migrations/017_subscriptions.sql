-- 017_subscriptions.sql
-- Assinaturas dos tenants (faturamento SaaS recorrente)
-- Depende de: 016_saas_plans.sql

-- ============================================================
-- SUBSCRIPTIONS
-- ============================================================
CREATE TABLE subscriptions (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id             UUID NOT NULL UNIQUE REFERENCES tenants(id) ON DELETE CASCADE,
  saas_plan_id          UUID NOT NULL REFERENCES saas_plans(id),
  gateway               VARCHAR(30) NOT NULL CHECK (gateway IN ('mercado_pago', 'stripe', 'asaas')),
  gateway_subscription_id VARCHAR(255),
  gateway_customer_id   VARCHAR(255),
  status                VARCHAR(20) NOT NULL DEFAULT 'trial'
                        CHECK (status IN (
                          'trial', 'active', 'past_due', 'canceled',
                          'incomplete', 'incomplete_expired', 'paused', 'ended'
                        )),
  trial_start           TIMESTAMPTZ NOT NULL DEFAULT now(),
  trial_end             TIMESTAMPTZ NOT NULL,
  current_period_start  TIMESTAMPTZ NOT NULL DEFAULT now(),
  current_period_end    TIMESTAMPTZ NOT NULL,
  canceled_at           TIMESTAMPTZ,
  ended_at              TIMESTAMPTZ,
  metadata              JSONB NOT NULL DEFAULT '{}',
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_subscriptions_tenant ON subscriptions(tenant_id);
CREATE INDEX idx_subscriptions_plan ON subscriptions(saas_plan_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_gateway ON subscriptions(gateway_subscription_id);

-- ============================================================
-- INVOICES (histórico de cobranças)
-- ============================================================
CREATE TABLE invoices (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subscription_id       UUID NOT NULL REFERENCES subscriptions(id) ON DELETE CASCADE,
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  amount                DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
  currency              VARCHAR(3) NOT NULL DEFAULT 'BRL',
  status                VARCHAR(20) NOT NULL CHECK (status IN (
                          'pending', 'paid', 'overdue', 'refunded', 'canceled'
                        )),
  gateway_invoice_id    VARCHAR(255),
  billing_reason        VARCHAR(30) NOT NULL CHECK (billing_reason IN ('signup', 'renewal', 'upgrade', 'downgrade')),
  period_start          TIMESTAMPTZ NOT NULL,
  period_end            TIMESTAMPTZ NOT NULL,
  paid_at               TIMESTAMPTZ,
  payment_method        VARCHAR(20) CHECK (payment_method IN ('credit_card', 'pix', 'boleto')),
  metadata              JSONB NOT NULL DEFAULT '{}',
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_invoices_subscription ON invoices(subscription_id);
CREATE INDEX idx_invoices_tenant ON invoices(tenant_id);
CREATE INDEX idx_invoices_status ON invoices(status);
