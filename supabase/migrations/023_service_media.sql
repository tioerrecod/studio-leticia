-- 023_service_media.sql
-- Schema: Galeria de mídia por serviço (fotos/vídeos)
-- Upload feito pela Letícia via Painel Admin, exibido no app do cliente

CREATE TABLE service_media (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  service_id      UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  url             TEXT NOT NULL,
  type            VARCHAR(10) NOT NULL DEFAULT 'image' CHECK (type IN ('image', 'video')),
  caption         TEXT,
  is_cover        BOOLEAN NOT NULL DEFAULT false,
  sort_order      INTEGER NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_service_media_service ON service_media(service_id, sort_order);
CREATE INDEX idx_service_media_cover ON service_media(service_id) WHERE is_cover = true;

-- Bucket de storage para uploads
INSERT INTO storage.buckets (id, name, public) VALUES ('service-media', 'service-media', true)
ON CONFLICT (id) DO NOTHING;

ALTER TABLE service_media ENABLE ROW LEVEL SECURITY;

-- Função reutilizável: usuário autenticado é admin do tenant?
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM users u
    JOIN roles r ON r.id = u.role_id
    WHERE u.auth_user_id = auth.uid()
      AND u.is_active = true
      AND r.name IN ('admin', 'super_admin_1', 'super_admin_2', 'system_owner')
  );
$$;

CREATE POLICY "Service media public read"
  ON service_media FOR SELECT
  USING (true);

CREATE POLICY "Service media admin insert"
  ON service_media FOR INSERT
  WITH CHECK (public.is_admin());

CREATE POLICY "Service media admin update"
  ON service_media FOR UPDATE
  USING (public.is_admin());

CREATE POLICY "Service media admin delete"
  ON service_media FOR DELETE
  USING (public.is_admin());
