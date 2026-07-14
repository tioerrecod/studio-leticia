-- 021_ai_customer_memory.sql
-- AI Customer Memory: memória persistente da IA sobre cada cliente
-- Diferente de ai_insights (sugestões), isso é conhecimento acumulado
-- Depende de: 004_beauty.sql (customers), 019_ai_insights.sql

-- ============================================================
-- AI CUSTOMER MEMORY
-- ============================================================
CREATE TABLE ai_customer_memory (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  memory_type       VARCHAR(30) NOT NULL CHECK (memory_type IN (
                    'preference', 'behavior', 'purchase', 'conversation',
                    'style', 'product', 'service', 'complaint', 'feedback',
                    'life_event', 'observation'
                  )),
  category          VARCHAR(50),                         -- agrupamento: 'hair', 'color', 'schedule', 'product_brand'
  content           TEXT NOT NULL,
  context           TEXT,                                 -- quando/como foi observado
  confidence        DECIMAL(5,4) DEFAULT 0.7000,          -- 0.0000 a 1.0000
  source            VARCHAR(30) NOT NULL CHECK (source IN (
                    'ai_inference', 'professional_note', 'customer_input',
                    'behavior_analysis', 'purchase_history', 'conversation_log'
                  )),
  is_active         BOOLEAN NOT NULL DEFAULT true,
  observed_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_memory_tenant ON ai_customer_memory(tenant_id);
CREATE INDEX idx_memory_customer ON ai_customer_memory(customer_id);
CREATE INDEX idx_memory_type ON ai_customer_memory(customer_id, memory_type);
CREATE INDEX idx_memory_category ON ai_customer_memory(customer_id, category);
CREATE INDEX idx_memory_active ON ai_customer_memory(customer_id) WHERE is_active = true;
CREATE INDEX idx_memory_confidence ON ai_customer_memory(customer_id, confidence DESC);

-- ============================================================
-- AI CONVERSATIONS (histórico de interações com a IA)
-- ============================================================
CREATE TABLE ai_conversations (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  channel           VARCHAR(20) NOT NULL CHECK (channel IN ('whatsapp', 'app', 'admin', 'email')),
  summary           TEXT NOT NULL,
  sentiment         VARCHAR(10) CHECK (sentiment IN ('positive', 'neutral', 'negative')),
  intents           TEXT[] NOT NULL DEFAULT '{}',
  memory_ids        UUID[] NOT NULL DEFAULT '{}',          -- memórias criadas/atualizadas nesta conversa
  metadata          JSONB NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_conversations_customer ON ai_conversations(customer_id, created_at DESC);
CREATE INDEX idx_conversations_tenant ON ai_conversations(tenant_id);

-- ============================================================
-- VIEW: memória consolidada por cliente
-- ============================================================
CREATE VIEW v_customer_memory_summary AS
SELECT
  m.customer_id,
  c.name AS customer_name,
  c.phone,
  jsonb_object_agg(m.memory_type, m.content) FILTER (WHERE m.is_active) AS active_memories,
  COUNT(*) FILTER (WHERE m.is_active) AS active_memory_count,
  MAX(m.observed_at) AS last_memory_at
FROM ai_customer_memory m
JOIN customers c ON c.id = m.customer_id
GROUP BY m.customer_id, c.name, c.phone;
