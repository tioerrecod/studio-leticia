-- 003_identity.sql
-- Schema IDENTITY: roles, users, user_sessions
-- Depende de: 002_core.sql (tenants)

-- ============================================================
-- ROLES
-- ============================================================
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

-- ============================================================
-- USERS
-- ============================================================
CREATE TABLE users (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  auth_user_id    UUID UNIQUE,
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

-- ============================================================
-- USER SESSIONS
-- ============================================================
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
