-- 008_commerce.sql
-- Schema COMMERCE: products, inventory, sales
-- Depende de: 004_beauty.sql (services), 005_booking.sql (appointments)

-- ============================================================
-- PRODUCT CATEGORIES
-- ============================================================
CREATE TABLE product_categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  description TEXT,
  icon        VARCHAR(50),
  sort_order  INTEGER NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_product_categories_tenant ON product_categories(tenant_id);

-- ============================================================
-- PRODUCTS
-- ============================================================
CREATE TABLE products (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  category_id       UUID REFERENCES product_categories(id),
  name              VARCHAR(255) NOT NULL,
  brand             VARCHAR(255),
  description       TEXT,
  price             DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  cost_price        DECIMAL(10,2) CHECK (cost_price IS NULL OR cost_price >= 0),
  stock_quantity    INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
  min_stock         INTEGER NOT NULL DEFAULT 5,
  barcode           VARCHAR(100),
  image_url         TEXT,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  is_service        BOOLEAN NOT NULL DEFAULT false,
  service_id        UUID REFERENCES services(id) ON DELETE SET NULL,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_tenant ON products(tenant_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_low_stock ON products(tenant_id) WHERE stock_quantity <= min_stock;

-- ============================================================
-- INVENTORY MOVEMENTS
-- ============================================================
CREATE TABLE inventory_movements (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  product_id        UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  type              VARCHAR(20) NOT NULL CHECK (type IN ('in', 'out', 'adjustment', 'sale', 'return')),
  quantity          INTEGER NOT NULL,
  quantity_after    INTEGER NOT NULL,
  reference_id      UUID,
  reference_type    VARCHAR(30),
  description       TEXT,
  created_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_movements_product ON inventory_movements(product_id, created_at DESC);
CREATE INDEX idx_movements_tenant ON inventory_movements(tenant_id);

-- ============================================================
-- PRODUCT SALES
-- ============================================================
CREATE TABLE product_sales (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  customer_id       UUID NOT NULL REFERENCES customers(id),
  appointment_id    UUID REFERENCES appointments(id) ON DELETE SET NULL,
  items             JSONB NOT NULL DEFAULT '[]',
  subtotal          DECIMAL(10,2) NOT NULL,
  discount          DECIMAL(10,2) NOT NULL DEFAULT 0,
  total             DECIMAL(10,2) NOT NULL,
  payment_method    VARCHAR(20) CHECK (payment_method IN ('credit_card', 'debit_card', 'pix', 'cash', 'ticket')),
  payment_status    VARCHAR(20) NOT NULL DEFAULT 'pending'
                    CHECK (payment_status IN ('pending', 'paid', 'refunded')),
  notes             TEXT,
  created_by        UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_sales_tenant ON product_sales(tenant_id);
CREATE INDEX idx_sales_customer ON product_sales(customer_id);
CREATE INDEX idx_sales_appointment ON product_sales(appointment_id);
