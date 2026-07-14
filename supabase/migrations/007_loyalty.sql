-- 007_loyalty.sql
-- Schema LOYALTY: accounts, points ledger (event-sourced), rewards
-- Depende de: 004_beauty.sql (customers)

-- ============================================================
-- LOYALTY ACCOUNTS
-- ============================================================
CREATE TABLE loyalty_accounts (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  tier              VARCHAR(20) NOT NULL DEFAULT 'bronze'
                    CHECK (tier IN ('bronze', 'silver', 'gold', 'platinum')),
  current_points    INTEGER NOT NULL DEFAULT 0,
  lifetime_points   INTEGER NOT NULL DEFAULT 0,
  tier_updated_at   TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, customer_id)
);

CREATE INDEX idx_loyalty_tenant ON loyalty_accounts(tenant_id);
CREATE INDEX idx_loyalty_tier ON loyalty_accounts(tier);

-- ============================================================
-- POINTS LEDGER (event-sourced)
-- ============================================================
CREATE TABLE points_ledger (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id        UUID NOT NULL REFERENCES loyalty_accounts(id) ON DELETE CASCADE,
  type              VARCHAR(20) NOT NULL CHECK (type IN ('earned', 'redeemed', 'expired', 'adjusted')),
  amount            INTEGER NOT NULL,
  balance_after     INTEGER NOT NULL,
  reference_id      UUID,
  reference_type    VARCHAR(30) CHECK (reference_type IN ('appointment', 'reward', 'indication', 'adjustment')),
  description       VARCHAR(255) NOT NULL,
  expires_at        DATE,
  redeemed_at       DATE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_ledger_account ON points_ledger(account_id);
CREATE INDEX idx_ledger_created ON points_ledger(account_id, created_at DESC);
CREATE INDEX idx_ledger_expires ON points_ledger(account_id) WHERE expires_at IS NOT NULL;

-- ============================================================
-- LOYALTY REWARDS
-- ============================================================
CREATE TABLE loyalty_rewards (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name              VARCHAR(255) NOT NULL,
  description       TEXT,
  points_cost       INTEGER NOT NULL CHECK (points_cost > 0),
  reward_type       VARCHAR(30) NOT NULL CHECK (reward_type IN ('discount', 'product', 'service', 'upgrade')),
  discount_value    DECIMAL(10,2),
  service_id        UUID REFERENCES services(id) ON DELETE SET NULL,
  image_url         TEXT,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_rewards_tenant ON loyalty_rewards(tenant_id);
