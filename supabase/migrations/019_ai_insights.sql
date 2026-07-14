-- 019_ai_insights.sql
-- Camada de IA: insights gerados automaticamente sobre clientes
-- Alimenta recomendações, campanhas e o CRM inteligente
-- Depende de: 002_core.sql, 004_beauty.sql (customers)

-- ============================================================
-- AI INSIGHTS (sugestões geradas por IA)
-- ============================================================
CREATE TABLE ai_insights (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  type              VARCHAR(30) NOT NULL CHECK (type IN (
                    'return_prediction', 'churn_risk', 'cross_sell',
                    'upsell', 'campaign_suggestion', 'service_recommendation',
                    'product_recommendation', 'appointment_suggestion',
                    'behavior_change', 'seasonal_opportunity'
                  )),
  title             VARCHAR(255) NOT NULL,
  message           TEXT NOT NULL,
  suggested_action  TEXT,
  priority          VARCHAR(10) NOT NULL DEFAULT 'medium'
                    CHECK (priority IN ('low', 'medium', 'high', 'critical')),
  score             DECIMAL(5,4),                       -- confiança 0.0000 a 1.0000
  data              JSONB NOT NULL DEFAULT '{}',        -- dados que geraram o insight
  status            VARCHAR(20) NOT NULL DEFAULT 'active'
                    CHECK (status IN ('active', 'applied', 'dismissed', 'expired')),
  applied_at        TIMESTAMPTZ,
  applied_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  expires_at        TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_ai_insights_tenant ON ai_insights(tenant_id);
CREATE INDEX idx_ai_insights_customer ON ai_insights(customer_id);
CREATE INDEX idx_ai_insights_type ON ai_insights(tenant_id, type);
CREATE INDEX idx_ai_insights_priority ON ai_insights(tenant_id, priority)
  WHERE status = 'active';
CREATE INDEX idx_ai_insights_score ON ai_insights(tenant_id, score DESC)
  WHERE status = 'active' AND score IS NOT NULL;
CREATE INDEX idx_ai_insights_expires ON ai_insights(expires_at)
  WHERE status = 'active' AND expires_at IS NOT NULL;

-- ============================================================
-- TRIGGER: expirar insights automaticamente
-- ============================================================
CREATE OR REPLACE FUNCTION expire_ai_insights()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE ai_insights
  SET status = 'expired'
  WHERE status = 'active'
    AND expires_at IS NOT NULL
    AND expires_at < now();
  RETURN NULL;
END;
$$;

-- Pode ser chamado por Edge Function ou pg_cron
-- CREATE EXTENSION IF NOT EXISTS pg_cron;
-- SELECT cron.schedule('expire-ai-insights', '0 0 * * *', 'SELECT expire_ai_insights()');

-- ============================================================
-- VIEW: insights ativos por prioridade
-- ============================================================
CREATE VIEW v_active_insights AS
SELECT
  i.id,
  i.tenant_id,
  i.customer_id,
  c.name AS customer_name,
  c.phone AS customer_phone,
  i.type,
  i.title,
  i.message,
  i.suggested_action,
  i.priority,
  i.score,
  i.created_at,
  i.expires_at
FROM ai_insights i
JOIN customers c ON c.id = i.customer_id
WHERE i.status = 'active'
ORDER BY i.priority DESC, i.score DESC NULLS LAST;
