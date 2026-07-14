-- 014_seed.sql
-- Seed data para desenvolvimento — Studio Letícia
-- Apenas para ambiente de desenvolvimento. Remover em produção.

-- ============================================================
-- CONFIGURAR JWT SIMULADO PARA SEED (triggers precisam de tenant_id)
-- ============================================================
SELECT set_config('request.jwt.claims', '{"tenant_id": "00000000-0000-0000-0000-000000000001", "app_metadata": {"role_level": 7}}', false);

-- ============================================================
-- TENANT PADRÃO
-- ============================================================
INSERT INTO tenants (id, name, slug, plan, status, settings, timezone, locale) VALUES
  ('00000000-0000-0000-0000-000000000001', 
   'Studio Letícia', 
   'studio-leticia', 
   'professional', 
   'active',
   '{"business_hours": {"monday": {"open": "09:00", "close": "19:00"}, "tuesday": {"open": "09:00", "close": "19:00"}, "wednesday": {"open": "09:00", "close": "19:00"}, "thursday": {"open": "09:00", "close": "19:00"}, "friday": {"open": "09:00", "close": "19:00"}, "saturday": {"open": "09:00", "close": "17:00"}}}',
   'America/Sao_Paulo',
   'pt-BR')
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- TEMA DO STUDIO LETÍCIA
-- ============================================================
INSERT INTO tenant_themes (tenant_id, primary_color, secondary_color, background_color) VALUES
  ('00000000-0000-0000-0000-000000000001', '#D81B60', '#FFB300', '#F5F0EB')
ON CONFLICT (tenant_id) DO NOTHING;

-- ============================================================
-- FEATURE FLAGS INICIAIS
-- ============================================================
INSERT INTO tenant_features (tenant_id, key, name, is_enabled) VALUES
  ('00000000-0000-0000-0000-000000000001', 'online_booking', 'Agendamento online', true),
  ('00000000-0000-0000-0000-000000000001', 'payment_online', 'Pagamento online', false),
  ('00000000-0000-0000-0000-000000000001', 'loyalty_program', 'Programa de fidelidade', false),
  ('00000000-0000-0000-0000-000000000001', 'whatsapp_reminder', 'Lembrete via WhatsApp', false),
  ('00000000-0000-0000-0000-000000000001', 'gallery_public', 'Galeria pública', true),
  ('00000000-0000-0000-0000-000000000001', 'multi_tenant', 'Modo multi-tenant', false)
ON CONFLICT (tenant_id, key) DO NOTHING;

-- ============================================================
-- CATEGORIAS DE SERVIÇO
-- ============================================================
INSERT INTO service_categories (tenant_id, name, icon, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Cortes', 'content_cut', 1),
  ('00000000-0000-0000-0000-000000000001', 'Coloração', 'palette', 2),
  ('00000000-0000-0000-0000-000000000001', 'Tratamentos', 'spa', 3),
  ('00000000-0000-0000-0000-000000000001', 'Manicure & Pedicure', 'pan_tool', 4),
  ('00000000-0000-0000-0000-000000000001', 'Maquiagem', 'face', 5),
  ('00000000-0000-0000-0000-000000000001', 'Depilação', 'wave', 6)
ON CONFLICT DO NOTHING;

-- ============================================================
-- SERVIÇOS
-- ============================================================
DO $$
DECLARE
  v_cat_cortes UUID;
  v_cat_coloracao UUID;
  v_cat_tratamentos UUID;
  v_cat_manicure UUID;
BEGIN
  SELECT id INTO v_cat_cortes FROM service_categories WHERE name = 'Cortes' AND tenant_id = '00000000-0000-0000-0000-000000000001';
  SELECT id INTO v_cat_coloracao FROM service_categories WHERE name = 'Coloração' AND tenant_id = '00000000-0000-0000-0000-000000000001';
  SELECT id INTO v_cat_tratamentos FROM service_categories WHERE name = 'Tratamentos' AND tenant_id = '00000000-0000-0000-0000-000000000001';
  SELECT id INTO v_cat_manicure FROM service_categories WHERE name = 'Manicure & Pedicure' AND tenant_id = '00000000-0000-0000-0000-000000000001';

  INSERT INTO services (tenant_id, category_id, name, duration, price, commission_percentage, is_signature, sort_order) VALUES
    ('00000000-0000-0000-0000-000000000001', v_cat_cortes, 'Corte Feminino', 45, 80.00, 50.00, true, 1),
    ('00000000-0000-0000-0000-000000000001', v_cat_cortes, 'Corte Masculino', 30, 50.00, 50.00, false, 2),
    ('00000000-0000-0000-0000-000000000001', v_cat_coloracao, 'Escova Progressiva', 120, 200.00, 40.00, true, 3),
    ('00000000-0000-0000-0000-000000000001', v_cat_coloracao, 'Mechas', 150, 250.00, 40.00, true, 4),
    ('00000000-0000-0000-0000-000000000001', v_cat_tratamentos, 'Hidratação', 40, 60.00, 50.00, false, 5),
    ('00000000-0000-0000-0000-000000000001', v_cat_manicure, 'Manicure', 30, 35.00, 50.00, false, 6),
    ('00000000-0000-0000-0000-000000000001', v_cat_manicure, 'Pedicure', 30, 35.00, 50.00, false, 7)
  ON CONFLICT DO NOTHING;
END $$;

-- ============================================================
-- BRAND EXPERIENCE
-- ============================================================
INSERT INTO brand_experiences (tenant_id, welcome_title, welcome_subtitle, mood_description) VALUES
  ('00000000-0000-0000-0000-000000000001',
   'Sua próxima experiência começa aqui',
   'Studio Letícia — onde a beleza encontra a excelência',
   'Elegante, acolhedor, sofisticado. Cada visita é um momento de cuidado e transformação.')
ON CONFLICT (tenant_id) DO NOTHING;

-- ============================================================
-- MEMBERSHIP PLAN
-- ============================================================
INSERT INTO membership_plans (tenant_id, name, description, monthly_price, benefits, max_active) VALUES
  ('00000000-0000-0000-0000-000000000001',
   'Studio Gold',
   'Tenha prioridade na agenda e descontos exclusivos',
   199.00,
   ARRAY['Prioridade na agenda', '20% de desconto em produtos', '1 hidratação grátis por mês', 'Indicação de horário inteligente'],
   50)
ON CONFLICT DO NOTHING;

-- ============================================================
-- CATEGORIAS DE PRODUTOS
-- ============================================================
INSERT INTO product_categories (tenant_id, name, icon, sort_order) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Shampoos & Condicionadores', 'shampoo', 1),
  ('00000000-0000-0000-0000-000000000001', 'Máscaras & Tratamentos', 'spa', 2),
  ('00000000-0000-0000-0000-000000000001', 'Finalizadores', 'air', 3),
  ('00000000-0000-0000-0000-000000000001', 'Kits & Combos', 'card_giftcard', 4)
ON CONFLICT DO NOTHING;

-- ============================================================
-- PRODUTOS
-- ============================================================
DO $$
DECLARE
  v_pc_shampoo UUID;
  v_pc_mascara UUID;
  v_pc_finalizador UUID;
  v_pc_kit UUID;
BEGIN
  SELECT id INTO v_pc_shampoo FROM product_categories WHERE name = 'Shampoos & Condicionadores' AND tenant_id = '00000000-0000-0000-0000-000000000001';
  SELECT id INTO v_pc_mascara FROM product_categories WHERE name = 'Máscaras & Tratamentos' AND tenant_id = '00000000-0000-0000-0000-000000000001';
  SELECT id INTO v_pc_finalizador FROM product_categories WHERE name = 'Finalizadores' AND tenant_id = '00000000-0000-0000-0000-000000000001';
  SELECT id INTO v_pc_kit FROM product_categories WHERE name = 'Kits & Combos' AND tenant_id = '00000000-0000-0000-0000-000000000001';

  INSERT INTO products (tenant_id, category_id, name, brand, price, cost_price, stock_quantity, min_stock) VALUES
    ('00000000-0000-0000-0000-000000000001', v_pc_shampoo, 'Shampoo Reconstrutor', 'Profissional Line', 45.90, 22.00, 20, 5),
    ('00000000-0000-0000-0000-000000000001', v_pc_shampoo, 'Condicionador Reconstrutor', 'Profissional Line', 49.90, 24.00, 15, 5),
    ('00000000-0000-0000-0000-000000000001', v_pc_mascara, 'Máscara de Hidratação Intensa', 'Profissional Line', 79.90, 35.00, 10, 3),
    ('00000000-0000-0000-0000-000000000001', v_pc_finalizador, 'Leave-in Protetor Térmico', 'Profissional Line', 59.90, 28.00, 12, 3),
    ('00000000-0000-0000-0000-000000000001', v_pc_kit, 'Kit Cuidados Completos', 'Studio Letícia', 199.00, 85.00, 5, 2)
  ON CONFLICT DO NOTHING;
END $$;

-- ============================================================
-- NOTIFICATION TEMPLATES
-- ============================================================
INSERT INTO notification_templates (tenant_id, channel, event_type, title, body, variables) VALUES
  ('00000000-0000-0000-0000-000000000001', 'push', 'appointment.confirmed',
   'Agendamento confirmado!',
   'Olá {{customer_name}}, seu horário com {{professional_name}} em {{appointment_date}} foi confirmado.',
   '["customer_name", "professional_name", "appointment_date"]'),
  ('00000000-0000-0000-0000-000000000001', 'push', 'appointment.reminder_24h',
   'Seu horário é amanhã!',
   'Lembramos do seu agendamento amanhã às {{appointment_time}} com {{professional_name}}. Confirme ou cancele.',
   '["customer_name", "professional_name", "appointment_time"]'),
  ('00000000-0000-0000-0000-000000000001', 'whatsapp', 'appointment.completed',
   'Como foi seu atendimento?',
   'Olá {{customer_name}}, seu atendimento com {{professional_name}} foi concluído. Avalie sua experiência!',
   '["customer_name", "professional_name"]'),
  ('00000000-0000-0000-0000-000000000001', 'whatsapp', 'birthday',
   'Feliz aniversário!',
   'Feliz aniversário, {{customer_name}}! Ganhe {{bonus_points}} pontos de presente para usar no Studio Letícia.',
   '["customer_name", "bonus_points"]')
ON CONFLICT DO NOTHING;

-- ============================================================
-- AUTOMATION RULES
-- ============================================================
INSERT INTO automation_rules (tenant_id, name, trigger_event, trigger_delay, channel, template_id) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Lembrete 24h antes', 'appointment.scheduled', 1380, 'push',
   (SELECT id FROM notification_templates WHERE event_type = 'appointment.reminder_24h' AND tenant_id = '00000000-0000-0000-0000-000000000001')),
  ('00000000-0000-0000-0000-000000000001', 'Confirmação de agendamento', 'appointment.scheduled', 0, 'push',
   (SELECT id FROM notification_templates WHERE event_type = 'appointment.confirmed' AND tenant_id = '00000000-0000-0000-0000-000000000001'))
ON CONFLICT DO NOTHING;

-- ============================================================
-- CAMPAIGN
-- ============================================================
INSERT INTO campaigns (tenant_id, name, type, trigger_type, audience_segment, message_template, status) VALUES
  ('00000000-0000-0000-0000-000000000001',
   'Aniversariantes do mês',
   'birthday', 'auto',
   '{"tags_incluir": [], "min_visits": 1}',
   'Olá {{customer_name}}, feliz aniversário! Ganhe 50 pontos extras no Studio Letícia.',
   'active')
ON CONFLICT DO NOTHING;
