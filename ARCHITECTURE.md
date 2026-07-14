---
id: sl-architecture
title: "Studio Letícia Experience — Architecture v1.0"
version: "1.0.0"
status: "architecture"
owner: "Chief Architect"
depends_on: ["sl-prd", "slbos", "dpes-architecture", "dpes-security", "bbop-domain-model"]
used_by: ["sl-database", "sl-implementation"]
last_review: "2026-07-13"
next_review: "2026-10-13"
---

# ARCHITECTURE — Studio Letícia Experience v1.0

**Baseado em**: DPES Architecture + BBOP Domain Model + PRD v1.0

---

## 1. Arquitetura Geral

### 1.1 Visão de Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENTES                                  │
│  ┌─────────────────────┐     ┌──────────────────────────────┐   │
│  │   Flutter App       │     │    Flutter Web Admin         │   │
│  │  (Customer + Prof)  │     │    (Owner + Manager)         │   │
│  │  Android / iOS      │     │    Responsivo 320px+         │   │
│  └─────────┬───────────┘     └──────────────┬───────────────┘   │
│            │                                 │                    │
│            │            Supabase SDK         │                    │
│            └─────────────────┬───────────────┘                    │
└──────────────────────────────┼───────────────────────────────────┘
                               │
┌──────────────────────────────┼───────────────────────────────────┐
│                     SUPABASE │ BACKEND                            │
│                              │                                    │
│   ┌──────────────────────────┼──────────────────────────────┐    │
│   │                     API LAYER                            │    │
│   │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐ │    │
│   │  │ Supabase │  │  Edge    │  │ Supabase │  │ Web-   │ │    │
│   │  │  Auth    │  │Functions │  │ Realtime │  │ hooks  │ │    │
│   │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └───┬────┘ │    │
│   └───────┼─────────────┼──────────────┼────────────┼──────┘    │
│           │             │              │            │           │
│   ┌───────┼─────────────┼──────────────┼────────────┼──────┐    │
│   │       ▼             ▼              ▼            ▼      │    │
│   │                  BUSINESS LAYER                        │    │
│   │  ┌─────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │    │
│   │  │Identity │ │ Booking  │ │ Financial│ │Engagement│  │    │
│   │  │ Module  │ │ Module   │ │ Module   │ │ Module   │  │    │
│   │  └────┬────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘  │    │
│   └───────┼────────────┼────────────┼────────────┼───────┘      │
│           │            │            │            │              │
│   ┌───────┼────────────┼────────────┼────────────┼───────┐      │
│   │       ▼            ▼            ▼            ▼       │      │
│   │               DATA LAYER (PostgreSQL)                 │      │
│   │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────┐ │      │
│   │  │  Auth    │ │Business  │ │ Financial│ │ Audit  │ │      │
│   │  │  Schema  │ │ Schema   │ │ Schema   │ │ Schema │ │      │
│   │  └──────────┘ └──────────┘ └──────────┘ └────────┘ │      │
│   └─────────────────────────────────────────────────────┘      │
│                              │                                  │
│   ┌──────────────────────────┼──────────────────────────────┐   │
│   │              PROVIDERS (Edge Functions)                  │   │
│   │  ┌──────────┐  ┌──────────┐  ┌────────────────────┐    │   │
│   │  │ Mercado  │  │   AI     │  │ Notifications      │    │   │
│   │  │ Pago     │  │ OpenAI   │  │ FCM + Email + ZAP  │    │   │
│   │  └──────────┘  └──────────┘  └────────────────────┘    │   │
│   └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2 Fluxo de Dados

```
[Flutter App] ──JWT──► [Supabase Client]
                            │
         ┌──────────────────┼──────────────────┐
         ▼                  ▼                  ▼
   [Direct Query]    [Edge Function]     [Supabase Realtime]
   (RLS protegido)   (lógica complexa)   (notificações live)
         │                  │
         ▼                  ▼
   [PostgreSQL]       [Provedor Externo]
                         (Mercado Pago,
                          OpenAI, FCM)
```

### 1.3 Camadas no Flutter (Clean Architecture)

```
┌──────────────────────────────────────┐
│          PRESENTATION                 │
│  Pages / Widgets / Providers          │
│  (Riverpod + GoRouter)               │
├──────────────────────────────────────┤
│              DOMAIN                   │
│  Use Cases / Entities / Repository    │
│  (Interfaces de repositório)          │
├──────────────────────────────────────┤
│               DATA                    │
│  Repository Impl / DTOs / Mapper     │
│  SupabaseClient / Edge Functions      │
└──────────────────────────────────────┘
```

**Regras**:
- Domain layer não importa Flutter, Supabase, nem qualquer framework externo
- Repository interfaces pertencem ao domain
- Use Cases orquestram entities e repositories
- Presentation depende apenas de Use Cases
- Data layer implementa repositories e chama Supabase/Edge Functions

---

## 2. Decisão Arquitetural: Modular Monolith

### Por que Modular Monolith?

Microserviços adicionam complexidade (rede, deploy, observabilidade, consistência) que **não se justifica** para um produto em estágio MVP com um time pequeno.

Um monólito modular oferece:
- **Coesão do domínio**: Appointment pertence a Booking, que está no mesmo processo
- **Transações ACID**: Nenhum evento eventualmente consistente para fluxos críticos (pagamento → comissão)
- **Deploy único**: Uma Edge Function ou um projeto Flutter, não 10
- **Refatoração segura**: Módulos são separados por pacotes Dart, não por containers

### Estrutura de Módulos

```
modules/
├── identity/          ──  Auth, Users, Roles, Tenant
├── booking/           ──  Appointments, Schedule, Availability
├── beauty/            ──  Services, Professionals, Customers
├── financial/         ──  Payments, Commissions, Cash, Transactions
├── engagement/        ──  Loyalty, Notifications, Analytics
├── platform/          ──  Audit, FeatureFlags, Integrations, Settings
└── shared/            ──  Core entities, Utils, Contracts
```

### Regras entre Módulos

```
identical ──→ booking ──→ financial
    │           │
    └─── beauty │
                │
                └── engagement ──→ platform

Regras:
- Módulos no mesmo nível não dependem entre si (comunicação via eventos)
- shared é o único módulo com zero dependências
- financial depende de booking (appointment_id)
- engagement depende de booking e beauty
- platform é consumido por todos
```

### Quando sair do Monolith

| Gatilho | Ação |
|---|---|
| Time > 8 engenheiros | Extrair financial como serviço |
| > 50k appointments/dia | Extrair booking como serviço |
| Necessidade de stacks diferentes | Extrair módulo específico |
| Latência crítica isolada | Extrair rota crítica |

---

## 3. ADRs — Architecture Decision Records

Decisões oficiais de arquitetura para o Studio Letícia Experience.

| ADR | Título | Status |
|---|---|---|
| SL-ADR-001 | Flutter como plataforma principal | Approved |
| SL-ADR-002 | Supabase como backend foundation | Approved |
| SL-ADR-003 | Multi-tenancy desde o início | Approved |
| SL-ADR-004 | Provider Pattern para integrações externas | Approved |

### SL-ADR-001: Flutter como Plataforma Principal

**Contexto**: Studio Letícia precisa atender dona (mobile), profissional (mobile) e cliente (mobile + web). Precisa de animações fluidas, experiência premium, e escala para Android + iOS.

**Decisão**: Flutter para todos os clientes (app mobile + admin web).

**Consequências**:
- ✅ Código compartilhado entre Customer App, Professional App e Admin Web
- ✅ Animações de 60fps nativas (essencial para experiência premium)
- ✅ Hot reload para desenvolvimento rápido
- ❌ Web não é SEO-friendly (página pública do salão será HTML separado ou Flutter com SEO routes)
- ❌ Bundle size maior que nativo (~15-20mb)

### SL-ADR-002: Supabase como Backend Foundation

**Contexto**: Precisa-se de autenticação, banco de dados, storage, realtime e funções serverless. Time pequeno, velocidade é prioridade.

**Decisão**: Supabase como plataforma de backend única.

**Consequências**:
- ✅ PostgreSQL real com RLS, migrations e PITR
- ✅ Auth built-in (Google, Email, Magic Link)
- ✅ Realtime para notificações push/live
- ✅ Storage para fotos do salão
- ✅ Edge Functions (Deno) para lógica serverless
- ❌ Vendor lock-in (mitigação: SQL padrão, abstração de provedores)
- ❌ Edge Functions tem cold start (~500ms)

### SL-ADR-003: Multi-tenancy Desde o Início

**Contexto**: PRD define evolução para Beauty Platform com múltiplos salões. Refatorar depois é caro.

**Decisão**: Toda tabela com `tenant_id UUID NOT NULL`, RLS obrigatório, `tenant_id` no JWT.

**Consequências**:
- ✅ Zero retrabalho quando segundo salão entrar
- ✅ Isolamento por RLS (segurança em nível de banco)
- ✅ Performance aceitável (índice composto em (tenant_id, id))
- ❌ Overhead pequeno em queries (WHERE tenant_id = ?)
- ❌ Backup restaura todos os tenants (mitigação: schema separado por tenant se necessário no futuro)

### SL-ADR-004: Provider Pattern para Integrações Externas

**Contexto**: Pagamentos, notificações e IA precisam de integrações com terceiros. O domínio não pode depender de provedores específicos.

**Decisão**: Toda integração externa segue o Provider Pattern definido no CONTRACTS layer.

**Consequências**:
- ✅ Trocar Mercado Pago por Stripe = 1 nova implementação, zero mudança no domínio
- ✅ Mocks para testes sem chamar APIs externas
- ✅ Cada implementação pode ter estratégia própria de erro/retry/circuit-breaker
- ❌ Camada extra de abstração (custo inicial baixo, benefício alto)

---

## 4. Domínio Principal

### 4.1 Mapa de Agregados

```
Tenant ──1:N── User
  │
  ├──1:N── Professional ──1:N── WorkDay
  │             │
  │             └──1:N── CommissionEntry
  │
  ├──1:N── Customer ──1:1── LoyaltyAccount
  │
  ├──1:N── Service ──N:1── ServiceCategory
  │
  ├──1:N── Appointment
  │           ├──N:1── Customer
  │           ├──N:1── Professional
  │           ├──N:1── Service (via items)
  │           └──1:N── AppointmentHistory
  │
  ├──1:N── Payment ──N:1── Appointment
  │
  ├──1:N── FinancialTransaction
  │
  ├──1:N── CashRegister
  │
  └──1:N── AuditLog
```

### 4.2 Appointment Lifecycle

```
                    ┌──────────┐
                    │requested │  (agendamento online, pendente confirmação)
                    └────┬─────┘
                         │
                    ┌────▼─────┐
                    │ scheduled│  (confirmado pelo salão)
                    └────┬─────┘
                         │
              ┌──────────┼──────────┐
              ▼          ▼          ▼
        ┌─────────┐ ┌─────────┐ ┌──────────┐
        │confirmed│ │cancelled│ │rescheduled│
        └────┬────┘ └─────────┘ └──────────┘
             │
        ┌────▼─────┐
        │in_progress│  (profissional iniciou)
        └────┬─────┘
             │
        ┌────▼─────┐
        │completed │  (serviço concluído)
        └────┬─────┘
             │
        ┌────▼─────┐
        │   paid   │  → commission_generated
        └──────────┘
```

### 4.3 Eventos de Domínio

| Evento | Publisher | Trigger | Subscribers |
|---|---|---|---|
| `appointment.requested` | booking | Cliente agenda online | Notifications → lembrete |
| `appointment.scheduled` | booking | Salão confirma | Notifications → push |
| `appointment.confirmed` | booking | Cliente confirma 24h antes | Scheduling → bloqueia horário |
| `appointment.in_progress` | booking | Profissional inicia serviço | Analytics → tempo médio |
| `appointment.completed` | booking | Profissional conclui | Financial → comissão, Loyalty → pontos |
| `appointment.cancelled` | booking | Cancelamento | Financial → estorno se pago |
| `payment.approved` | financial | Gateway confirma pagamento | Notifications → recibo, Appointment → paid |
| `commission.calculated` | financial | Appointment completed + paid | Professional → saldo |
| `commission.paid` | financial | Dono libera comissão | Financial → despesa |

---

## 5. Banco de Dados

### 5.1 Schema Design

```sql
-- Todas as tabelas seguem o padrão:
--   id UUID PRIMARY KEY DEFAULT gen_random_uuid()
--   tenant_id UUID NOT NULL REFERENCES tenants(id)
--   created_at TIMESTAMPTZ NOT NULL DEFAULT now()
--   updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
```

### 5.2 Índices Essenciais

```sql
-- Índices obrigatórios para performance
CREATE INDEX idx_appointments_tenant_date ON appointments(tenant_id, start_at);
CREATE INDEX idx_appointments_professional_date ON appointments(professional_id, start_at);
CREATE INDEX idx_appointments_customer ON appointments(customer_id);
CREATE INDEX idx_appointments_status ON appointments(tenant_id, status);
CREATE INDEX idx_customers_tenant_phone ON customers(tenant_id, phone);
CREATE INDEX idx_payments_appointment ON payments(appointment_id);
CREATE INDEX idx_commissions_professional ON commission_entries(professional_id, status);
CREATE INDEX idx_transactions_tenant_date ON financial_transactions(tenant_id, created_at);
CREATE INDEX idx_audit_logs_tenant ON audit_logs(tenant_id, created_at DESC);
```

### 5.3 RLS Policies (Padrão)

```sql
-- Toda tabela segue este padrão:
CREATE POLICY tenant_isolation_{table} ON {table}
  FOR ALL USING (tenant_id = get_user_tenant_id());

-- Helper function
CREATE OR REPLACE FUNCTION get_user_tenant_id()
RETURNS UUID
LANGUAGE sql STABLE
AS $$
  SELECT COALESCE(
    (current_setting('request.jwt.claims', true)::json->>'tenant_id')::uuid,
    (current_setting('request.jwt.claims', true)::json->'app_metadata'->>'tenant_id')::uuid
  );
$$;
```

### 5.4 Trigger: Auto tenant_id

```sql
CREATE OR REPLACE FUNCTION set_tenant_id()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  NEW.tenant_id := get_user_tenant_id();
  RETURN NEW;
END;
$$;

-- Aplicar em todas as tabelas business
CREATE TRIGGER set_tenant_id_before_insert
  BEFORE INSERT ON appointments
  FOR EACH ROW EXECUTE FUNCTION set_tenant_id();
```

### 5.5 Trigger: Auto updated_at

```sql
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER set_updated_at_appointments
  BEFORE UPDATE ON appointments
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
```

---

## 6. Contratos (Provider Pattern)

### 6.1 PaymentProvider

```dart
abstract class PaymentProvider {
  Future<PaymentResult> process(PaymentRequest request);
  Future<PaymentResult> refund(String paymentId);
  Future<PaymentStatus> getStatus(String paymentId);
}
```

Implementações:
- `MercadoPagoPaymentProvider` (MVP — PIX + Cartão)
- StripePaymentProvider (futuro)

### 6.2 NotificationProvider

```dart
abstract class NotificationProvider {
  Future<bool> send(Notification notification);
  Future<DeliveryStatus> getStatus(String notificationId);
}
```

Implementações:
- `FCMPushProvider` (Android + iOS)
- `EmailProvider` (Resend/SendGrid)
- `WhatsAppProvider` (Weni/ZAP)

### 6.3 AIProvider

```dart
abstract class AIProvider {
  Future<String> chat(List<Message> messages);
  Future<List<Recommendation>> recommend(String customerId);
  Future<AvailabilityPrediction> predictNoShow(Appointment appointment);
}
```

Implementações:
- `OpenAIProvider` (MVP)
- GeminiProvider (futuro)

---

## 7. Feature Flags (MVP)

| Flag | Key | Default | Descrição |
|---|---|---|---|
| Agendamento online | `online_booking` | ON | Link público de agendamento |
| Pagamento online | `payment_online` | OFF | Pagamento dentro do app |
| Fidelidade | `loyalty_program` | OFF | Programa de pontos |
| Lembrete WhatsApp | `whatsapp_reminder` | OFF | Notificação via WhatsApp |
| Galeria pública | `gallery_public` | ON | Fotos visíveis no link |
| Assistente IA | `ai_assistant` | OFF | Chatbot inteligente |
| Multi-tenancy | `multi_tenant` | OFF | Habilitar novos tenants |

---

## 8. Segurança

### 8.1 Stack

```
[Supabase Auth] ──JWT──► [PostgreSQL RLS]
      │                        │
      │                   [Row-Level Security]
      │                        │
      │              ┌─────────┴─────────┐
      │              ▼                   ▼
      │         [Business Tables]   [Audit Logs]
      │              │                   │
      │              └─────────┬─────────┘
      │                        ▼
      │                  [LGPD Layer]
      │              (consent + soft delete)
```

### 8.2 Hierarquia de Acesso

| Level | Role | Acesso |
|---|---|---|
| 1 | Customer | Próprios dados, agendar, histórico |
| 2 | Customer VIP | Mesmo + benefícios fidelidade |
| 3 | Professional | Agenda do dia, clientes do dia, comissão |
| 4 | Senior Professional | Agenda + clientes + métricas |
| 5 | Manager | Operações do dia, finanças |
| 6 | Admin (owner) | Tudo do tenant |
| 9 | System Owner | Infra, billing, super admin |

### 8.3 RLS por Módulo

```sql
-- Identity: usuário vê próprio perfil + dados do tenant
CREATE POLICY users_self ON users
  FOR ALL USING (id = auth.uid());

-- Booking: professional vê appointments do dia; customer vê próprios
CREATE POLICY appointments_professional ON appointments
  FOR SELECT USING (professional_id = get_user_professional_id());
CREATE POLICY appointments_customer ON appointments
  FOR SELECT USING (customer_id = get_user_customer_id());

-- Financial: apenas level >= 5 (Manager+)
CREATE POLICY financial_manager ON financial_transactions
  FOR ALL USING (
    get_user_role_level() >= 5
    AND tenant_id = get_user_tenant_id()
  );
```

### 8.4 LGPD

- Consentimento registrado com versão dos termos + timestamp
- Soft delete de customer: `deleted_at TIMESTAMPTZ`
- Anonimização após 90 dias (nome → uuid hash, email → [removed])
- Exportação: `GET /api/customers/{id}/export` → JSON completo
- DPO: admin@futurecod.com.br

---

## 9. Observabilidade

### 9.1 Monitoring Stack

| Ferramenta | Uso |
|---|---|
| Sentry | Erros em produção (Flutter + Edge Functions) |
| PostHog | Eventos de produto, funis, retention, dashboards |
| Supabase Logs | Logs de banco, edge functions, auth |
| GitHub Actions | CI/CD, quality gates |

### 9.2 Eventos de Produto (PostHog)

| Evento | Propriedades |
|---|---|
| `appointment_booked` | service_id, professional_id, source |
| `appointment_completed` | appointment_id, duration_min, amount |
| `payment_made` | method, amount, installments |
| `professional_logged_in` | professional_id, day_of_week |
| `customer_created` | source |
| `cash_register_closed` | total, expected, difference |

---

## 10. Deploy & CI/CD

### 10.1 Estrutura

```
studio-leticia/
├── apps/
│   ├── customer_app/      # Flutter app (customer)
│   ├── pro_app/           # Flutter app (professional)
│   └── admin_web/         # Flutter web (owner)
├── packages/
│   ├── shared/            # Core entities, utils
│   ├── identity/          # Auth module
│   ├── booking/           # Scheduling module
│   ├── beauty/            # Services, professionals, customers
│   ├── financial/         # Payments, commissions
│   └── engagement/        # Loyalty, notifications
├── supabase/
│   ├── migrations/        # Database migrations
│   ├── functions/         # Edge Functions
│   └── seed/              # Seed data
├── .github/
│   └── workflows/         # CI/CD pipelines
└── docs/                  # Product documentation
```

### 10.2 Pipeline

```
[Push] → [Lint + Test] → [Build Flutter] → [Deploy Edge Functions]
    │           │               │                    │
    ▼           ▼               ▼                    ▼
[PR Review]  [Quality Gate]  [Vercel (web)]     [Supabase]
                             [App Center (mobile)]
```

---

## 11. Diagrama de Componentes (Pacotes Dart)

```
pubspec.yaml (monorepo)
├── shared/           # core: entidades, value objects, contracts
├── identity/         # auth, users, roles, tenant
│   └── depends on: shared
├── booking/          # appointments, schedule
│   └── depends on: shared, identity
├── beauty/           # services, professionals, customers
│   └── depends on: shared, identity
├── financial/        # payments, commissions, transactions
│   └── depends on: shared, booking
├── engagement/       # loyalty, notifications
│   └── depends on: shared, booking, beauty
├── customer_app/     # Pages + Providers do app cliente
│   └── depends on: todos os módulos
├── pro_app/          # Pages + Providers do app profissional
│   └── depends on: todos os módulos
└── admin_web/        # Pages + Providers do admin
    └── depends on: todos os módulos
```

---

## 12. Decisões Técnicas Futuras

| Decisão | Quando |
|---|---|
| Extrair financial como microserviço | > 50k transações/dia |
| Adicionar cache Redis | > 100k appointments/dia |
| Migrar para filas (RabbitMQ/PubSub) | Quando eventos causarem timeout |
| Suporte offline total | Quando cliente demandar |
| PWA vs Flutter Web | Testar performance web |
| Componentes compartilhados entre produtos (Design System) | Quando 2º produto FUTURECOD iniciar |

---

## Approval

| Role | Name | Date |
|---|---|---|
| Chief Architect | Eddie | |
| Product Owner | Raffa | |
| Tech Lead | | |

---

**ARCHITECTURE v1.0 — Studio Letícia Experience**
*Framework: BBOP v1.0 | Plataforma: FUTURECOD DPES*
