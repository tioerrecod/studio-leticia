-- 009_engagement.sql
-- Schema ENGAGEMENT: brand experience, campaigns, coupons, memberships
-- Depende de: 004_beauty.sql (customers, services), 008_commerce.sql (product_sales)

-- ============================================================
-- BRAND EXPERIENCE ENGINE
-- ============================================================
CREATE TABLE brand_experiences (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  welcome_title     VARCHAR(255) NOT NULL DEFAULT 'Sua próxima experiência começa aqui',
  welcome_subtitle  VARCHAR(255),
  mood_description  TEXT,
  hero_images       TEXT[] NOT NULL DEFAULT '{}',
  instagram_handle  VARCHAR(100),
  instagram_token   TEXT,
  about_text        TEXT,
  address           TEXT,
  phone             VARCHAR(20),
  whatsapp_number   VARCHAR(20),
  business_hours    JSONB NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id)
);

-- ============================================================
-- TESTIMONIALS
-- ============================================================
CREATE TABLE testimonials (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_name     VARCHAR(255) NOT NULL,
  customer_photo    TEXT,
  text              TEXT NOT NULL,
  service_name      VARCHAR(255),
  rating            INTEGER CHECK (rating BETWEEN 1 AND 5),
  is_featured       BOOLEAN NOT NULL DEFAULT false,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_testimonials_tenant ON testimonials(tenant_id);
CREATE INDEX idx_testimonials_featured ON testimonials(tenant_id) WHERE is_featured = true;

-- ============================================================
-- GALLERY
-- ============================================================
CREATE TABLE gallery (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  image_url         TEXT NOT NULL,
  thumbnail_url     TEXT,
  alt_text          VARCHAR(255),
  category          VARCHAR(50) CHECK (category IN ('salon', 'before_after', 'team', 'products', 'events')),
  before_image_url  TEXT,
  after_image_url   TEXT,
  is_featured       BOOLEAN NOT NULL DEFAULT false,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_gallery_tenant ON gallery(tenant_id);
CREATE INDEX idx_gallery_category ON gallery(tenant_id, category);

-- ============================================================
-- CAMPAIGNS
-- ============================================================
CREATE TABLE campaigns (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name              VARCHAR(255) NOT NULL,
  description       TEXT,
  type              VARCHAR(30) NOT NULL CHECK (type IN (
                    'promotion', 'birthday', 'season', 'retargeting',
                    'welcome', 'loyalty', 'referral', 'holiday'
                  )),
  trigger_type      VARCHAR(30) NOT NULL CHECK (trigger_type IN ('auto', 'manual', 'scheduled')),
  audience_segment  JSONB NOT NULL DEFAULT '{}',
  channel           VARCHAR(20)[] NOT NULL DEFAULT '{whatsapp}',
  message_template  TEXT,
  start_at          TIMESTAMPTZ,
  end_at            TIMESTAMPTZ,
  status            VARCHAR(20) NOT NULL DEFAULT 'draft'
                    CHECK (status IN ('draft', 'scheduled', 'active', 'finished', 'cancelled')),
  sent_count        INTEGER NOT NULL DEFAULT 0,
  opened_count      INTEGER NOT NULL DEFAULT 0,
  conversion_count  INTEGER NOT NULL DEFAULT 0,
  created_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_campaigns_tenant ON campaigns(tenant_id);
CREATE INDEX idx_campaigns_status ON campaigns(tenant_id, status);

-- ============================================================
-- CAMPAIGN AUDIENCE
-- ============================================================
CREATE TABLE campaign_audience (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id       UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  sent_at           TIMESTAMPTZ,
  opened_at         TIMESTAMPTZ,
  clicked_at        TIMESTAMPTZ,
  converted_at      TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(campaign_id, customer_id)
);

CREATE INDEX idx_campaign_audience ON campaign_audience(campaign_id);

-- ============================================================
-- COUPONS
-- ============================================================
CREATE TABLE coupons (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  code              VARCHAR(50) NOT NULL,
  type              VARCHAR(20) NOT NULL CHECK (type IN ('percentage', 'fixed', 'free_service', 'free_product')),
  value             DECIMAL(10,2) NOT NULL,
  min_value         DECIMAL(10,2) DEFAULT 0,
  max_uses          INTEGER DEFAULT 0,
  current_uses      INTEGER NOT NULL DEFAULT 0,
  max_uses_per_customer INTEGER DEFAULT 1,
  applicable_services UUID[] DEFAULT '{}',
  applicable_products  UUID[] DEFAULT '{}',
  starts_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at        TIMESTAMPTZ,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, code)
);

CREATE INDEX idx_coupons_tenant ON coupons(tenant_id);
CREATE INDEX idx_coupons_code ON coupons(tenant_id, code);
CREATE INDEX idx_coupons_active ON coupons(tenant_id) WHERE is_active = true;

-- ============================================================
-- COUPON USAGES
-- ============================================================
CREATE TABLE coupon_usages (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_id         UUID NOT NULL REFERENCES coupons(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  appointment_id    UUID REFERENCES appointments(id) ON DELETE SET NULL,
  product_sale_id   UUID REFERENCES product_sales(id) ON DELETE SET NULL,
  discount_amount   DECIMAL(10,2) NOT NULL,
  used_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_coupon_usages_coupon ON coupon_usages(coupon_id);
CREATE INDEX idx_coupon_usages_customer ON coupon_usages(customer_id);

-- ============================================================
-- MEMBERSHIP PLANS
-- ============================================================
CREATE TABLE membership_plans (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name              VARCHAR(255) NOT NULL,
  description       TEXT,
  monthly_price     DECIMAL(10,2) NOT NULL CHECK (monthly_price > 0),
  billing_cycle     VARCHAR(20) NOT NULL DEFAULT 'monthly' CHECK (billing_cycle IN ('monthly', 'quarterly', 'yearly')),
  services_included JSONB NOT NULL DEFAULT '[]',
  benefits          TEXT[] NOT NULL DEFAULT '{}',
  max_active        INTEGER NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_plans_tenant ON membership_plans(tenant_id);

-- ============================================================
-- CUSTOMER MEMBERSHIPS
-- ============================================================
CREATE TABLE customer_memberships (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  plan_id           UUID NOT NULL REFERENCES membership_plans(id),
  status            VARCHAR(20) NOT NULL DEFAULT 'active'
                    CHECK (status IN ('active', 'cancelled', 'expired', 'trial')),
  started_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  next_billing_at   TIMESTAMPTZ NOT NULL,
  cancelled_at      TIMESTAMPTZ,
  payment_method    VARCHAR(20) CHECK (payment_method IN ('credit_card', 'pix')),
  gateway_subscription_id VARCHAR(255),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(tenant_id, customer_id)
);

CREATE INDEX idx_memberships_customer ON customer_memberships(customer_id);
CREATE INDEX idx_memberships_status ON customer_memberships(status);
