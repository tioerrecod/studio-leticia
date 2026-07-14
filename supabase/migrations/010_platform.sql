-- 010_platform.sql
-- Schema PLATFORM: audit, events, integrations, notifications, automations
-- Depende de: 002_core.sql (tenants), 003_identity.sql (users)

-- ============================================================
-- AUDIT LOGS
-- ============================================================
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

-- ============================================================
-- PRODUCT EVENTS (analytics)
-- ============================================================
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

-- ============================================================
-- NOTIFICATION TEMPLATES
-- ============================================================
CREATE TABLE notification_templates (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  channel           VARCHAR(20) NOT NULL CHECK (channel IN ('push', 'whatsapp', 'email')),
  event_type        VARCHAR(50) NOT NULL,
  title             VARCHAR(255),
  body              TEXT NOT NULL,
  variables         JSONB NOT NULL DEFAULT '[]',
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, channel, event_type)
);

CREATE INDEX idx_notif_templates_tenant ON notification_templates(tenant_id);

-- ============================================================
-- AUTOMATION RULES
-- ============================================================
CREATE TABLE automation_rules (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name              VARCHAR(255) NOT NULL,
  trigger_event     VARCHAR(50) NOT NULL,
  trigger_delay     INTEGER NOT NULL DEFAULT 0,
  channel           VARCHAR(20) NOT NULL CHECK (channel IN ('push', 'whatsapp', 'email')),
  template_id       UUID REFERENCES notification_templates(id) ON DELETE SET NULL,
  audience_filter   JSONB NOT NULL DEFAULT '{}',
  is_active         BOOLEAN NOT NULL DEFAULT true,
  last_triggered_at TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_automation_tenant ON automation_rules(tenant_id);
CREATE INDEX idx_automation_event ON automation_rules(trigger_event);

-- ============================================================
-- INTEGRATIONS (credenciais de terceiros)
-- ============================================================
CREATE TABLE integrations (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  provider          VARCHAR(50) NOT NULL CHECK (provider IN ('mercado_pago', 'google', 'whatsapp', 'openai', 'posthog')),
  credentials       JSONB NOT NULL DEFAULT '{}',
  settings          JSONB NOT NULL DEFAULT '{}',
  is_active         BOOLEAN NOT NULL DEFAULT false,
  last_sync_at      TIMESTAMPTZ,
  error_message     TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, provider)
);
