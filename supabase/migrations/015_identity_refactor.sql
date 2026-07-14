-- 015_identity_refactor.sql
-- Evolução da identidade: separa profiles (base), staff (funcionários)
-- e customer_profiles (clientes) — compatível com tabelas existentes
-- Depende de: 002_core.sql, 003_identity.sql, 004_beauty.sql

-- ============================================================
-- PROFILES (identidade canônica — todo usuário humano)
-- ============================================================
CREATE TABLE profiles (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id    UUID UNIQUE,
  tenant_id       UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  full_name       VARCHAR(255) NOT NULL,
  avatar_url      TEXT,
  phone           VARCHAR(20),
  email           VARCHAR(255),
  is_active       BOOLEAN NOT NULL DEFAULT true,
  metadata        JSONB NOT NULL DEFAULT '{}',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_profiles_tenant ON profiles(tenant_id);
CREATE INDEX idx_profiles_auth ON profiles(auth_user_id);

-- ============================================================
-- STAFF (funcionários do tenant — donos, admins, profissionais)
-- Separa identidade civil (profile) da função profissional.
-- ============================================================
CREATE TABLE staff (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  profile_id        UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role_id           UUID NOT NULL REFERENCES roles(id),
  professional_id   UUID REFERENCES professionals(id) ON DELETE SET NULL,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  joined_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, profile_id)
);

CREATE INDEX idx_staff_tenant ON staff(tenant_id);
CREATE INDEX idx_staff_profile ON staff(profile_id);
CREATE INDEX idx_staff_professional ON staff(professional_id);

-- ============================================================
-- CUSTOMER PROFILES (clientes)
-- ============================================================
CREATE TABLE customer_profiles (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id             UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  profile_id            UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  customer_id           UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  marketing_opt_in      BOOLEAN NOT NULL DEFAULT false,
  birth_date            DATE,
  notes                 TEXT,
  preferences           JSONB NOT NULL DEFAULT '{}',
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, profile_id),
  UNIQUE(tenant_id, customer_id)
);

CREATE INDEX idx_customer_profiles_tenant ON customer_profiles(tenant_id);
CREATE INDEX idx_customer_profiles_profile ON customer_profiles(profile_id);

-- ============================================================
-- TRIGGERS: auto-criar profile a partir de users existentes
-- (quando um user é inserido em auth.users pelo Supabase Auth)
-- ============================================================
CREATE OR REPLACE FUNCTION sync_auth_user_to_profile()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO profiles (auth_user_id, tenant_id, full_name, email, phone)
  VALUES (
    NEW.id,
    COALESCE(
      (NEW.raw_app_meta_data->>'tenant_id')::uuid,
      (NEW.raw_user_meta_data->>'tenant_id')::uuid
    ),
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    NEW.email,
    NEW.phone
  )
  ON CONFLICT (auth_user_id) DO NOTHING;
  RETURN NEW;
END;
$$;

-- Nota: este trigger é opcional — pode ser ativado quando o
-- Supabase Auth estiver configurado com o schema adequado.
-- CREATE TRIGGER trg_sync_auth_profile
--   AFTER INSERT ON auth.users
--   FOR EACH ROW
--   EXECUTE FUNCTION sync_auth_user_to_profile();

-- ============================================================
-- VIEWS COMPATÍVEIS (opcionais para queries simplificadas)
-- ============================================================

-- Visão unificada de staff com profile + professional
CREATE VIEW v_staff_with_profile AS
SELECT
  s.id AS staff_id,
  p.id AS profile_id,
  p.full_name,
  p.avatar_url,
  p.email,
  p.phone,
  s.tenant_id,
  r.name AS role_name,
  r.hierarchy_level,
  pr.id AS professional_id,
  pr.name AS professional_name,
  s.is_active,
  s.joined_at
FROM staff s
JOIN profiles p ON p.id = s.profile_id
JOIN roles r ON r.id = s.role_id
LEFT JOIN professionals pr ON pr.id = s.professional_id;

-- Visão unificada de customer com profile
CREATE VIEW v_customer_with_profile AS
SELECT
  c.id AS customer_id,
  p.id AS profile_id,
  p.full_name,
  p.avatar_url,
  p.email,
  p.phone,
  c.tenant_id,
  c.total_visits,
  c.total_spent,
  c.ltv,
  c.churn_score,
  c.last_visit_at,
  c.birth_date,
  c.tags,
  c.source,
  c.deleted_at
FROM customers c
JOIN customer_profiles cp ON cp.customer_id = c.id
JOIN profiles p ON p.id = cp.profile_id;
