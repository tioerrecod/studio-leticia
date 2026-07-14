-- 016_saas_plans.sql
-- Planos SaaS da plataforma (não confundir com membership_plans
-- que são planos de fidelidade do cliente final do salão)
-- Depende de: 002_core.sql

-- ============================================================
-- SAAS PLANS (planos de assinatura da plataforma)
-- ============================================================
CREATE TABLE saas_plans (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name                VARCHAR(100) NOT NULL,
  slug                VARCHAR(50) NOT NULL UNIQUE,
  description         TEXT,
  price_monthly       DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (price_monthly >= 0),
  price_yearly        DECIMAL(10,2) CHECK (price_yearly IS NULL OR price_yearly >= 0),
  trial_days          INTEGER NOT NULL DEFAULT 14,
  max_professionals   INTEGER NOT NULL DEFAULT 1,
  max_customers       INTEGER NOT NULL DEFAULT 100,
  max_storage_mb      INTEGER NOT NULL DEFAULT 500,
  features            TEXT[] NOT NULL DEFAULT '{}',
  is_active           BOOLEAN NOT NULL DEFAULT true,
  sort_order          INTEGER NOT NULL DEFAULT 0,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- SEED: planos iniciais
-- ============================================================
INSERT INTO saas_plans (name, slug, description, price_monthly, trial_days, max_professionals, max_customers, max_storage_mb, features, sort_order) VALUES
  ('Free', 'free',
   'Para profissionais autônomos começando',
   0.00, 0, 1, 100, 200,
   ARRAY['Agenda básica', 'Gestão de clientes', 'Serviços ilimitados', 'Relatórios simples'],
   1),
  ('Starter', 'starter',
   'Para pequenos estúdios em crescimento',
   49.90, 14, 3, 500, 1000,
   ARRAY['Agenda inteligente', 'CRM completo', 'Comissões', 'Financeiro básico', 'Lembretes WhatsApp', 'Galeria'],
   2),
  ('Professional', 'professional',
   'Para salões estabelecidos com equipe',
   99.90, 14, 10, 2000, 2000,
   ARRAY['Tudo do Starter', 'Automação de marketing', 'Campanhas e cupons', 'Fidelidade e pontos', 'Múltiplas unidades', 'API de integração'],
   3),
  ('Enterprise', 'enterprise',
   'Para redes e franquias',
   299.90, 14, 0, 0, 5000,
   ARRAY['Tudo do Professional', 'White label', 'Profissionais ilimitados', 'Clientes ilimitados', 'IA e recomendações', 'Suporte prioritário', 'SLA'],
   4);

-- ============================================================
-- RELACIONAR tenants COM saas_plans
-- NOTA: plan é VARCHAR na tabela tenants. Migramos gradualmente.
-- Adicionamos plan_id como FK opcional.
-- ============================================================
ALTER TABLE tenants
  ADD COLUMN saas_plan_id UUID REFERENCES saas_plans(id),
  ADD COLUMN trial_ends_at TIMESTAMPTZ;

CREATE INDEX idx_tenants_saas_plan ON tenants(saas_plan_id);
