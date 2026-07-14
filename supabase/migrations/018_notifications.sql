-- 018_notifications.sql
-- Histórico de notificações enviadas (diferente de templates)
-- Depende de: 003_identity.sql (users), 010_platform.sql (notification_templates)

-- ============================================================
-- NOTIFICATIONS (histórico de envio)
-- ============================================================
CREATE TABLE notifications (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id           UUID REFERENCES users(id) ON DELETE SET NULL,
  profile_id        UUID REFERENCES profiles(id) ON DELETE SET NULL,
  channel           VARCHAR(20) NOT NULL CHECK (channel IN ('push', 'whatsapp', 'email', 'sms')),
  template_id       UUID REFERENCES notification_templates(id) ON DELETE SET NULL,
  title             VARCHAR(255),
  body              TEXT NOT NULL,
  metadata          JSONB NOT NULL DEFAULT '{}',
  status            VARCHAR(20) NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'sent', 'delivered', 'failed', 'opened', 'clicked')),
  sent_at           TIMESTAMPTZ,
  delivered_at      TIMESTAMPTZ,
  opened_at         TIMESTAMPTZ,
  clicked_at        TIMESTAMPTZ,
  failed_at         TIMESTAMPTZ,
  error_message     TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_notifications_tenant ON notifications(tenant_id, created_at DESC);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_profile ON notifications(profile_id);
CREATE INDEX idx_notifications_status ON notifications(status);
CREATE INDEX idx_notifications_channel ON notifications(channel);
CREATE INDEX idx_notifications_template ON notifications(template_id);
CREATE INDEX idx_notifications_campaign ON notifications((metadata->>'campaign_id'))
  WHERE metadata ? 'campaign_id';

-- ============================================================
-- NOTIFICATION QUEUE (fila de envio — consumida por Edge Functions)
-- ============================================================
CREATE TABLE notification_queue (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  notification_id   UUID UNIQUE REFERENCES notifications(id) ON DELETE CASCADE,
  channel           VARCHAR(20) NOT NULL CHECK (channel IN ('push', 'whatsapp', 'email', 'sms')),
  recipient         VARCHAR(255) NOT NULL,
  payload           JSONB NOT NULL DEFAULT '{}',
  priority          INTEGER NOT NULL DEFAULT 0,
  scheduled_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  locked_at         TIMESTAMPTZ,
  locked_by         VARCHAR(100),
  attempts          INTEGER NOT NULL DEFAULT 0,
  max_attempts      INTEGER NOT NULL DEFAULT 3,
  last_error        TEXT,
  status            VARCHAR(20) NOT NULL DEFAULT 'queued'
                    CHECK (status IN ('queued', 'processing', 'sent', 'failed')),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_notification_queue_status ON notification_queue(status, scheduled_at)
  WHERE status = 'queued';
CREATE INDEX idx_notification_queue_scheduled ON notification_queue(scheduled_at)
  WHERE status = 'queued';
