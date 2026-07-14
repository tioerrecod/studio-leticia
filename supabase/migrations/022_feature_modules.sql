-- 022_feature_modules.sql
-- Feature Modules: controle granular de funcionalidades por plano SaaS
-- Depende de: 016_saas_plans.sql

-- ============================================================
-- FEATURE MODULES (catálogo de funcionalidades)
-- ============================================================
CREATE TABLE feature_modules (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key               VARCHAR(100) NOT NULL UNIQUE,
  name              VARCHAR(255) NOT NULL,
  description       TEXT,
  category          VARCHAR(30) NOT NULL CHECK (category IN (
                    'core', 'booking', 'crm', 'financial', 'loyalty',
                    'commerce', 'marketing', 'automation', 'ai', 'integration',
                    'whitelabel', 'support', 'analytics'
                  )),
  dependencies      UUID[] NOT NULL DEFAULT '{}',           -- módulos que este depende
  is_active         BOOLEAN NOT NULL DEFAULT true,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- PLAN FEATURES (módulos habilitados por plano)
-- ============================================================
CREATE TABLE plan_features (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  saas_plan_id      UUID NOT NULL REFERENCES saas_plans(id) ON DELETE CASCADE,
  feature_id        UUID NOT NULL REFERENCES feature_modules(id) ON DELETE CASCADE,
  is_enabled        BOOLEAN NOT NULL DEFAULT true,
  limits            JSONB NOT NULL DEFAULT '{}',             -- limites: {"max_automations": 10, "max_campaigns": 5}
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(saas_plan_id, feature_id)
);

CREATE INDEX idx_plan_features_plan ON plan_features(saas_plan_id);
CREATE INDEX idx_plan_features_feature ON plan_features(feature_id);

-- ============================================================
-- SEED: feature modules
-- ============================================================
INSERT INTO feature_modules (key, name, description, category, sort_order) VALUES
  ('core', 'Núcleo do sistema', 'Multitenancy, autenticação, perfis', 'core', 1),
  ('booking_basic', 'Agenda básica', 'Agendamento, status, histórico', 'booking', 2),
  ('booking_smart', 'Agenda inteligente', 'Prevenção de overlap, sugestão de horários', 'booking', 3),
  ('crm_basic', 'CRM básico', 'Cadastro de clientes, histórico', 'crm', 4),
  ('crm_advanced', 'CRM avançado', 'Segmentação, tags, insights, interações', 'crm', 5),
  ('financial_basic', 'Financeiro básico', 'Pagamentos, comissões, fluxo de caixa', 'financial', 6),
  ('financial_reports', 'Relatórios financeiros', 'DRE, lucro por serviço, projeções', 'financial', 7),
  ('loyalty', 'Programa de fidelidade', 'Pontos, recompensas, níveis', 'loyalty', 8),
  ('commerce', 'Venda de produtos', 'Estoque, vendas, controle', 'commerce', 9),
  ('marketing_campaigns', 'Campanhas', 'Campanhas automáticas e manuais', 'marketing', 10),
  ('marketing_coupons', 'Cupons', 'Cupons de desconto e brindes', 'marketing', 11),
  ('automation_reminders', 'Lembretes automáticos', 'Notificações push/WhatsApp', 'automation', 12),
  ('automation_workflows', 'Automação avançada', 'Fluxos condicionais, gatilhos', 'automation', 13),
  ('ai_insights', 'IA de insights', 'Sugestões inteligentes', 'ai', 14),
  ('ai_memory', 'IA de memória', 'Memória persistente por cliente', 'ai', 15),
  ('ai_recommendations', 'IA de recomendações', 'Recomendações personalizadas', 'ai', 16),
  ('integration_api', 'API pública', 'Integração com parceiros', 'integration', 17),
  ('integration_whatsapp', 'WhatsApp Business', 'Notificações e chat via WhatsApp', 'integration', 18),
  ('whitelabel', 'White label', 'Marca própria, domínio próprio', 'whitelabel', 19),
  ('analytics', 'Analytics avançado', 'Dashboards, funis, retenção', 'analytics', 20),
  ('support_priority', 'Suporte prioritário', 'SLA, canal exclusivo', 'support', 21);

-- ============================================================
-- SEED: mapeamento planos → features
-- ============================================================
-- Free: apenas core + booking_basic + crm_basic
INSERT INTO plan_features (saas_plan_id, feature_id)
SELECT sp.id, fm.id
FROM saas_plans sp, feature_modules fm
WHERE sp.slug = 'free'
  AND fm.key IN ('core', 'booking_basic', 'crm_basic');

-- Starter: Free + booking_smart + crm_advanced + financial_basic + automation_reminders
INSERT INTO plan_features (saas_plan_id, feature_id)
SELECT sp.id, fm.id
FROM saas_plans sp, feature_modules fm
WHERE sp.slug = 'starter'
  AND fm.key IN ('core', 'booking_basic', 'booking_smart', 'crm_basic', 'crm_advanced',
                 'financial_basic', 'automation_reminders', 'integration_whatsapp');

-- Professional: Starter + loyalty + commerce + marketing + automation_workflows + ai_insights
INSERT INTO plan_features (saas_plan_id, feature_id)
SELECT sp.id, fm.id
FROM saas_plans sp, feature_modules fm
WHERE sp.slug = 'professional'
  AND fm.key IN ('core', 'booking_basic', 'booking_smart', 'crm_basic', 'crm_advanced',
                 'financial_basic', 'financial_reports', 'loyalty', 'commerce',
                 'marketing_campaigns', 'marketing_coupons',
                 'automation_reminders', 'automation_workflows',
                 'ai_insights', 'ai_memory',
                 'integration_whatsapp', 'analytics');

-- Enterprise: Professional + ai_recommendations + integration_api + whitelabel + support_priority
INSERT INTO plan_features (saas_plan_id, feature_id)
SELECT sp.id, fm.id
FROM saas_plans sp, feature_modules fm
WHERE sp.slug = 'enterprise'
  AND fm.key IN ('core', 'booking_basic', 'booking_smart', 'crm_basic', 'crm_advanced',
                 'financial_basic', 'financial_reports', 'loyalty', 'commerce',
                 'marketing_campaigns', 'marketing_coupons',
                 'automation_reminders', 'automation_workflows',
                 'ai_insights', 'ai_memory', 'ai_recommendations',
                 'integration_api', 'integration_whatsapp',
                 'whitelabel', 'analytics', 'support_priority');
