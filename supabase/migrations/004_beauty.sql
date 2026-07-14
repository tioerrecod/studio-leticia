-- 004_beauty.sql
-- Schema BEAUTY: services, professionals, customers, CRM, insights
-- Depende de: 002_core.sql (tenants), 003_identity.sql (users)

-- ============================================================
-- SERVICE CATEGORIES
-- ============================================================
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

-- ============================================================
-- SERVICES
-- ============================================================
CREATE TABLE services (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  category_id           UUID REFERENCES service_categories(id),
  name                  VARCHAR(255) NOT NULL,
  description           TEXT,
  duration              INTEGER NOT NULL CHECK (duration > 0),
  price                 DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  promotional_price     DECIMAL(10,2) CHECK (promotional_price IS NULL OR promotional_price >= 0),
  commission_percentage DECIMAL(5,2) NOT NULL DEFAULT 50.00 CHECK (commission_percentage BETWEEN 0 AND 100),
  is_active             BOOLEAN NOT NULL DEFAULT true,
  image_url             TEXT,
  sort_order            INTEGER NOT NULL DEFAULT 0,
  is_signature          BOOLEAN NOT NULL DEFAULT false,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_services_tenant ON services(tenant_id);
CREATE INDEX idx_services_category ON services(category_id);
CREATE INDEX idx_services_signature ON services(tenant_id) WHERE is_signature = true;

-- ============================================================
-- SERVICE EXPERIENCE STEPS
-- ============================================================
CREATE TABLE service_experience_steps (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_id    UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  moment        VARCHAR(20) NOT NULL CHECK (moment IN ('before', 'during', 'after')),
  step_order    INTEGER NOT NULL,
  title         VARCHAR(255) NOT NULL,
  description   TEXT,
  duration_min  INTEGER,
  media_url     TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_exp_steps_service ON service_experience_steps(service_id);

-- ============================================================
-- SERVICE ADDONS
-- ============================================================
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

-- ============================================================
-- PROFESSIONALS
-- ============================================================
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

-- ============================================================
-- PROFESSIONAL SPECIALTIES
-- ============================================================
CREATE TABLE professional_specialties (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professional_id UUID NOT NULL REFERENCES professionals(id) ON DELETE CASCADE,
  service_id      UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  UNIQUE(professional_id, service_id)
);

-- ============================================================
-- PROFESSIONAL COMMISSION RULES
-- ============================================================
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

-- ============================================================
-- PROFESSIONAL WORK DAYS
-- ============================================================
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

-- ============================================================
-- PROFESSIONAL RATINGS
-- ============================================================
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

-- ============================================================
-- CUSTOMERS
-- ============================================================
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
  ltv                   DECIMAL(12,2) NOT NULL DEFAULT 0,
  churn_score           DECIMAL(5,4) NOT NULL DEFAULT 0,
  consent_marketing     BOOLEAN NOT NULL DEFAULT false,
  consent_whatsapp      BOOLEAN NOT NULL DEFAULT false,
  consent_terms_version VARCHAR(20),
  consented_at          TIMESTAMPTZ,
  revoked_at            TIMESTAMPTZ,
  deleted_at            TIMESTAMPTZ,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_customers_tenant ON customers(tenant_id);
CREATE INDEX idx_customers_phone ON customers(tenant_id, phone);
CREATE INDEX idx_customers_source ON customers(source);
CREATE INDEX idx_customers_ltv ON customers(tenant_id, ltv DESC);
CREATE INDEX idx_customers_birth ON customers(tenant_id, birth_date);

-- ============================================================
-- CUSTOMER PREFERENCES
-- ============================================================
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

-- ============================================================
-- CUSTOMER INTERACTIONS (CRM)
-- FK para appointments será adicionada em 005_booking.sql
-- ============================================================
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
  detail            TEXT,
  sentiment         VARCHAR(10) CHECK (sentiment IN ('positive', 'neutral', 'negative')),
  channel           VARCHAR(20) CHECK (channel IN ('whatsapp', 'push', 'email', 'in_person', 'phone')),
  performed_by      UUID REFERENCES users(id) ON DELETE SET NULL,
  appointment_id    UUID,
  metadata          JSONB NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_interactions_customer ON customer_interactions(customer_id, created_at DESC);
CREATE INDEX idx_interactions_type ON customer_interactions(tenant_id, type);
CREATE INDEX idx_interactions_sentiment ON customer_interactions(tenant_id, sentiment);

-- ============================================================
-- CUSTOMER INSIGHTS
-- ============================================================
CREATE TABLE customer_insights (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id           UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  hair_type             VARCHAR(50),
  hair_conditions       TEXT[] NOT NULL DEFAULT '{}',
  skin_type             VARCHAR(50),
  skin_sensitivies      TEXT[] NOT NULL DEFAULT '{}',
  favorite_services     UUID[] NOT NULL DEFAULT '{}',
  avoid_services        UUID[] NOT NULL DEFAULT '{}',
  purchase_patterns     JSONB NOT NULL DEFAULT '{}',
  ai_notes              TEXT,
  last_updated_by       UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(customer_id)
);
