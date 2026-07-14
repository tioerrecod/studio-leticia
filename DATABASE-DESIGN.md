# DATABASE DESIGN — Studio Letícia Experience v1.1

**Baseado em**: DOMAIN MODEL v1.0 + ARCHITECTURE v1.0 + PRD v1.0
**Stack**: PostgreSQL 15+ via Supabase

---

## Sumário

1. [Schema CORE — tenants, plans, features](#1-schema-core)
2. [Schema IDENTITY — users, roles, sessions](#2-schema-identity)
3. [Schema BEAUTY — professionals, services, customers, interactions, insights](#3-schema-beauty)
4. [Schema BOOKING — appointments, reminders, history](#4-schema-booking)
5. [Schema FINANCIAL — payments, transactions, commissions](#5-schema-financial)
6. [Schema LOYALTY — accounts, points ledger](#6-schema-loyalty)
7. [Schema COMMERCE — products, inventory, sales](#7-schema-commerce)
8. [Schema ENGAGEMENT — brand experience, campaigns, coupons, memberships](#8-schema-engagement)
9. [Schema PLATFORM — audit, events, integrations, notifications, automations](#9-schema-platform)
10. [RLS Policies](#10-rls-policies)
11. [Triggers & Functions](#11-triggers--functions)
12. [Índices](#12-indices)
13. [Seed Data](#13-seed-data)
14. [Migration Plan](#14-migration-plan)
15. [Futuras Migrações](#15-futuras-migracoes)

---

## 1. Schema CORE

### tenants

```sql
CREATE TABLE tenants (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          VARCHAR(255) NOT NULL,
  slug          VARCHAR(100) NOT NULL UNIQUE,
  logo_url      TEXT,
  plan          VARCHAR(20) NOT NULL DEFAULT 'starter'
                CHECK (plan IN ('starter', 'professional', 'enterprise')),
  status        VARCHAR(20) NOT NULL DEFAULT 'trial'
                CHECK (status IN ('active', 'suspended', 'trial', 'cancelled')),
  settings      JSONB NOT NULL DEFAULT '{}',
  domain        VARCHAR(255),
  timezone      VARCHAR(50) NOT NULL DEFAULT 'America/Sao_Paulo',
  locale        VARCHAR(10) NOT NULL DEFAULT 'pt-BR',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### tenant_themes

Separado do tenant para suportar **white-label** desde o início. Cada tenant tem seu próprio tema visual.

```sql
CREATE TABLE tenant_themes (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  primary_color     VARCHAR(7) NOT NULL DEFAULT '#D81B60',
  secondary_color   VARCHAR(7) NOT NULL DEFAULT '#FFB300',
  background_color  VARCHAR(7) NOT NULL DEFAULT '#F5F0EB',
  font_heading      VARCHAR(100) NOT NULL DEFAULT 'Playfair Display',
  font_body         VARCHAR(100) NOT NULL DEFAULT 'Inter',
  logo_url          TEXT,
  favicon_url       TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id)
);
```

### tenant_features

Feature flags por tenant — libera funcionalidades progressivamente.

```sql
CREATE TABLE tenant_features (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  key         VARCHAR(100) NOT NULL,
  name        VARCHAR(255) NOT NULL,
  is_enabled  BOOLEAN NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, key)
);
```

---

## 2. Schema IDENTITY

### roles

```sql
CREATE TABLE roles (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            VARCHAR(50) NOT NULL,
  hierarchy_level INTEGER NOT NULL CHECK (hierarchy_level BETWEEN 1 AND 9),
  description     TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO roles (name, hierarchy_level, description) VALUES
  ('customer', 1, 'Cliente final'),
  ('customer_vip', 2, 'Cliente VIP'),
  ('professional', 3, 'Profissional'),
  ('senior_professional', 4, 'Profissional sênior'),
  ('manager', 5, 'Gerente'),
  ('admin', 6, 'Administrador do tenant'),
  ('super_admin_1', 7, 'Super admin nível 1'),
  ('super_admin_2', 8, 'Super admin nível 2'),
  ('system_owner', 9, 'Dono do sistema');
```

### users

```sql
CREATE TABLE users (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  auth_user_id    UUID UNIQUE,          -- Supabase Auth
  email           VARCHAR(255),
  phone           VARCHAR(20),
  name            VARCHAR(255) NOT NULL,
  avatar_url      TEXT,
  role_id         UUID NOT NULL REFERENCES roles(id),
  is_active       BOOLEAN NOT NULL DEFAULT true,
  mfa_enabled     BOOLEAN NOT NULL DEFAULT false,
  last_login_at   TIMESTAMPTZ,
  metadata        JSONB NOT NULL DEFAULT '{}',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_users_tenant ON users(tenant_id);
CREATE INDEX idx_users_auth ON users(auth_user_id);
CREATE UNIQUE INDEX idx_users_tenant_email ON users(tenant_id, email) WHERE email IS NOT NULL;
```

### user_sessions

```sql
CREATE TABLE user_sessions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  ip_address    VARCHAR(45),
  user_agent    TEXT,
  mfa_verified  BOOLEAN NOT NULL DEFAULT false,
  expires_at    TIMESTAMPTZ NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_sessions_user ON user_sessions(user_id);
```

---

## 3. Schema BEAUTY

### service_categories

```sql
CREATE TABLE service_categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  description TEXT,
  icon        VARCHAR(50),
  sort_order  INTEGER NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_categories_tenant ON service_categories(tenant_id);
```

### services

Evoluído para **ServiceExperience**: inclui before/during/after steps e fluxo de experiência.

```sql
CREATE TABLE services (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  category_id           UUID REFERENCES service_categories(id),
  name                  VARCHAR(255) NOT NULL,
  description           TEXT,
  duration              INTEGER NOT NULL CHECK (duration > 0),  -- minutos
  price                 DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  promotional_price     DECIMAL(10,2) CHECK (promotional_price IS NULL OR promotional_price >= 0),
  commission_percentage DECIMAL(5,2) NOT NULL DEFAULT 50.00 CHECK (commission_percentage BETWEEN 0 AND 100),
  is_active             BOOLEAN NOT NULL DEFAULT true,
  image_url             TEXT,
  sort_order            INTEGER NOT NULL DEFAULT 0,
  is_signature          BOOLEAN NOT NULL DEFAULT false,          -- serviço exclusivo do salão
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_services_tenant ON services(tenant_id);
CREATE INDEX idx_services_category ON services(category_id);
CREATE INDEX idx_services_signature ON services(tenant_id) WHERE is_signature = true;
```

### service_experience_steps

Transforma serviço em jornada de experiência — antes, durante e depois.

```sql
CREATE TABLE service_experience_steps (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_id    UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  moment        VARCHAR(20) NOT NULL CHECK (moment IN ('before', 'during', 'after')),
  step_order    INTEGER NOT NULL,
  title         VARCHAR(255) NOT NULL,
  description   TEXT,
  duration_min  INTEGER,                     -- duração estimada do passo
  media_url     TEXT,                        -- foto/vídeo ilustrativo
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_exp_steps_service ON service_experience_steps(service_id);
```

### service_addons

```sql
CREATE TABLE service_addons (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  service_id  UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  price       DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  duration    INTEGER CHECK (duration IS NULL OR duration > 0),
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### professionals

```sql
CREATE TABLE professionals (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id             UUID REFERENCES users(id) ON DELETE SET NULL,
  name                VARCHAR(255) NOT NULL,
  bio                 TEXT,
  photo_url           TEXT,
  commission_default  DECIMAL(5,2) NOT NULL DEFAULT 50.00 CHECK (commission_default BETWEEN 0 AND 100),
  is_active           BOOLEAN NOT NULL DEFAULT true,
  rating_avg          DECIMAL(3,2) DEFAULT 0 CHECK (rating_avg BETWEEN 0 AND 5),
  rating_count        INTEGER NOT NULL DEFAULT 0,
  total_revenue       DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_appointments  INTEGER NOT NULL DEFAULT 0,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_professionals_tenant ON professionals(tenant_id);
CREATE INDEX idx_professionals_user ON professionals(user_id);
```

### professional_specialties

```sql
CREATE TABLE professional_specialties (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id UUID NOT NULL REFERENCES professionals(id) ON DELETE CASCADE,
  service_id      UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  UNIQUE(professional_id, service_id)
);
```

### professional_commission_rules

```sql
CREATE TABLE professional_commission_rules (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id UUID NOT NULL REFERENCES professionals(id) ON DELETE CASCADE,
  rule_type       VARCHAR(20) NOT NULL CHECK (rule_type IN ('default', 'per_service', 'per_category')),
  service_id      UUID REFERENCES services(id) ON DELETE CASCADE,
  category_id     UUID REFERENCES service_categories(id) ON DELETE CASCADE,
  percentage      DECIMAL(5,2) NOT NULL CHECK (percentage BETWEEN 0 AND 100),
  fixed_value     DECIMAL(10,2) CHECK (fixed_value IS NULL OR fixed_value >= 0),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT commission_rule_target CHECK (
    (rule_type = 'default' AND service_id IS NULL AND category_id IS NULL) OR
    (rule_type = 'per_service' AND service_id IS NOT NULL AND category_id IS NULL) OR
    (rule_type = 'per_category' AND service_id IS NULL AND category_id IS NOT NULL)
  )
);

CREATE INDEX idx_commission_rules_professional ON professional_commission_rules(professional_id);
```

### professional_work_days

```sql
CREATE TABLE professional_work_days (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id UUID NOT NULL REFERENCES professionals(id) ON DELETE CASCADE,
  day_of_week     INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
  start_time      TIME NOT NULL,
  end_time        TIME NOT NULL,
  break_start     TIME,
  break_end       TIME,
  is_available    BOOLEAN NOT NULL DEFAULT true,
  UNIQUE(professional_id, day_of_week)
);
```

### professional_ratings

```sql
CREATE TABLE professional_ratings (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id   UUID NOT NULL REFERENCES professionals(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL,
  appointment_id    UUID NOT NULL,
  score             INTEGER NOT NULL CHECK (score BETWEEN 1 AND 5),
  comment           TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(appointment_id)
);
```

### customers

```sql
CREATE TABLE customers (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id               UUID REFERENCES users(id) ON DELETE SET NULL,
  name                  VARCHAR(255) NOT NULL,
  email                 VARCHAR(255),
  phone                 VARCHAR(20),
  birth_date            DATE,
  gender                VARCHAR(30),
  photo_url             TEXT,
  notes                 TEXT,
  tags                  TEXT[] NOT NULL DEFAULT '{}',
  source                VARCHAR(20) DEFAULT 'walkin'
                        CHECK (source IN ('whatsapp', 'app', 'walkin', 'indication', 'instagram')),
  indication_by         UUID REFERENCES customers(id) ON DELETE SET NULL,
  total_visits          INTEGER NOT NULL DEFAULT 0,
  total_spent           DECIMAL(12,2) NOT NULL DEFAULT 0,
  last_visit_at         TIMESTAMPTZ,
  ltv                   DECIMAL(12,2) NOT NULL DEFAULT 0,       -- lifetime value
  churn_score           DECIMAL(5,4) NOT NULL DEFAULT 0,         -- 0.0000 a 1.0000
  consent_marketing     BOOLEAN NOT NULL DEFAULT false,
  consent_whatsapp      BOOLEAN NOT NULL DEFAULT false,
  consent_terms_version VARCHAR(20),
  consented_at          TIMESTAMPTZ,
  revoked_at            TIMESTAMPTZ,
  deleted_at            TIMESTAMPTZ,                              -- soft delete LGPD
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_customers_tenant ON customers(tenant_id);
CREATE INDEX idx_customers_phone ON customers(tenant_id, phone);
CREATE INDEX idx_customers_source ON customers(source);
CREATE INDEX idx_customers_ltv ON customers(tenant_id, ltv DESC);
CREATE INDEX idx_customers_birth ON customers(tenant_id, birth_date);
```

### customer_preferences

```sql
CREATE TABLE customer_preferences (
  id                        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id               UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  preferred_professional_id UUID REFERENCES professionals(id) ON DELETE SET NULL,
  preferred_services        UUID[] NOT NULL DEFAULT '{}',
  notes_on_services         TEXT,
  communication_channel     VARCHAR(20) DEFAULT 'whatsapp'
                            CHECK (communication_channel IN ('whatsapp', 'push', 'email')),
  created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(customer_id)
);
```

### customer_interactions (CRM)

Histórico completo de interações com o cliente — alimenta a IA de relacionamento.

```sql
CREATE TABLE customer_interactions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  type              VARCHAR(30) NOT NULL CHECK (type IN (
                    'call', 'whatsapp', 'email', 'in_person',
                    'complaint', 'feedback', 'birthday', 'campaign',
                    'system', 'appointment_reminder', 'note'
                  )),
  summary           TEXT NOT NULL,
  detail            TEXT,                          -- conteúdo completo da interação
  sentiment         VARCHAR(10) CHECK (sentiment IN ('positive', 'neutral', 'negative')),
  channel           VARCHAR(20) CHECK (channel IN ('whatsapp', 'push', 'email', 'in_person', 'phone')),
  performed_by      UUID REFERENCES users(id) ON DELETE SET NULL,
  appointment_id    UUID REFERENCES appointments(id) ON DELETE SET NULL,
  metadata          JSONB NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_interactions_customer ON customer_interactions(customer_id, created_at DESC);
CREATE INDEX idx_interactions_type ON customer_interactions(tenant_id, type);
CREATE INDEX idx_interactions_sentiment ON customer_interactions(tenant_id, sentiment);
```

### customer_insights

Dados que alimentam IA e recomendações — coletados desde o início para ter histórico.

```sql
CREATE TABLE customer_insights (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id           UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  hair_type             VARCHAR(50),                          -- liso, ondulado, cacheado, crespo
  hair_conditions       TEXT[] NOT NULL DEFAULT '{}',          -- ["ressecado", "colorido", "oleoso"]
  skin_type             VARCHAR(50),                           -- normal, seca, oleosa, mista
  skin_sensitivies      TEXT[] NOT NULL DEFAULT '{}',
  favorite_services     UUID[] NOT NULL DEFAULT '{}',
  avoid_services        UUID[] NOT NULL DEFAULT '{}',
  purchase_patterns     JSONB NOT NULL DEFAULT '{}',           -- {"avg_ticket": 120, "frequency_days": 45, "preferred_day": "saturday"}
  ai_notes              TEXT,                                  -- notas geradas por IA
  last_updated_by       UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(customer_id)
);
```

---

## 4. Schema BOOKING

### appointments

```sql
CREATE TABLE appointments (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id         UUID NOT NULL REFERENCES customers(id),
  professional_id     UUID NOT NULL REFERENCES professionals(id),
  start_at            TIMESTAMPTZ NOT NULL,
  end_at              TIMESTAMPTZ NOT NULL,
  status              VARCHAR(20) NOT NULL DEFAULT 'requested'
                      CHECK (status IN (
                        'requested', 'scheduled', 'confirmed', 'arrived',
                        'in_progress', 'completed', 'paid',
                        'cancelled', 'no_show', 'rescheduled'
                      )),
  total_amount        DECIMAL(10,2) NOT NULL DEFAULT 0,
  commission_amount   DECIMAL(10,2) NOT NULL DEFAULT 0,
  source              VARCHAR(20) NOT NULL DEFAULT 'app_admin'
                      CHECK (source IN ('app_online', 'app_admin', 'whatsapp', 'walkin')),
  arrived_at          TIMESTAMPTZ,
  notes               TEXT,
  reschedule_count    INTEGER NOT NULL DEFAULT 0,
  reschedule_from     UUID REFERENCES appointments(id) ON DELETE SET NULL,
  cancelled_at        TIMESTAMPTZ,
  cancellation_reason VARCHAR(20) CHECK (cancellation_reason IN (
                        'customer', 'professional', 'no_show', 'system'
                      )),
  cancelled_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  metadata            JSONB NOT NULL DEFAULT '{}',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT valid_end CHECK (end_at > start_at)
);

-- Índices críticos de performance
CREATE INDEX idx_appointments_tenant_date ON appointments(tenant_id, start_at);
CREATE INDEX idx_appointments_professional_date ON appointments(professional_id, start_at);
CREATE INDEX idx_appointments_customer ON appointments(customer_id);
CREATE INDEX idx_appointments_status ON appointments(tenant_id, status);
CREATE INDEX idx_appointments_date_status ON appointments(start_at, status);
-- Previne overlap: professional não pode ter 2 appointments no mesmo horário
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE INDEX idx_appointments_no_overlap
  ON appointments USING gist (professional_id, tstzrange(start_at, end_at))
  WHERE status NOT IN ('cancelled', 'no_show');
```

### appointment_services

```sql
CREATE TABLE appointment_services (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_id    UUID NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
  service_id        UUID NOT NULL REFERENCES services(id),
  name              VARCHAR(255) NOT NULL,
  duration          INTEGER NOT NULL,
  price             DECIMAL(10,2) NOT NULL,
  commission_pct    DECIMAL(5,2) NOT NULL,
  sort_order        INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_appt_services_appointment ON appointment_services(appointment_id);
```

### appointment_reminders

```sql
CREATE TABLE appointment_reminders (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_id  UUID NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
  type            VARCHAR(20) NOT NULL CHECK (type IN ('24h', '1h', 'confirmation')),
  channel         VARCHAR(20) NOT NULL CHECK (channel IN ('push', 'whatsapp', 'email')),
  sent_at         TIMESTAMPTZ,
  confirmed       BOOLEAN NOT NULL DEFAULT false,
  response_at     TIMESTAMPTZ,
  error_message   TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_reminders_appointment ON appointment_reminders(appointment_id);
```

### appointment_history

```sql
CREATE TABLE appointment_history (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_id    UUID NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
  previous_status   VARCHAR(20),
  new_status        VARCHAR(20) NOT NULL,
  changed_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  reason            TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_history_appointment ON appointment_history(appointment_id);
```

---

## 5. Schema FINANCIAL

### payments

```sql
CREATE TABLE payments (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  appointment_id      UUID NOT NULL REFERENCES appointments(id),
  customer_id         UUID NOT NULL REFERENCES customers(id),
  method              VARCHAR(20) NOT NULL CHECK (method IN ('credit_card', 'debit_card', 'pix', 'cash', 'ticket')),
  amount              DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  installments        INTEGER NOT NULL DEFAULT 1,
  gateway             VARCHAR(50),                         -- 'mercado_pago' ou null para dinheiro
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
```

### financial_transactions

```sql
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
```

### commission_entries

```sql
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
```

### cash_registers

```sql
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
```

### expenses

```sql
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
```

---

## 6. Schema LOYALTY

### loyalty_accounts

```sql
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
```

### points_ledger (event-sourced)

```sql
CREATE TABLE points_ledger (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id        UUID NOT NULL REFERENCES loyalty_accounts(id) ON DELETE CASCADE,
  type              VARCHAR(20) NOT NULL CHECK (type IN ('earned', 'redeemed', 'expired', 'adjusted')),
  amount            INTEGER NOT NULL,                              -- positivo para earned, negativo para redeemed/expired
  balance_after     INTEGER NOT NULL,                              -- saldo após esta entry
  reference_id      UUID,                                          -- appointment_id, product_id, etc.
  reference_type    VARCHAR(30) CHECK (reference_type IN ('appointment', 'reward', 'indication', 'adjustment')),
  description       VARCHAR(255) NOT NULL,
  expires_at        DATE,                                          -- pontos expiram em 12 meses
  redeemed_at       DATE,                                          -- quando foi resgatado
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_ledger_account ON points_ledger(account_id);
CREATE INDEX idx_ledger_created ON points_ledger(account_id, created_at DESC);
CREATE INDEX idx_ledger_expires ON points_ledger(account_id) WHERE expires_at IS NOT NULL;
```

### loyalty_rewards

```sql
CREATE TABLE loyalty_rewards (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name              VARCHAR(255) NOT NULL,
  description       TEXT,
  points_cost       INTEGER NOT NULL CHECK (points_cost > 0),
  reward_type       VARCHAR(30) NOT NULL CHECK (reward_type IN ('discount', 'product', 'service', 'upgrade')),
  discount_value    DECIMAL(10,2),                                  -- R$ de desconto
  service_id        UUID REFERENCES services(id) ON DELETE SET NULL, -- serviço gratuito
  image_url         TEXT,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_rewards_tenant ON loyalty_rewards(tenant_id);
```

---

## 7. Schema COMMERCE

### product_categories

```sql
CREATE TABLE product_categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  description TEXT,
  icon        VARCHAR(50),
  sort_order  INTEGER NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_product_categories_tenant ON product_categories(tenant_id);
```

### products

Produtos físicos vendidos pelo salão: shampoo, máscara, cosméticos, kits.

```sql
CREATE TABLE products (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  category_id       UUID REFERENCES product_categories(id),
  name              VARCHAR(255) NOT NULL,
  brand             VARCHAR(255),
  description       TEXT,
  price             DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  cost_price        DECIMAL(10,2) CHECK (cost_price IS NULL OR cost_price >= 0),
  stock_quantity    INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
  min_stock         INTEGER NOT NULL DEFAULT 5,                 -- alerta de estoque baixo
  barcode           VARCHAR(100),
  image_url         TEXT,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  is_service        BOOLEAN NOT NULL DEFAULT false,            -- produto atrelado a serviço?
  service_id        UUID REFERENCES services(id) ON DELETE SET NULL,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_tenant ON products(tenant_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_low_stock ON products(tenant_id) WHERE stock_quantity <= min_stock;
```

### inventory_movements

```sql
CREATE TABLE inventory_movements (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  product_id        UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  type              VARCHAR(20) NOT NULL CHECK (type IN ('in', 'out', 'adjustment', 'sale', 'return')),
  quantity          INTEGER NOT NULL,                           -- positivo para entrada, negativo para saída
  quantity_after    INTEGER NOT NULL,                           -- estoque após movimento
  reference_id      UUID,                                       -- sale_id, purchase_order_id, etc.
  reference_type    VARCHAR(30),
  description       TEXT,
  created_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_movements_product ON inventory_movements(product_id, created_at DESC);
CREATE INDEX idx_movements_tenant ON inventory_movements(tenant_id);
```

### product_sales

```sql
CREATE TABLE product_sales (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id),
  appointment_id    UUID REFERENCES appointments(id) ON DELETE SET NULL,
  items             JSONB NOT NULL DEFAULT '[]',                -- [{product_id, name, quantity, unit_price, total}]
  subtotal          DECIMAL(10,2) NOT NULL,
  discount          DECIMAL(10,2) NOT NULL DEFAULT 0,
  total             DECIMAL(10,2) NOT NULL,
  payment_method    VARCHAR(20) CHECK (payment_method IN ('credit_card', 'debit_card', 'pix', 'cash', 'ticket')),
  payment_status    VARCHAR(20) NOT NULL DEFAULT 'pending'
                    CHECK (payment_status IN ('pending', 'paid', 'refunded')),
  notes             TEXT,
  created_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_sales_tenant ON product_sales(tenant_id);
CREATE INDEX idx_sales_customer ON product_sales(customer_id);
CREATE INDEX idx_sales_appointment ON product_sales(appointment_id);
```

---

## 8. Schema ENGAGEMENT

### brand_experience

A **Brand Experience Engine** — o diferencial premium do Studio Letícia. Cada tenant personaliza a experiência do cliente ao abrir o app.

```sql
CREATE TABLE brand_experiences (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  welcome_title     VARCHAR(255) NOT NULL DEFAULT 'Sua próxima experiência começa aqui',
  welcome_subtitle  VARCHAR(255),
  mood_description  TEXT,                     -- tom de voz, personalidade da marca
  hero_images       TEXT[] NOT NULL DEFAULT '{}',
  instagram_handle  VARCHAR(100),
  instagram_token   TEXT,                     -- para embed do feed
  about_text        TEXT,                     -- história do salão
  address           TEXT,
  phone             VARCHAR(20),
  whatsapp_number   VARCHAR(20),
  business_hours    JSONB NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id)
);
```

### testimonials

```sql
CREATE TABLE testimonials (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_name     VARCHAR(255) NOT NULL,
  customer_photo    TEXT,
  text              TEXT NOT NULL,
  service_name      VARCHAR(255),
  rating            INTEGER CHECK (rating BETWEEN 1 AND 5),
  is_featured       BOOLEAN NOT NULL DEFAULT false,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_testimonials_tenant ON testimonials(tenant_id);
CREATE INDEX idx_testimonials_featured ON testimonials(tenant_id) WHERE is_featured = true;
```

### gallery

```sql
CREATE TABLE gallery (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  image_url         TEXT NOT NULL,
  thumbnail_url     TEXT,
  alt_text          VARCHAR(255),
  category          VARCHAR(50) CHECK (category IN ('salon', 'before_after', 'team', 'products', 'events')),
  before_image_url  TEXT,                     -- para before & after
  after_image_url   TEXT,                     -- para before & after
  is_featured       BOOLEAN NOT NULL DEFAULT false,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_gallery_tenant ON gallery(tenant_id);
CREATE INDEX idx_gallery_category ON gallery(tenant_id, category);
```

### campaigns

```sql
CREATE TABLE campaigns (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name              VARCHAR(255) NOT NULL,
  description       TEXT,
  type              VARCHAR(30) NOT NULL CHECK (type IN (
                    'promotion', 'birthday', 'season', 'retargeting',
                    'welcome', 'loyalty', 'referral', 'holiday'
                  )),
  trigger_type      VARCHAR(30) NOT NULL CHECK (trigger_type IN ('auto', 'manual', 'scheduled')),
  audience_segment  JSONB NOT NULL DEFAULT '{}',                 -- filtros: {tags, min_visits, max_days_since_last, services}
  channel           VARCHAR(20)[] NOT NULL DEFAULT '{whatsapp}',
  message_template  TEXT,
  start_at          TIMESTAMPTZ,
  end_at            TIMESTAMPTZ,
  status            VARCHAR(20) NOT NULL DEFAULT 'draft'
                    CHECK (status IN ('draft', 'scheduled', 'active', 'finished', 'cancelled')),
  sent_count        INTEGER NOT NULL DEFAULT 0,
  opened_count      INTEGER NOT NULL DEFAULT 0,
  conversion_count  INTEGER NOT NULL DEFAULT 0,
  created_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_campaigns_tenant ON campaigns(tenant_id);
CREATE INDEX idx_campaigns_status ON campaigns(tenant_id, status);
```

### campaign_audience

```sql
CREATE TABLE campaign_audience (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id       UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  sent_at           TIMESTAMPTZ,
  opened_at         TIMESTAMPTZ,
  clicked_at        TIMESTAMPTZ,
  converted_at      TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(campaign_id, customer_id)
);

CREATE INDEX idx_campaign_audience ON campaign_audience(campaign_id);
```

### coupons

```sql
CREATE TABLE coupons (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  code              VARCHAR(50) NOT NULL,
  type              VARCHAR(20) NOT NULL CHECK (type IN ('percentage', 'fixed', 'free_service', 'free_product')),
  value             DECIMAL(10,2) NOT NULL,                      -- percentual ou valor fixo
  min_value         DECIMAL(10,2) DEFAULT 0,                     -- valor mínimo da compra
  max_uses          INTEGER DEFAULT 0,                            -- 0 = ilimitado
  current_uses      INTEGER NOT NULL DEFAULT 0,
  max_uses_per_customer INTEGER DEFAULT 1,
  applicable_services UUID[] DEFAULT '{}',                        -- vazio = todos
  applicable_products  UUID[] DEFAULT '{}',                       -- vazio = todos
  starts_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at        TIMESTAMPTZ,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, code)
);

CREATE INDEX idx_coupons_tenant ON coupons(tenant_id);
CREATE INDEX idx_coupons_code ON coupons(tenant_id, code);
CREATE INDEX idx_coupons_active ON coupons(tenant_id) WHERE is_active = true;
```

### coupon_usages

```sql
CREATE TABLE coupon_usages (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_id         UUID NOT NULL REFERENCES coupons(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  appointment_id    UUID REFERENCES appointments(id) ON DELETE SET NULL,
  product_sale_id   UUID REFERENCES product_sales(id) ON DELETE SET NULL,
  discount_amount   DECIMAL(10,2) NOT NULL,
  used_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_coupon_usages_coupon ON coupon_usages(coupon_id);
CREATE INDEX idx_coupon_usages_customer ON coupon_usages(customer_id);
```

### membership_plans

Receita previsível — planos mensais com serviços inclusos.

```sql
CREATE TABLE membership_plans (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name              VARCHAR(255) NOT NULL,
  description       TEXT,
  monthly_price     DECIMAL(10,2) NOT NULL CHECK (monthly_price > 0),
  billing_cycle     VARCHAR(20) NOT NULL DEFAULT 'monthly' CHECK (billing_cycle IN ('monthly', 'quarterly', 'yearly')),
  services_included JSONB NOT NULL DEFAULT '[]',   -- [{service_id, quantity, discount_pct}]
  benefits          TEXT[] NOT NULL DEFAULT '{}',   -- ["prioridade na agenda", "desconto 20% produtos"]
  max_active        INTEGER NOT NULL DEFAULT 0,      -- 0 = ilimitado
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_plans_tenant ON membership_plans(tenant_id);
```

### customer_memberships

```sql
CREATE TABLE customer_memberships (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  plan_id           UUID NOT NULL REFERENCES membership_plans(id),
  status            VARCHAR(20) NOT NULL DEFAULT 'active'
                    CHECK (status IN ('active', 'cancelled', 'expired', 'trial')),
  started_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  next_billing_at   TIMESTAMPTZ NOT NULL,
  cancelled_at      TIMESTAMPTZ,
  payment_method    VARCHAR(20) CHECK (payment_method IN ('credit_card', 'pix')),
  gateway_subscription_id VARCHAR(255),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, customer_id)
);

CREATE INDEX idx_memberships_customer ON customer_memberships(customer_id);
CREATE INDEX idx_memberships_status ON customer_memberships(status);
```

---

## 9. Schema PLATFORM

### audit_logs

```sql
CREATE TABLE audit_logs (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id       UUID REFERENCES users(id) ON DELETE SET NULL,
  action        VARCHAR(20) NOT NULL CHECK (action IN ('create', 'update', 'delete', 'login', 'logout')),
  entity_type   VARCHAR(50) NOT NULL,
  entity_id     UUID,
  before        JSONB,
  after         JSONB,
  ip_address    VARCHAR(45),
  user_agent    TEXT,
  session_id    UUID,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_audit_tenant ON audit_logs(tenant_id, created_at DESC);
CREATE INDEX idx_audit_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_user ON audit_logs(user_id);
```

### product_events

```sql
CREATE TABLE product_events (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  event_type    VARCHAR(100) NOT NULL,
  source        VARCHAR(30) NOT NULL CHECK (source IN ('customer_app', 'pro_app', 'admin_web', 'edge_function', 'webhook')),
  properties    JSONB NOT NULL DEFAULT '{}',
  user_id       UUID REFERENCES users(id) ON DELETE SET NULL,
  anonymous_id  VARCHAR(255),
  session_id    UUID,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_events_tenant ON product_events(tenant_id, created_at DESC);
CREATE INDEX idx_events_type ON product_events(event_type);
CREATE INDEX idx_events_created ON product_events(created_at);
```

### notification_templates

Templates reutilizáveis para push, WhatsApp e e-mail — cada tenant personaliza.

```sql
CREATE TABLE notification_templates (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  channel           VARCHAR(20) NOT NULL CHECK (channel IN ('push', 'whatsapp', 'email')),
  event_type        VARCHAR(50) NOT NULL,                       -- appointment_confirmed, payment_approved, birthday
  title             VARCHAR(255),                                -- usado em push
  body              TEXT NOT NULL,                               -- suporta {{variaveis}}
  variables         JSONB NOT NULL DEFAULT '[]',                 -- ["customer_name", "appointment_date", "professional_name"]
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, channel, event_type)
);

CREATE INDEX idx_notif_templates_tenant ON notification_templates(tenant_id);
```

### automation_rules

Regras de automação de notificações — dispara mensagens automaticamente baseado em eventos.

```sql
CREATE TABLE automation_rules (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name              VARCHAR(255) NOT NULL,
  trigger_event     VARCHAR(50) NOT NULL,                       -- appointment.scheduled, appointment.reminder_24h
  trigger_delay     INTEGER NOT NULL DEFAULT 0,                  -- minutos após o evento (0 = imediato)
  channel           VARCHAR(20) NOT NULL CHECK (channel IN ('push', 'whatsapp', 'email')),
  template_id       UUID REFERENCES notification_templates(id) ON DELETE SET NULL,
  audience_filter   JSONB NOT NULL DEFAULT '{}',                 -- {tags_incluir: [], tags_excluir: []}
  is_active         BOOLEAN NOT NULL DEFAULT true,
  last_triggered_at TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_automation_tenant ON automation_rules(tenant_id);
CREATE INDEX idx_automation_event ON automation_rules(trigger_event);
```

### integrations

```sql
CREATE TABLE integrations (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  provider          VARCHAR(50) NOT NULL CHECK (provider IN ('mercado_pago', 'google', 'whatsapp', 'openai', 'posthog')),
  credentials       JSONB NOT NULL DEFAULT '{}',   -- encriptado
  settings          JSONB NOT NULL DEFAULT '{}',
  is_active         BOOLEAN NOT NULL DEFAULT false,
  last_sync_at      TIMESTAMPTZ,
  error_message     TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, provider)
);
```

---

## 10. RLS Policies

### Helper functions

```sql
-- tenant_id do usuário logado
CREATE OR REPLACE FUNCTION get_user_tenant_id()
RETURNS UUID
LANGUAGE sql STABLE
AS $$
  SELECT COALESCE(
    (current_setting('request.jwt.claims', true)::json->>'tenant_id')::uuid,
    (current_setting('request.jwt.claims', true)::json->'app_metadata'->>'tenant_id')::uuid
  );
$$;

-- role level do usuário logado
CREATE OR REPLACE FUNCTION get_user_role_level()
RETURNS INTEGER
LANGUAGE sql STABLE
AS $$
  SELECT COALESCE(
    (current_setting('request.jwt.claims', true)::json->'app_metadata'->>'role_level')::integer,
    0
  );
$$;

-- professional_id se o user for professional
CREATE OR REPLACE FUNCTION get_user_professional_id()
RETURNS UUID
LANGUAGE sql STABLE
AS $$
  SELECT id FROM professionals WHERE user_id = auth.uid() AND is_active = true;
$$;

-- customer_id se o user for customer
CREATE OR REPLACE FUNCTION get_user_customer_id()
RETURNS UUID
LANGUAGE sql STABLE
AS $$
  SELECT id FROM customers WHERE user_id = auth.uid() AND deleted_at IS NULL;
$$;
```

### Policies por schema

```sql
-- === CORE ===
-- tenants: apenas super admin (level >= 7) vê tudo; user vê apenas seu tenant
CREATE POLICY tenant_select ON tenants
  FOR SELECT USING (
    id = get_user_tenant_id() OR get_user_role_level() >= 7
  );

-- === IDENTITY ===
-- users: próprio user, ou admin do tenant (level >= 6)
CREATE POLICY users_select ON users
  FOR SELECT USING (
    id = auth.uid() OR
    (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6)
  );
CREATE POLICY users_insert ON users
  FOR INSERT WITH CHECK (
    get_user_role_level() >= 6
  );
CREATE POLICY users_update ON users
  FOR UPDATE USING (
    id = auth.uid() OR
    (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6)
  );

-- === BEAUTY ===
-- professionals: todos do tenant podem ver; apenas admin (level >= 6) pode alterar
CREATE POLICY professionals_select ON professionals
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY professionals_insert ON professionals
  FOR INSERT WITH CHECK (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6
  );
CREATE POLICY professionals_update ON professionals
  FOR UPDATE USING (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6
  );

-- customers: todos do tenant podem ver; professional+ (level >= 3) pode alterar
CREATE POLICY customers_select ON customers
  FOR SELECT USING (tenant_id = get_user_tenant_id());
CREATE POLICY customers_insert ON customers
  FOR INSERT WITH CHECK (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 3
  );
CREATE POLICY customers_update ON customers
  FOR UPDATE USING (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 3
  );

-- === BOOKING ===
-- appointments: professional vê os seus; admin vê todos do tenant; customer vê os próprios
CREATE POLICY appointments_select ON appointments
  FOR SELECT USING (
    tenant_id = get_user_tenant_id() AND (
      professional_id = get_user_professional_id() OR
      customer_id = get_user_customer_id() OR
      get_user_role_level() >= 5
    )
  );
CREATE POLICY appointments_insert ON appointments
  FOR INSERT WITH CHECK (
    tenant_id = get_user_tenant_id() AND (
      get_user_role_level() >= 3 OR
      customer_id = get_user_customer_id()
    )
  );
CREATE POLICY appointments_update ON appointments
  FOR UPDATE USING (
    tenant_id = get_user_tenant_id() AND (
      professional_id = get_user_professional_id() OR
      get_user_role_level() >= 5
    )
  );

-- === FINANCIAL ===
-- apenas manager+ (level >= 5) vê dados financeiros
CREATE POLICY financial_select ON financial_transactions
  FOR SELECT USING (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5
  );
CREATE POLICY financial_insert ON financial_transactions
  FOR INSERT WITH CHECK (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5
  );

-- === LOYALTY ===
-- customer vê próprio; professional+ vê do tenant; admin pode alterar
CREATE POLICY loyalty_select ON loyalty_accounts
  FOR SELECT USING (
    tenant_id = get_user_tenant_id() AND (
      customer_id = get_user_customer_id() OR get_user_role_level() >= 3
    )
  );

-- === AUDIT ===
-- apenas admin+ (level >= 6)
CREATE POLICY audit_select ON audit_logs
  FOR SELECT USING (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 6
  );
-- audit_logs é INSERT-only via trigger
CREATE POLICY audit_insert ON audit_logs
  FOR INSERT WITH CHECK (
    tenant_id = get_user_tenant_id()
  );

-- === COMMERCE ===
-- products: todos do tenant vêem; admin+ (level >= 6) pode alterar
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

-- === CAMPAIGNS & COUPONS ===
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

-- === NOTIFICATIONS ===
-- templates: manager+ pode gerenciar
CREATE POLICY notif_templates_select ON notification_templates
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5);
CREATE POLICY notif_templates_insert ON notification_templates
  FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5);

-- automation: manager+ pode gerenciar
CREATE POLICY automation_select ON automation_rules
  FOR SELECT USING (tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5);

-- === PRODUCT EVENTS ===
-- apenas admin+ vê; INSERT via edge function
CREATE POLICY events_select ON product_events
  FOR SELECT USING (
    tenant_id = get_user_tenant_id() AND get_user_role_level() >= 5
  );
CREATE POLICY events_insert ON product_events
  FOR INSERT WITH CHECK (
    tenant_id = get_user_tenant_id()
  );
```

---

## 11. Triggers & Functions

### Auto tenant_id (todas as tabelas business)

```sql
CREATE OR REPLACE FUNCTION set_tenant_id()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  NEW.tenant_id := get_user_tenant_id();
  RETURN NEW;
END;
$$;
```

### Auto updated_at

```sql
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;
```

### Calcular comissão no appointment.completed

```sql
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
    -- Soma comissão de todos os serviços do appointment
    FOR service_record IN
      SELECT ap.price, ap.commission_pct
      FROM appointment_services ap
      WHERE ap.appointment_id = NEW.id
    LOOP
      -- Verifica regra específica do professional para este serviço
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

CREATE TRIGGER trg_calculate_commission
  BEFORE UPDATE OF status ON appointments
  FOR EACH ROW
  WHEN (NEW.status = 'completed' AND OLD.status != 'completed')
  EXECUTE FUNCTION calculate_commission();
```

### Atualizar estoque na venda de produto

```sql
CREATE OR REPLACE function update_stock_on_sale()
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

CREATE TRIGGER trg_update_stock_on_sale
  AFTER INSERT ON product_sales
  FOR EACH ROW
  EXECUTE FUNCTION update_stock_on_sale();
```

### Criar loyalty account para novo customer

```sql
CREATE OR REPLACE FUNCTION create_loyalty_account()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO loyalty_accounts (tenant_id, customer_id)
  VALUES (NEW.tenant_id, NEW.id);
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_create_loyalty_account
  AFTER INSERT ON customers
  FOR EACH ROW
  EXECUTE FUNCTION create_loyalty_account();
```

### Auditar mudanças críticas

```sql
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

-- Aplicar nas tabelas críticas
CREATE TRIGGER trg_audit_appointments
  AFTER INSERT OR UPDATE OR DELETE ON appointments
  FOR EACH ROW EXECUTE FUNCTION audit_changes();
CREATE TRIGGER trg_audit_payments
  AFTER INSERT OR UPDATE ON payments
  FOR EACH ROW EXECUTE FUNCTION audit_changes();
CREATE TRIGGER trg_audit_customers
  AFTER INSERT OR UPDATE OR DELETE ON customers
  FOR EACH ROW EXECUTE FUNCTION audit_changes();
```

### Registrar product_event automaticamente

```sql
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

CREATE TRIGGER trg_events_appointments
  AFTER INSERT OR UPDATE ON appointments
  FOR EACH ROW EXECUTE FUNCTION register_product_event();
```

---

## 12. Índices

```sql
-- Performance crítica — appointment lookup
CREATE INDEX idx_appointments_tenant_date ON appointments(tenant_id, start_at);
CREATE INDEX idx_appointments_professional_date ON appointments(professional_id, start_at);
CREATE INDEX idx_appointments_customer ON appointments(customer_id);
CREATE INDEX idx_appointments_status ON appointments(tenant_id, status);

-- Previne overlap (com btree_gist extension)
CREATE INDEX idx_appointments_no_overlap
  ON appointments USING gist (professional_id, tstzrange(start_at, end_at))
  WHERE status NOT IN ('cancelled', 'no_show');

-- Financeiro
CREATE INDEX idx_transactions_tenant_date ON financial_transactions(tenant_id, created_at);
CREATE INDEX idx_commissions_professional ON commission_entries(professional_id, status);
CREATE INDEX idx_payments_appointment ON payments(appointment_id);

-- Busca de clientes
CREATE INDEX idx_customers_phone ON customers(tenant_id, phone);
CREATE INDEX idx_customers_ltv ON customers(tenant_id, ltv DESC);

-- Loyalty
CREATE INDEX idx_ledger_account ON points_ledger(account_id, created_at DESC);

-- Analytics
CREATE INDEX idx_events_tenant ON product_events(tenant_id, created_at DESC);
CREATE INDEX idx_events_type ON product_events(event_type);

-- Audit
CREATE INDEX idx_audit_tenant ON audit_logs(tenant_id, created_at DESC);

-- Products & Inventory
CREATE INDEX idx_products_tenant ON products(tenant_id);
CREATE INDEX idx_products_low_stock ON products(tenant_id) WHERE stock_quantity <= min_stock;
CREATE INDEX idx_movements_product ON inventory_movements(product_id, created_at DESC);
CREATE INDEX idx_sales_customer ON product_sales(customer_id);

-- CRM
CREATE INDEX idx_interactions_customer ON customer_interactions(customer_id, created_at DESC);
CREATE INDEX idx_interactions_type ON customer_interactions(tenant_id, type);

-- Campaigns
CREATE INDEX idx_campaigns_status ON campaigns(tenant_id, status);
CREATE INDEX idx_coupons_code ON coupons(tenant_id, code);

-- Notifications
CREATE INDEX idx_notif_templates_tenant ON notification_templates(tenant_id);
CREATE INDEX idx_automation_event ON automation_rules(trigger_event);
```

---

## 13. Seed Data

```sql
-- Tenant padrão para desenvolvimento
INSERT INTO tenants (id, name, slug, plan, status) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Studio Letícia', 'studio-leticia', 'professional', 'active');

-- Tema do Studio Letícia
INSERT INTO tenant_themes (tenant_id, primary_color, secondary_color, background_color) VALUES
  ('00000000-0000-0000-0000-000000000001', '#D81B60', '#FFB300', '#F5F0EB');

-- Feature flags iniciais
INSERT INTO tenant_features (tenant_id, key, name, is_enabled) VALUES
  ('00000000-0000-0000-0000-000000000001', 'online_booking', 'Agendamento online', true),
  ('00000000-0000-0000-0000-000000000001', 'payment_online', 'Pagamento online', false),
  ('00000000-0000-0000-0000-000000000001', 'loyalty_program', 'Programa de fidelidade', false),
  ('00000000-0000-0000-0000-000000000001', 'whatsapp_reminder', 'Lembrete via WhatsApp', false),
  ('00000000-0000-0000-0000-000000000001', 'gallery_public', 'Galeria pública', true),
  ('00000000-0000-0000-0000-000000000001', 'multi_tenant', 'Modo multi-tenant', false);

-- Categorias de serviço
INSERT INTO service_categories (tenant_id, name, icon, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Cortes', 'content_cut', 1),
  ('00000000-0000-0000-0000-000000000001', 'Coloração', 'palette', 2),
  ('00000000-0000-0000-0000-000000000001', 'Tratamentos', 'spa', 3),
  ('00000000-0000-0000-0000-000000000001', 'Manicure & Pedicure', 'pan_tool', 4),
  ('00000000-0000-0000-0000-000000000001', 'Maquiagem', 'face', 5),
  ('00000000-0000-0000-0000-000000000001', 'Depilação', 'wave', 6);

-- Serviços
INSERT INTO services (tenant_id, category_id, name, duration, price, commission_percentage, is_signature, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM service_categories WHERE name = 'Cortes'), 'Corte Feminino', 45, 80.00, 50.00, true, 1),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM service_categories WHERE name = 'Cortes'), 'Corte Masculino', 30, 50.00, 50.00, false, 2),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM service_categories WHERE name = 'Coloração'), 'Escova Progressiva', 120, 200.00, 40.00, true, 3),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM service_categories WHERE name = 'Coloração'), 'Mechas', 150, 250.00, 40.00, true, 4),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM service_categories WHERE name = 'Tratamentos'), 'Hidratação', 40, 60.00, 50.00, false, 5),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM service_categories WHERE name = 'Manicure & Pedicure'), 'Manicure', 30, 35.00, 50.00, false, 6),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM service_categories WHERE name = 'Manicure & Pedicure'), 'Pedicure', 30, 35.00, 50.00, false, 7);

-- Brand Experience
INSERT INTO brand_experiences (tenant_id, welcome_title, welcome_subtitle, mood_description) VALUES
  ('00000000-0000-0000-0000-000000000001',
   'Sua próxima experiência começa aqui',
   'Studio Letícia — onde a beleza encontra a excelência',
   'Elegante, acolhedor, sofisticado. Cada visita é um momento de cuidado e transformação.');

-- Membership Plan
INSERT INTO membership_plans (tenant_id, name, description, monthly_price, benefits, max_active) VALUES
  ('00000000-0000-0000-0000-000000000001',
   'Studio Gold',
   'Tenha prioridade na agenda e descontos exclusivos',
   199.00,
   ARRAY['Prioridade na agenda', '20% de desconto em produtos', '1 hidratação grátis por mês', 'Indicação de horário inteligente'],
   50);

-- Categorias de produtos
INSERT INTO product_categories (tenant_id, name, icon, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Shampoos & Condicionadores', 'shampoo', 1),
  ('00000000-0000-0000-0000-000000000001', 'Máscaras & Tratamentos', 'spa', 2),
  ('00000000-0000-0000-0000-000000000001', 'Finalizadores', 'air', 3),
  ('00000000-0000-0000-0000-000000000001', 'Kits & Combos', 'card_giftcard', 4);

-- Produtos
INSERT INTO products (tenant_id, category_id, name, brand, price, cost_price, stock_quantity, min_stock) VALUES
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM product_categories WHERE name = 'Shampoos & Condicionadores'), 'Shampoo Reconstrutor', 'Profissional Line', 45.90, 22.00, 20, 5),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM product_categories WHERE name = 'Shampoos & Condicionadores'), 'Condicionador Reconstrutor', 'Profissional Line', 49.90, 24.00, 15, 5),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM product_categories WHERE name = 'Máscaras & Tratamentos'), 'Máscara de Hidratação Intensa', 'Profissional Line', 79.90, 35.00, 10, 3),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM product_categories WHERE name = 'Finalizadores'), 'Leave-in Protetor Térmico', 'Profissional Line', 59.90, 28.00, 12, 3),
  ('00000000-0000-0000-0000-000000000001', (SELECT id FROM product_categories WHERE name = 'Kits & Combos'), 'Kit Cuidados Completos', 'Studio Letícia', 199.00, 85.00, 5, 2);

-- Notification templates
INSERT INTO notification_templates (tenant_id, channel, event_type, title, body, variables) VALUES
  ('00000000-0000-0000-0000-000000000001', 'push', 'appointment.confirmed',
   'Agendamento confirmado!',
   'Olá {{customer_name}}, seu horário com {{professional_name}} em {{appointment_date}} foi confirmado.',
   '["customer_name", "professional_name", "appointment_date"]'),
  ('00000000-0000-0000-0000-000000000001', 'push', 'appointment.reminder_24h',
   'Seu horário é amanhã!',
   'Lembramos do seu agendamento amanhã às {{appointment_time}} com {{professional_name}}. Confirme ou cancele.',
   '["customer_name", "professional_name", "appointment_time"]'),
  ('00000000-0000-0000-0000-000000000001', 'whatsapp', 'appointment.completed',
   'Como foi seu atendimento?',
   'Olá {{customer_name}}, seu atendimento com {{professional_name}} foi concluído. Avalie sua experiência!',
   '["customer_name", "professional_name"]'),
  ('00000000-0000-0000-0000-000000000001', 'whatsapp', 'birthday',
   'Feliz aniversário!',
   'Feliz aniversário, {{customer_name}}! Ganhe {{bonus_points}} pontos de presente para usar no Studio Letícia.',
   '["customer_name", "bonus_points"]');

-- Automation rules
INSERT INTO automation_rules (tenant_id, name, trigger_event, trigger_delay, channel, template_id) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Lembrete 24h antes', 'appointment.scheduled', 1380, 'push',
   (SELECT id FROM notification_templates WHERE event_type = 'appointment.reminder_24h')),
  ('00000000-0000-0000-0000-000000000001', 'Confirmação de agendamento', 'appointment.scheduled', 0, 'push',
   (SELECT id FROM notification_templates WHERE event_type = 'appointment.confirmed'));

-- Campaign
INSERT INTO campaigns (tenant_id, name, type, trigger_type, audience_segment, message_template, status) VALUES
  ('00000000-0000-0000-0000-000000000001',
   'Aniversariantes do mês',
   'birthday', 'auto',
   '{"tags_incluir": [], "min_visits": 1}',
   'Olá {{customer_name}}, feliz aniversário! Ganhe 50 pontos extras no Studio Letícia.',
   'active');
```

---

## 14. Migration Plan

```
supabase/migrations/
├── 001_extensions.sql         -- uuid-ossp, btree_gist, pgcrypto
├── 002_core.sql               -- tenants, tenant_themes, tenant_features
├── 003_identity.sql           -- roles, users, user_sessions
├── 004_beauty.sql             -- service_categories, services, service_experience_steps,
│                                service_addons, professionals, professional_specialties,
│                                professional_commission_rules, professional_work_days,
│                                professional_ratings, customers, customer_preferences,
│                                customer_interactions, customer_insights
├── 005_booking.sql            -- appointments, appointment_services, appointment_reminders,
│                                appointment_history
├── 006_financial.sql          -- payments, financial_transactions, commission_entries,
│                                cash_registers, expenses
├── 007_loyalty.sql            -- loyalty_accounts, points_ledger, loyalty_rewards
├── 008_commerce.sql           -- product_categories, products, inventory_movements, product_sales
├── 009_engagement.sql         -- brand_experiences, testimonials, gallery,
│                                campaigns, campaign_audience, coupons, coupon_usages,
│                                membership_plans, customer_memberships
├── 010_platform.sql           -- audit_logs, product_events, notification_templates,
│                                automation_rules, integrations
├── 011_functions.sql          -- helper functions, triggers
├── 012_rls.sql                -- RLS policies (aplicado após functions)
├── 013_indexes.sql            -- índices de performance
└── 014_seed.sql               -- seed data para desenvolvimento
```

Ordem de execução essencial:
1. `extensions` primeiro (btree_gist para overlap check)
2. `functions` antes de `rls` (policies dependem das helper functions)
3. `rls` depois de todas as tabelas
4. `seed` por último

---

## 15. Futuras Migrações

### AI Recommendations Engine (Fase 3)

Quando houver dados suficientes de interações e insights, o motor de recomendação será ativado:

```sql
CREATE TABLE ai_recommendations (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  recommendation_type VARCHAR(30) NOT NULL CHECK (recommendation_type IN ('service', 'professional', 'product', 'return')),
  reference_id      UUID NOT NULL,         -- service_id, professional_id, etc.
  score             DECIMAL(5,4) NOT NULL,  -- confiança 0.0000 a 1.0000
  reason            TEXT,
  viewed            BOOLEAN NOT NULL DEFAULT false,
  clicked           BOOLEAN NOT NULL DEFAULT false,
  converted         BOOLEAN NOT NULL DEFAULT false,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### Marketplace (Fase 4)

Quando a plataforma evoluir para conectar clientes a profissionais de diferentes tenants:

```sql
CREATE TABLE marketplace_listings (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id   UUID NOT NULL REFERENCES professionals(id),
  tenant_id         UUID NOT NULL REFERENCES tenants(id),
  service_id        UUID NOT NULL REFERENCES services(id),
  price             DECIMAL(10,2) NOT NULL,
  is_online         BOOLEAN NOT NULL DEFAULT false,
  radius_km         INTEGER,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

### WhatsApp Automation Avançada (Fase 3)

```sql
CREATE TABLE whatsapp_conversations (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  provider          VARCHAR(50) NOT NULL DEFAULT 'weni',
  provider_conversation_id VARCHAR(255),
  status            VARCHAR(20) NOT NULL DEFAULT 'active',
  last_message_at   TIMESTAMPTZ,
  metadata          JSONB NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE whatsapp_messages (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id   UUID NOT NULL REFERENCES whatsapp_conversations(id) ON DELETE CASCADE,
  role              VARCHAR(10) NOT NULL CHECK (role IN ('assistant', 'customer')),
  content           TEXT NOT NULL,
  message_type      VARCHAR(20) DEFAULT 'text',
  media_url         TEXT,
  sent_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

---

## Approval

| Role | Name | Date |
|---|---|---|
| Chief Architect | Eddie | |
| Product Owner | Raffa | |
| Tech Lead | | |

---

**DATABASE DESIGN v1.1 — Studio Letícia Experience**
*Framework: BBOP v1.0 | Plataforma: FUTURECOD DPES | PostgreSQL 15+*
