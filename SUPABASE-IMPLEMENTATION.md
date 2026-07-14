# SUPABASE IMPLEMENTATION — Studio Letícia Experience

## Stack

- **Banco**: PostgreSQL 15+ via Supabase
- **Auth**: Supabase Auth (email + magic link + OAuth)
- **Storage**: Supabase Storage (fotos de perfil, galeria)
- **Realtime**: Supabase Realtime (agenda, notificações)
- **Functions**: Supabase Edge Functions (Deno)
- **ORMs**: Isolado — queries nativas via `postgrest-js` + Supabase client

## Estrutura de Migrations

```
supabase/migrations/
├── 001_extensions.sql         uuid-ossp, pgcrypto, btree_gist
├── 002_core.sql               tenants, tenant_themes, tenant_features
├── 003_identity.sql           roles, users, user_sessions
├── 004_beauty.sql             services, professionals, customers, CRM
├── 005_booking.sql            appointments, reminders, history
├── 006_financial.sql          payments, transactions, commissions, cash
├── 007_loyalty.sql            loyalty_accounts, points_ledger, rewards
├── 008_commerce.sql           products, inventory, product_sales
├── 009_engagement.sql         brand, campaigns, coupons, memberships
├── 010_platform.sql           audit_logs, product_events, integrations,
│                              notification_templates, automation_rules
├── 011_functions.sql          helper functions + triggers
├── 012_rls.sql                RLS policies (aplicado após functions)
├── 013_indexes.sql            índices de performance
└── 014_seed.sql               seed data para desenvolvimento
```

### Ordem de dependências

```
001 ext → 002 core → 003 identity → 004 beauty → 005 booking
                                       ↓
                                 006 financial
                                       ↓
                                 007 loyalty
                                       ↓
                                 008 commerce
                                       ↓
                                 009 engagement
                                       ↓
                                 010 platform
                                       ↓
                                 011 functions → 012 RLS → 013 indexes → 014 seed
```

## Variáveis de Ambiente

```env
NEXT_PUBLIC_SUPABASE_URL=https://seu-projeto.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...
```

## Como Rodar Migrations

### Local (Supabase CLI)

```bash
supabase login
supabase init
supabase link --project-ref seu-project-ref
supabase db push
```

### CI/CD (GitHub Actions)

```yaml
- name: Deploy migrations
  run: |
    npx supabase db push \
      --db-url "postgresql://postgres:${{ secrets.SUPABASE_DB_PASSWORD }}@${{ secrets.SUPABASE_DB_HOST }}:5432/postgres"
```

## Edge Functions Planejadas

| Function | Trigger | Descrição |
|---|---|---|
| `process-payment` | INSERT payments | Integração Mercado Pago |
| `payment-webhook` | HTTP POST | Webhook de confirmação de pagamento |
| `send-notification` | INSERT notification_queue | Dispara push/WhatsApp/e-mail |
| `calculate-commission` | UPDATE appointment → completed | Calcula comissão do profissional |
| `award-loyalty-points` | INSERT payments | Concede pontos de fidelidade |
| `ingest-product-event` | INSERT product_events | Envia eventos para PostHog |
| `birthday-campaign` | CRON diário | Dispara campanhas de aniversário |
| `automation-trigger` | INSERT trigger_event | Avalia regras de automação |

## Supabase Client Setup

```dart
// packages/core/lib/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientConfig {
  static final client = Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
  }
}
```

## Checklist de Produção

- [ ] Migrations aplicadas em ordem
- [ ] RLS policies ativadas em todas as tabelas
- [ ] Helper functions `get_user_tenant_id()`, `get_user_role_level()` no lugar
- [ ] Triggers de `tenant_id` automático ativos
- [ ] Trigger `updated_at` em todas as tabelas
- [ ] Índices criados (especialmente GiST para appointments)
- [ ] Seed data removido em produção
- [ ] Variáveis de ambiente configuradas no Vercel/Supabase
- [ ] CORS configurado no Supabase
- [ ] Rate limiting ativado nas Edge Functions
- [ ] Sentry configurado para monitoramento de erros
- [ ] Backup automático ativado (Point-in-Time Recovery)
- [ ] `app_metadata` configurado no JWT com `tenant_id` e `role_level`

## Segurança

- `tenant_id` é injetado via `request.jwt.claims` no JWT
- Toda query RLS usa `get_user_tenant_id()` para filtrar por tenant
- Credenciais de terceiros (Mercado Pago, Weni) armazenadas criptografadas em `integrations`
- Logs de auditoria em `audit_logs` para operações críticas
- MFA habilitado a nível de tenant/usuário
- Dados pessoais (LGPD) com campos `consent_given`, `data_retention_until` em `customers`
