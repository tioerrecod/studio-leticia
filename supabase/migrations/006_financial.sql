-- 006_financial.sql
-- Schema FINANCIAL: payments, transactions, commissions, cash, expenses
-- Depende de: 005_booking.sql (appointments)

-- ============================================================
-- PAYMENTS
-- ============================================================
CREATE TABLE payments (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  appointment_id      UUID NOT NULL REFERENCES appointments(id),
  customer_id         UUID NOT NULL REFERENCES customers(id),
  method              VARCHAR(20) NOT NULL CHECK (method IN ('credit_card', 'debit_card', 'pix', 'cash', 'ticket')),
  amount              DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  installments        INTEGER NOT NULL DEFAULT 1,
  gateway             VARCHAR(50),
  gateway_payment_id  VARCHAR(255),
  gateway_status      VARCHAR(50),
  status              VARCHAR(20) NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending', 'approved', 'refunded', 'declined')),
  paid_at             TIMESTAMPTZ,
  refunded_at         TIMESTAMPTZ,
  metadata            JSONB NOT NULL DEFAULT '{}',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_payments_appointment ON payments(appointment_id);
CREATE INDEX idx_payments_tenant ON payments(tenant_id);
CREATE INDEX idx_payments_gateway ON payments(gateway_payment_id);

-- ============================================================
-- FINANCIAL TRANSACTIONS
-- ============================================================
CREATE TABLE financial_transactions (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  type                VARCHAR(20) NOT NULL CHECK (type IN ('revenue', 'commission', 'expense', 'refund')),
  category            VARCHAR(30) NOT NULL,
  amount              DECIMAL(12,2) NOT NULL CHECK (amount > 0),
  description         TEXT,
  reference_id        UUID,
  reference_type      VARCHAR(30),
  payment_method      VARCHAR(20) CHECK (payment_method IN ('credit_card', 'debit_card', 'pix', 'cash', 'ticket')),
  status              VARCHAR(20) NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
  reconciled          BOOLEAN NOT NULL DEFAULT false,
  reconciled_at       TIMESTAMPTZ,
  metadata            JSONB NOT NULL DEFAULT '{}',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_transactions_tenant_date ON financial_transactions(tenant_id, created_at);
CREATE INDEX idx_transactions_reference ON financial_transactions(reference_id, reference_type);
CREATE INDEX idx_transactions_type ON financial_transactions(tenant_id, type);

-- ============================================================
-- COMMISSION ENTRIES
-- ============================================================
CREATE TABLE commission_entries (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  professional_id   UUID NOT NULL REFERENCES professionals(id),
  appointment_id    UUID NOT NULL REFERENCES appointments(id),
  amount            DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
  percentage        DECIMAL(5,2) NOT NULL,
  status            VARCHAR(20) NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'approved', 'paid')),
  paid_at           TIMESTAMPTZ,
  paid_by           UUID REFERENCES users(id) ON DELETE SET NULL,
  notes             TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_commissions_professional ON commission_entries(professional_id, status);
CREATE INDEX idx_commissions_appointment ON commission_entries(appointment_id);
CREATE INDEX idx_commissions_tenant ON commission_entries(tenant_id);

-- ============================================================
-- CASH REGISTERS
-- ============================================================
CREATE TABLE cash_registers (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  opened_by           UUID NOT NULL REFERENCES users(id),
  closed_by           UUID REFERENCES users(id) ON DELETE SET NULL,
  opened_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  closed_at           TIMESTAMPTZ,
  initial_balance     DECIMAL(12,2) NOT NULL DEFAULT 0,
  expected_balance    DECIMAL(12,2),
  actual_balance      DECIMAL(12,2),
  difference          DECIMAL(12,2) DEFAULT 0,
  difference_reason   TEXT,
  status              VARCHAR(20) NOT NULL DEFAULT 'open'
                      CHECK (status IN ('open', 'closed', 'reconciled')),
  notes               TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_registers_tenant ON cash_registers(tenant_id);
CREATE INDEX idx_registers_status ON cash_registers(tenant_id, status);

-- ============================================================
-- EXPENSES
-- ============================================================
CREATE TABLE expenses (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  category          VARCHAR(30) NOT NULL CHECK (category IN ('rent', 'supplies', 'salary', 'marketing', 'other')),
  description       TEXT NOT NULL,
  amount            DECIMAL(12,2) NOT NULL CHECK (amount > 0),
  payment_method    VARCHAR(20) CHECK (payment_method IN ('credit_card', 'debit_card', 'pix', 'cash', 'ticket')),
  receipt_url       TEXT,
  is_recurring      BOOLEAN NOT NULL DEFAULT false,
  recurring_interval VARCHAR(20) CHECK (recurring_interval IN ('weekly', 'monthly', 'yearly')),
  due_date          DATE,
  paid_at           TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_expenses_tenant ON expenses(tenant_id);
