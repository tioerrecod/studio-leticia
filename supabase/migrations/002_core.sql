-- 002_core.sql
-- Schema CORE: tenants, tenant_themes, tenant_features
-- Depende de: 001_extensions.sql

-- ============================================================
-- TENANTS
-- ============================================================
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

-- ============================================================
-- TENANT THEMES (white-label)
-- ============================================================
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

-- ============================================================
-- TENANT FEATURES (feature flags por tenant)
-- ============================================================
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
