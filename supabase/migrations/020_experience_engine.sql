-- 020_experience_engine.sql
-- Experience Engine: registra a jornada completa do cliente
-- antes, durante e depois de cada atendimento
-- Depende de: 004_beauty.sql (customers), 005_booking.sql (appointments)

-- ============================================================
-- CUSTOMER EXPERIENCES
-- ============================================================
CREATE TABLE customer_experiences (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  appointment_id    UUID UNIQUE REFERENCES appointments(id) ON DELETE CASCADE,
  stage             VARCHAR(20) NOT NULL CHECK (stage IN ('before', 'during', 'after')),
  emotion_score     INTEGER CHECK (emotion_score BETWEEN 1 AND 10),
  satisfaction_score INTEGER CHECK (satisfaction_score BETWEEN 1 AND 5),
  notes             TEXT,
  photos            TEXT[] NOT NULL DEFAULT '{}',
  preferences       JSONB NOT NULL DEFAULT '{}',
  metadata          JSONB NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_experiences_tenant ON customer_experiences(tenant_id);
CREATE INDEX idx_experiences_customer ON customer_experiences(customer_id, created_at DESC);
CREATE INDEX idx_experiences_appointment ON customer_experiences(appointment_id);
CREATE INDEX idx_experiences_stage ON customer_experiences(tenant_id, stage);

-- ============================================================
-- EXPERIENCE STEPS (checklist do atendimento)
-- ============================================================
CREATE TABLE experience_steps (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  experience_id     UUID NOT NULL REFERENCES customer_experiences(id) ON DELETE CASCADE,
  step_order        INTEGER NOT NULL,
  title             VARCHAR(255) NOT NULL,
  description       TEXT,
  duration_min      INTEGER,
  completed         BOOLEAN NOT NULL DEFAULT false,
  completed_at      TIMESTAMPTZ,
  media_urls        TEXT[] NOT NULL DEFAULT '{}',
  notes             TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_exp_steps_experience ON experience_steps(experience_id);

-- ============================================================
-- TRIGGER: criar experience automaticamente no appointment
-- ============================================================
CREATE OR REPLACE FUNCTION create_experience_on_appointment()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO customer_experiences (tenant_id, customer_id, appointment_id, stage)
    VALUES (NEW.tenant_id, NEW.customer_id, NEW.id, 'before');
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_create_experience
  AFTER INSERT ON appointments
  FOR EACH ROW
  EXECUTE FUNCTION create_experience_on_appointment();

-- ============================================================
-- VIEW: timeline da experiência do cliente
-- ============================================================
CREATE VIEW v_customer_experience_timeline AS
SELECT
  ce.id,
  ce.tenant_id,
  ce.customer_id,
  c.name AS customer_name,
  ce.appointment_id,
  a.start_at AS appointment_date,
  a.status AS appointment_status,
  pr.name AS professional_name,
  ce.stage,
  ce.emotion_score,
  ce.satisfaction_score,
  ce.notes,
  ce.created_at,
  (SELECT jsonb_agg(jsonb_build_object(
    'step', es.step_order,
    'title', es.title,
    'completed', es.completed,
    'completed_at', es.completed_at
   ) ORDER BY es.step_order)
   FROM experience_steps es WHERE es.experience_id = ce.id) AS steps
FROM customer_experiences ce
JOIN customers c ON c.id = ce.customer_id
JOIN appointments a ON a.id = ce.appointment_id
JOIN professionals pr ON pr.id = a.professional_id;
