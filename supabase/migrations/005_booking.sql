-- 005_booking.sql
-- Schema BOOKING: appointments, reminders, history
-- Depende de: 004_beauty.sql (customers, professionals, services)

-- ============================================================
-- APPOINTMENTS
-- ============================================================
CREATE TABLE appointments (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id           UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id         UUID NOT NULL REFERENCES customers(id),
  professional_id     UUID NOT NULL REFERENCES professionals(id),
  start_at            TIMESTAMPTZ NOT NULL,
  end_at              TIMESTAMPTZ NOT NULL,
  status              VARCHAR(20) NOT NULL DEFAULT 'requested'
                      CHECK (status IN (
                        'requested', 'scheduled', 'confirmed', 'arrived',
                        'in_progress', 'completed', 'paid',
                        'cancelled', 'no_show', 'rescheduled'
                      )),
  total_amount        DECIMAL(10,2) NOT NULL DEFAULT 0,
  commission_amount   DECIMAL(10,2) NOT NULL DEFAULT 0,
  source              VARCHAR(20) NOT NULL DEFAULT 'app_admin'
                      CHECK (source IN ('app_online', 'app_admin', 'whatsapp', 'walkin')),
  arrived_at          TIMESTAMPTZ,
  notes               TEXT,
  reschedule_count    INTEGER NOT NULL DEFAULT 0,
  reschedule_from     UUID REFERENCES appointments(id) ON DELETE SET NULL,
  cancelled_at        TIMESTAMPTZ,
  cancellation_reason VARCHAR(20) CHECK (cancellation_reason IN (
                        'customer', 'professional', 'no_show', 'system'
                      )),
  cancelled_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  metadata            JSONB NOT NULL DEFAULT '{}',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT valid_end CHECK (end_at > start_at)
);

CREATE INDEX idx_appointments_tenant_date ON appointments(tenant_id, start_at);
CREATE INDEX idx_appointments_professional_date ON appointments(professional_id, start_at);
CREATE INDEX idx_appointments_customer ON appointments(customer_id);
CREATE INDEX idx_appointments_status ON appointments(tenant_id, status);
CREATE INDEX idx_appointments_date_status ON appointments(start_at, status);
CREATE INDEX idx_appointments_no_overlap
  ON appointments USING gist (professional_id, tstzrange(start_at, end_at))
  WHERE status NOT IN ('cancelled', 'no_show');

-- ============================================================
-- APPOINTMENT SERVICES
-- ============================================================
CREATE TABLE appointment_services (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_id    UUID NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
  service_id        UUID NOT NULL REFERENCES services(id),
  name              VARCHAR(255) NOT NULL,
  duration          INTEGER NOT NULL,
  price             DECIMAL(10,2) NOT NULL,
  commission_pct    DECIMAL(5,2) NOT NULL,
  sort_order        INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_appt_services_appointment ON appointment_services(appointment_id);

-- ============================================================
-- APPOINTMENT REMINDERS
-- ============================================================
CREATE TABLE appointment_reminders (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_id  UUID NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
  type            VARCHAR(20) NOT NULL CHECK (type IN ('24h', '1h', 'confirmation')),
  channel         VARCHAR(20) NOT NULL CHECK (channel IN ('push', 'whatsapp', 'email')),
  sent_at         TIMESTAMPTZ,
  confirmed       BOOLEAN NOT NULL DEFAULT false,
  response_at     TIMESTAMPTZ,
  error_message   TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_reminders_appointment ON appointment_reminders(appointment_id);

-- ============================================================
-- APPOINTMENT HISTORY
-- ============================================================
CREATE TABLE appointment_history (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_id    UUID NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
  previous_status   VARCHAR(20),
  new_status        VARCHAR(20) NOT NULL,
  changed_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  reason            TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_history_appointment ON appointment_history(appointment_id);

-- ============================================================
-- FK adicional: customer_interactions.appointment_id
-- (tabela criada em 004, FK adicionada agora que appointments existe)
-- ============================================================
ALTER TABLE customer_interactions
  ADD CONSTRAINT fk_interactions_appointment
  FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL;
