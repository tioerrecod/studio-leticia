---
id: sl-domain-model
title: "Studio Letícia Experience — Domain Model v1.0"
version: "1.0.0"
status: "architecture"
owner: "Chief Architect"
depends_on: ["sl-architecture", "sl-prd", "bbop-domain-model"]
used_by: ["sl-database"]
last_review: "2026-07-13"
next_review: "2026-10-13"
---

# DOMAIN MODEL — Studio Letícia Experience v1.0

**Baseado em**: BBOP Domain Model v1.0 + PRD v1.0 + ARCHITECTURE v1.0
**Propósito**: Definir agregados, entidades, value objects, eventos e invariantes específicos do Studio Letícia, herdando do BBOP todo o domínio de beleza genérico.

---

## 1. Relação com BBOP Domain Model

O BBOP Domain Model define o domínio de beleza genérico (salões, clínicas, spas, barbearias). O Studio Letícia **herda** e **refina** esse modelo:

| Aspecto | BBOP | Studio Letícia |
|---|---|---|
| Entidades | Define todas (Customer, Appointment, Professional, etc.) | Usa as mesmas, com campos adicionais |
| Appointment states | 8 estados | Adiciona `ARRIVED` |
| Loyalty | Saldo de pontos simples | Points Ledger event-sourced |
| Financial | Transação genérica | Revenue + Commission + Expense + Refund tipados |
| Customer Intelligence | Não define | LTV, churn prediction, preferências |
| Analytics | Eventos de domínio | `product_events` para PostHog + IA |

**Regra**: Tudo que não está explicitamente refinado aqui segue o BBOP Domain Model como definido.

---

## 2. Agregados de Domínio

### 2.1 Tenant (Core Business)

```
Tenant (Aggregate Root)
├── tenant_id: UUID
├── name: String                    "Studio Letícia"
├── slug: String                    "studio-leticia"
├── logo_url: URL
├── theme: TenantTheme (Value Object)
│   ├── primary_color: Color        #D81B60
│   ├── secondary_color: Color      #FFB300
│   ├── background_color: Color     #F5F0EB
│   ├── font_heading: String        "Playfair Display"
│   ├── font_body: String           "Inter"
│   └── logo_url: URL
├── plan: Plan                      starter | professional | enterprise
├── domain: String                  "studio-leticia.futurecod.com.br"
├── settings: TenantSettings (Value Object)
│   ├── week_start: DayOfWeek
│   ├── business_hours: Map<DayOfWeek, TimeRange>
│   ├── timezone: String            "America/Sao_Paulo"
│   ├── cancellation_policy: String "free_4h"
│   └── default_commission_pct: Decimal 50.0
├── status: TenantStatus            active | suspended | trial | cancelled
├── features: FeatureFlag[]         (Value Object list)
├── created_at: Timestamp
└── updated_at: Timestamp

Invariantes:
- slug é único globalmente
- status só muda de trial → active se pagamento confirmado
- cancellation_policy é imutável após primeiro appointment
```

### 2.2 User (Identity)

```
User (Aggregate Root)
├── user_id: UUID
├── tenant_id: UUID
├── auth_user_id: UUID              (Supabase Auth)
├── email: Email                    (Value Object — valida formato)
├── phone: PhoneNumber              (Value Object — valida DDD + número)
├── name: String
├── avatar_url: URL
├── role: Role                      owner | manager | professional | customer
├── role_level: Integer             6 | 5 | 3 | 1
├── is_active: Boolean
├── locale: String                  "pt-BR"
├── mfa_enabled: Boolean
├── last_login_at: Timestamp
├── metadata: JSONB
├── created_at: Timestamp
└── updated_at: Timestamp

Invariantes:
- Um email só pode ter um user ativo por tenant
- role_level determina acesso (hierarquia: 1=cliente, 9=system)
- is_active=false bloqueia login imediatamente
```

### 2.3 Professional (Beauty — refinamento BBOP)

```
Professional (Aggregate Root)
├── professional_id: UUID
├── tenant_id: UUID
├── user_id: UUID                   nullable (professional pode não ter user)
├── name: String
├── bio: Text
├── photo_url: URL
├── specialties: Specialty[]        (Value Object)
│   ├── service_id: UUID
│   └── service_name: String        "Corte", "Mechas"
├── commission_rules: CommissionRule[] (Value Object)
│   ├── type: RuleType              default | per_service | per_category
│   ├── service_id: UUID            nullable
│   ├── category_id: UUID           nullable
│   ├── percentage: Decimal         50.0
│   └── fixed_value: Decimal        nullable
├── schedule: WorkDay[]             (Value Object)
│   ├── day_of_week: Integer        0-6
│   ├── start_time: Time
│   ├── end_time: Time
│   ├── break_start: Time           nullable
│   └── break_end: Time             nullable
├── is_active: Boolean
├── rating_avg: Decimal
├── rating_count: Integer
├── total_revenue: Decimal          (denormalized para dashboard)
├── total_appointments: Integer
├── created_at: Timestamp
└── updated_at: Timestamp

Invariantes:
- CommissionRule default é obrigatória
- Per_service override prevalece sobre per_category, que prevalece sobre default
- schedule não pode ter dias sobrepostos
- Professional só pode receber comissão por serviços que tem em specialties
- Comissão total por serviço não pode exceder 100% do valor
```

### 2.4 Customer (Beauty — refinamento BBOP)

```
Customer (Aggregate Root)
├── customer_id: UUID
├── tenant_id: UUID
├── user_id: UUID                   nullable (pode não ter app)
├── name: String
├── email: Email                    nullable
├── phone: PhoneNumber
├── birth_date: Date
├── gender: String                  nullable
├── photo_url: URL                  nullable
├── notes: Text
├── tags: String[]                  ["vip", "indicou_amigo", "aniversariante_mes"]
├── preferences: CustomerPreference[] (Value Object)
│   ├── preferred_professional_id: UUID  nullable
│   ├── preferred_services: UUID[]
│   ├── notes_on_services: Text
│   └── communication_channel: Channel  whatsapp | push | email
├── source: CustomerSource          whatsapp | app | walkin | indication | instagram
├── indication_by: UUID             (customer_id que indicou) nullable
├── total_visits: Integer
├── total_spent: Decimal
├── last_visit_at: Timestamp
├── ltv: Decimal                    (Lifetime Value — calculado)
├── churn_score: Decimal            (0.0 a 1.0 — calculado por IA futura)
├── consent: Consent (Value Object)
│   ├── terms_version: String       "v1.0"
│   ├── marketing_opt_in: Boolean
│   ├── whatsapp_opt_in: Boolean
│   ├── consented_at: Timestamp
│   └── revoked_at: Timestamp       nullable
├── deleted_at: Timestamp           nullable (soft delete — LGPD)
├── created_at: Timestamp
└── updated_at: Timestamp

Invariantes:
- Customer com deleted_at não pode fazer agendamentos
- Se customer tem user_id, user não pode ser deletado sem anonimizar customer
- phone é único por tenant (dois customers não podem ter mesmo telefone ativo)
- ltv é campo calculado (job noturno atualiza)
```

### 2.5 Appointment (Booking — motor do produto)

```
Appointment (Aggregate Root)
├── appointment_id: UUID
├── tenant_id: UUID
├── customer_id: UUID
├── professional_id: UUID
├── services: ServiceItem[] (Value Object)
│   ├── service_id: UUID
│   ├── name: String
│   ├── duration: Integer           minutos
│   ├── price: Decimal
│   └── commission_pct: Decimal
├── start_at: Timestamp
├── end_at: Timestamp               (start_at + sum(services.duration))
├── status: AppointmentStatus
│   requested | scheduled | confirmed | arrived |
│   in_progress | completed | paid |
│   cancelled | no_show | rescheduled
├── arrived_at: Timestamp           nullable
├── total_amount: Decimal
├── commission_amount: Decimal
├── source: AppointmentSource        app_online | app_admin | whatsapp | walkin
├── cancellation: CancellationInfo  (Value Object) nullable
│   ├── cancelled_at: Timestamp
│   ├── reason: CancellationReason  customer | professional | no_show | system
│   ├── cancelled_by: UUID
│   └── fee_charged: Boolean
├── reschedule_count: Integer
├── reschedule_from: UUID           (appointment_id original) nullable
├── reminders: AppointmentReminder[] (Entity)
│   ├── reminder_id: UUID
│   ├── type: ReminderType          24h | 1h | confirmation
│   ├── channel: Channel            push | whatsapp | email
│   ├── sent_at: Timestamp
│   ├── confirmed: Boolean
│   └── response_at: Timestamp      nullable
├── history: AppointmentHistory[]   (Entity — mudanças de estado)
│   ├── history_id: UUID
│   ├── previous_status: AppointmentStatus
│   ├── new_status: AppointmentStatus
│   ├── changed_by: UUID
│   ├── reason: Text                nullable
│   └── created_at: Timestamp
├── metadata: JSONB
├── created_at: Timestamp
└── updated_at: Timestamp

Invariantes:
- Professional não pode ter 2 appointments no mesmo horário (overlap check)
- Appointment só cria se professional tem WorkDay no dia/horário
- status transições são restritas:
    requested → scheduled | cancelled
    scheduled → confirmed | cancelled
    confirmed → arrived | cancelled | rescheduled
    arrived → in_progress | cancelled | no_show
    in_progress → completed
    completed → paid
    rescheduled → scheduled (novo appointment referência o original)
    cancelled → terminal
    no_show → terminal
    paid → terminal
- Customer bloqueado (deleted_at != null) não pode criar appointment
- appointment só muda para paid se payment.status = approved
```

### 2.6 Financial Transaction (Financial — refinamento BBOP)

```
FinancialTransaction (Aggregate Root)
├── transaction_id: UUID
├── tenant_id: UUID
├── type: TransactionType
│   revenue | commission | expense | refund
├── category: TransactionCategory
│   └── revenue → appointment | product | extra
│   └── commission → professional_fee
│   └── expense → rent | supplies | salary | marketing | other
│   └── refund → cancellation | chargeback
├── amount: Decimal
├── description: Text
├── reference_id: UUID              appointment_id / expense_id / etc.
├── reference_type: String          "appointment" | "expense" | "refund"
├── payment_method: PaymentMethod   credit_card | debit_card | pix | cash | ticket
├── payment_provider: String        "mercado_pago" | null para cash
├── gateway_transaction_id: String  nullable
├── status: TransactionStatus       pending | completed | failed | refunded
├── reconciled: Boolean
├── reconciled_at: Timestamp        nullable
├── metadata: JSONB
├── created_at: Timestamp
└── updated_at: Timestamp

Invariantes:
- Toda revenue deve ter um appointment_id (exceto product sale)
- Toda commission deve referenciar um appointment_id + professional_id
- amount deve ser > 0 (sinal está no type)
- refund só pode existir se transaction original existe e está completed
- Uma transaction não pode ser refundada duas vezes
```

### 2.7 Cash Register (Financial)

```
CashRegister (Aggregate Root)
├── register_id: UUID
├── tenant_id: UUID
├── opened_by: UUID                 (user_id)
├── closed_by: UUID                 nullable (user_id)
├── opened_at: Timestamp
├── closed_at: Timestamp            nullable
├── initial_balance: Decimal
├── expected_balance: Decimal       (initial + revenue - expenses)
├── actual_balance: Decimal         (valor real em caixa)
├── difference: Decimal             (actual - expected)
├── difference_reason: Text         nullable
├── status: RegisterStatus          open | closed | reconciled
├── transactions: UUID[]            (financial_transaction_ids)
├── notes: Text
├── created_at: Timestamp
└── updated_at: Timestamp
```

### 2.8 Payment (Financial)

```
Payment (Entity — pertence a Appointment)
├── payment_id: UUID
├── tenant_id: UUID
├── appointment_id: UUID
├── customer_id: UUID
├── method: PaymentMethod           credit_card | debit_card | pix | cash | ticket
├── amount: Decimal
├── installments: Integer           (1 para PIX/cash, 1-12 para cartão)
├── gateway: String                 "mercado_pago"
├── gateway_payment_id: String
├── gateway_status: String          "approved" | "pending" | "rejected"
├── status: PaymentStatus           pending | approved | refunded | declined
├── paid_at: Timestamp              nullable
├── refunded_at: Timestamp          nullable
├── metadata: JSONB
├── created_at: Timestamp
└── updated_at: Timestamp
```

### 2.9 Loyalty Account (Engagement — refinamento BBOP)

```
LoyaltyAccount (Aggregate Root)
├── account_id: UUID
├── tenant_id: UUID
├── customer_id: UUID               (1:1 com Customer)
├── tier: LoyaltyTier               bronze | silver | gold | platinum
├── current_points: Integer         (saldo atual — denormalized)
├── lifetime_points: Integer        (total ganho — denormalized)
├── tier_updated_at: Timestamp
├── created_at: Timestamp
└── updated_at: Timestamp
```

### 2.10 Points Ledger (Loyalty — event-sourced)

```
PointsEntry (Entity — event-sourced)
├── entry_id: UUID
├── account_id: UUID                FK → loyalty_account
├── type: PointsEntryType           earned | redeemed | expired | adjusted
├── amount: Integer                 (+ para earned, - para redeemed/expired)
├── balance_after: Integer          (saldo após esta entry)
├── reference_id: UUID              appointment_id / product_id
├── reference_type: String          "appointment" | "reward" | "indication"
├── description: String             "Corte realizado - +100 pts"
├── expires_at: Date                nullable (pontos expiram em 12 meses)
├── redeemed_at: Date               nullable (quando foi resgatado)
├── created_at: Timestamp

Invariantes:
- account.current_points = SUM(amount) de todas as entries não expiradas
- Pontos expirados geram entry automática (type=expired, amount negativo)
- Um appointment só gera pontos se status = paid
- Resgate só pode ocorrer se current_points >= amount
- Nenhuma entry pode ser deletada ou alterada (imutável — event-sourced)
```

### 2.11 Product Event (Analytics — PLATFORM schema)

```
ProductEvent (Entity — tabela da PLATFORM)
├── event_id: UUID
├── tenant_id: UUID
├── event_type: String              "appointment_created" | "appointment_completed" |
│                                   "payment_approved" | "customer_opened_app" |
│                                   "professional_logged_in" | "appointment_no_show"
├── source: String                  "customer_app" | "pro_app" | "admin_web" | "edge_function"
├── properties: JSONB
│   Ex: {"appointment_id": "...", "amount": 80.00, "service_name": "Corte"}
├── user_id: UUID                   nullable
├── anonymous_id: String            nullable (para usuários não logados)
├── session_id: UUID
├── created_at: Timestamp

Invariantes:
- Tabela INSERT-only (imutável — dados para analytics)
- event_type segue padrão LANGUAGE: {dominio}.{entidade}.{ação}
- Retenção: 24 meses (LGPD: anonimizar após)
```

---

## 3. Appointment Lifecycle (com ARRIVED)

```
                    ┌──────────┐
                    │ requested│  Cliente agendou online
                    └────┬─────┘
                         │
                    ┌────▼─────┐
              ┌─────│ scheduled│←──── Salão confirmou (ou auto-confirmado)
              │     └────┬─────┘
              │          │
         ┌────▼───┐ ┌────▼─────┐ ┌─────────────┐
         │cancelled│ │confirmed │ │ rescheduled  │
         └────────┘ └────┬─────┘ └──────┬──────┘
                         │              │
                    ┌────▼─────┐        │
                    │ arrived  │←── Cliente chegou ao salão
                    └────┬─────┘        │
                         │              │
                    ┌────▼─────┐        │
                    │in_progress│       │  (profissional iniciou)
                    └────┬─────┘       │
                         │              │
                    ┌────▼─────┐        │
                    │completed │       │
                    └────┬─────┘       │
                         │              │
                    ┌────▼─────┐        │
                    │   paid   │        │  → commission_generated, points_earned
                    └──────────┘        │
                                        │
                    ┌──────────┐        │
                    │ no_show  │←───────┘
                    └──────────┘
```

**Regras de transição**:
| De | Para | Gatilho |
|---|---|---|
| requested | scheduled | Confirmação do salão (manual ou auto) |
| requested | cancelled | Cliente cancela antes da confirmação |
| scheduled | confirmed | Cliente confirma 24h antes (ou automático) |
| scheduled | rescheduled | Cliente pede remarcação |
| confirmed | arrived | Cliente chega ao salão (QR code ou profissional marca) |
| confirmed | cancelled | Cancelamento (gratuito até 4h antes) |
| confirmed | rescheduled | Remarcação (1x grátis) |
| arrived | in_progress | Profissional toca "Iniciar" |
| arrived | no_show | Cliente não comparece (marcado pelo sistema após 15min) |
| arrived | cancelled | Cancelamento presencial |
| in_progress | completed | Profissional toca "Concluir" |
| completed | paid | Pagamento confirmado |

**ARRIVED** é novo estado que gera métricas essenciais:
- `arrived_at - start_at` → atraso do cliente (mins)
- `in_progress_at - arrived_at` → tempo esperando (mins)
- `completed_at - in_progress_at` → duração real do serviço (mins)

---

## 4. Eventos de Domínio

| Evento | Publisher | Trigger | Payload |
|---|---|---|---|
| `appointment.requested` | booking | Cliente agenda online | appointment_id, customer_id, start_at |
| `appointment.scheduled` | booking | Salão confirma | appointment_id, professional_id |
| `appointment.confirmed` | booking | Cliente confirma | appointment_id |
| `appointment.arrived` | booking | Cliente chega ao salão | appointment_id, arrived_at, delay_min |
| `appointment.in_progress` | booking | Profissional inicia | appointment_id, started_at |
| `appointment.completed` | booking | Profissional conclui | appointment_id, duration_min, amount |
| `appointment.cancelled` | booking | Cancelamento | appointment_id, reason, cancelled_by |
| `appointment.no_show` | booking | Cliente não comparece | appointment_id, professional_id |
| `appointment.rescheduled` | booking | Remarcação | appointment_id, new_start_at |
| `payment.approved` | financial | Gateway confirma | payment_id, amount, method |
| `payment.refunded` | financial | Estorno processado | payment_id, amount, reason |
| `commission.calculated` | financial | Appointment paid | professional_id, amount, appointment_id |
| `commission.paid` | financial | Dono libera | entry_id, amount |
| `customer.created` | beauty | Novo cadastro | customer_id, source |
| `customer.loyalty_earned` | loyalty | Pontos creditados | customer_id, points, total |
| `customer.loyalty_redeemed` | loyalty | Pontos resgatados | customer_id, points, reward |

---

## 5. Regras de Negócio (Invariantes)

### Agendamento
| ID | Regra |
|---|---|
| BR-001 | Professional não pode ter 2 appointments com overlapping de horário |
| BR-002 | Appointment só pode ser criado se horário está dentro do WorkDay do professional |
| BR-003 | Cliente com deleted_at != null não pode criar appointment |
| BR-004 | Cancelamento gratuito até 4h antes do horário |
| BR-005 | Cancelamento após 4h: taxa de 50% do valor |
| BR-006 | Cliente pode remarcar 1x grátis por appointment |
| BR-007 | No-show após 15min do horário agendado (marcado pelo sistema) |
| BR-008 | Só pode ter 1 appointment ARRIVED por customer por vez |

### Comissão
| ID | Regra |
|---|---|
| BR-010 | CommissionRule default (50%) é obrigatória para todo professional |
| BR-011 | Regra per_service prevalece sobre per_category, que prevalece sobre default |
| BR-012 | Comissão é calculada no momento da conclusão (status → completed) |
| BR-013 | Comissão só é liberada para saque quando payment.status = approved |
| BR-014 | Soma de comissões por appointment não pode exceder 100% do valor |

### Financeiro
| ID | Regra |
|---|---|
| BR-020 | Payment só pode ser processado se appointment.status = in_progress ou completed |
| BR-021 | Pagamento em dinheiro pode ser registrado sem gateway |
| BR-022 | CashRegister deve ser fechado ao final do expediente |
| BR-023 | Diferença > R$ 10 no fechamento requer justificativa |
| BR-024 | Refund só pode existir se transaction original está completed |
| BR-025 | Uma transaction não pode ser refundada duas vezes |

### Fidelidade
| ID | Regra |
|---|---|
| BR-030 | 1 ponto por R$ 1 gasto (arredondado para baixo) |
| BR-031 | 100 pontos = R$ 10 de desconto |
| BR-032 | Pontos expiram em 12 meses da data de aquisição |
| BR-033 | Pontos só são creditados quando appointment.status = paid |
| BR-034 | Indicação de novo cliente = 50 pontos bônus (quando indicado fizer primeiro appointment) |
| BR-035 | Pontos expirados geram entry automática (imutável) |

---

## 6. Relacionamentos entre Agregados

```
Tenant ──1:N── User
  │
  ├──1:N── Professional ──1:N── WorkDay
  │             │
  │             └──1:N── CommissionEntry
  │             └──1:N── ProfessionalRating → Customer
  │
  ├──1:N── Customer ──1:1── LoyaltyAccount ──1:N── PointsEntry
  │             │
  │             └──1:N── AppointmentHistory
  │
  ├──1:N── Service ──N:1── ServiceCategory
  │
  ├──1:N── Appointment
  │           ├──N:1── Customer
  │           ├──N:1── Professional
  │           ├──N:1── Service (via ServiceItem VO)
  │           ├──1:N── AppointmentReminder
  │           └──1:N── AppointmentHistory
  │
  ├──1:N── Payment ──N:1── Appointment
  │
  ├──1:N── FinancialTransaction ──reference── Appointment
  │
  ├──1:N── CashRegister ──1:N── FinancialTransaction (via transaction_ids)
  │
  ├──1:N── AuditLog
  │
  └──1:N── ProductEvent
```

---

## 7. Value Objects

| Value Object | Propriedades | Usado por |
|---|---|---|
| `ServiceItem` | service_id, name, duration, price, commission_pct | Appointment |
| `WorkDay` | day_of_week, start_time, end_time, break_start, break_end | Professional |
| `CommissionRule` | type, service_id, category_id, percentage, fixed_value | Professional |
| `Specialty` | service_id, service_name | Professional |
| `CustomerPreference` | preferred_professional_id, preferred_services, notes, channel | Customer |
| `Consent` | terms_version, marketing_opt_in, whatsapp_opt_in, consented_at, revoked_at | Customer |
| `CancellationInfo` | cancelled_at, reason, cancelled_by, fee_charged | Appointment |
| `AppointmentReminder` | reminder_id, type, channel, sent_at, confirmed, response_at | Appointment |
| `AppointmentHistory` | history_id, previous_status, new_status, changed_by, reason, created_at | Appointment |
| `TenantTheme` | primary_color, secondary_color, background_color, font_heading, font_body, logo_url | Tenant |
| `TenantSettings` | week_start, business_hours, timezone, cancellation_policy, default_commission_pct | Tenant |
| `FeatureFlag` | key, name, description, is_enabled, enabled_for_roles | Tenant |
| `Email` | value (valida formato) | User |
| `PhoneNumber` | value (valida DDD + número) | User, Customer |
| `Address` | street, number, complement, neighborhood, city, state, zip_code, coordinates | Customer (futuro) |

---

## 8. Tipos (Enums)

| Enum | Valores |
|---|---|
| `AppointmentStatus` | requested, scheduled, confirmed, arrived, in_progress, completed, paid, cancelled, no_show, rescheduled |
| `AppointmentSource` | app_online, app_admin, whatsapp, walkin |
| `CancellationReason` | customer, professional, no_show, system |
| `ReminderType` | 24h, 1h, confirmation |
| `Channel` | push, whatsapp, email |
| `PaymentMethod` | credit_card, debit_card, pix, cash, ticket |
| `PaymentStatus` | pending, approved, refunded, declined |
| `TransactionType` | revenue, commission, expense, refund |
| `TransactionCategory` | revenue: appointment, product, extra; commission: professional_fee; expense: rent, supplies, salary, marketing, other; refund: cancellation, chargeback |
| `TransactionStatus` | pending, completed, failed, refunded |
| `RegisterStatus` | open, closed, reconciled |
| `LoyaltyTier` | bronze, silver, gold, platinum |
| `PointsEntryType` | earned, redeemed, expired, adjusted |
| `CustomerSource` | whatsapp, app, walkin, indication, instagram |
| `Role` | owner, manager, professional, customer |
| `TenantStatus` | active, suspended, trial, cancelled |
| `Plan` | starter, professional, enterprise |

---

## 9. Denormalized Fields (Performance)

Campos calculados mantidos nas tabelas para evitar queries pesadas em dashboards:

| Tabela | Campo | Cálculo | Atualização |
|---|---|---|---|
| `professional` | total_revenue | SUM(transaction.amount WHERE type=revenue AND professional_id) | Job noturno |
| `professional` | total_appointments | COUNT(appointment WHERE professional_id) | Job noturno |
| `customer` | total_visits | COUNT(appointment WHERE customer_id AND status=completed) | Job noturno |
| `customer` | total_spent | SUM(transaction.amount WHERE type=revenue AND customer_id) | Job noturno |
| `customer` | last_visit_at | MAX(appointment.start_at WHERE customer_id) | Trigger on appointment.completed |
| `customer` | ltv | total_spent / days_since_first_appointment * 365 | Job noturno |
| `customer` | churn_score | Função de recência, frequência, ticket médio | Job noturno via Edge Function + IA |
| `loyalty_account` | current_points | SUM(amount) de PointsEntry não expirados | Trigger on PointsEntry INSERT |

---

## 10. Segurança por Agregado

| Agregado | Quem lê | Quem escreve | RLS |
|---|---|---|---|
| Tenant | Admin+ (level >= 6) | System Owner (level 9) | tenant_id = user.tenant_id |
| User | Próprio + Admin+ | Admin+ (level >= 6) | user.id = auth.uid() OR level >= 6 |
| Professional | Todos do tenant | Admin+ (level >= 6) | tenant_id = get_tenant_id() |
| Customer | Todos do tenant | Professional+ (level >= 3) | tenant_id = get_tenant_id() |
| Appointment | Professional+ (level >= 3) + próprio customer | Professional+ (criar), customer (criar online) | Ver policies na ARCHITECTURE |
| FinancialTransaction | Manager+ (level >= 5) | Manager+ | level >= 5 |
| Payment | Manager+ | Edge Function (Mercado Pago webhook) | level >= 5 |
| LoyaltyAccount | Customer (próprio) + Professional+ | Sistema (automático) | customer_id = auth.customer_id OR level >= 3 |
| PointsEntry | Customer (próprio) + Admin+ | Sistema (automático) | customer_id = auth.customer_id OR level >= 6 |
| AuditLog | Admin+ (level >= 6) | Sistema (trigger) | level >= 6 |
| ProductEvent | Admin+ (level >= 6) + PostHog | Sistema (Edge Function) | level >= 6 |

---

## 11. Schema por Domínio (para DATABASE DESIGN)

```
Domínio Core:
  tenants
  tenant_features

Domínio Identity:
  users
  roles
  user_sessions

Domínio Beauty:
  professionals
  professional_work_days
  professional_commission_rules
  professional_specialties
  professional_ratings
  customers
  customer_preferences
  services
  service_categories
  service_addons

Domínio Booking:
  appointments
  appointment_services
  appointment_reminders
  appointment_history

Domínio Financial:
  payments
  financial_transactions
  commission_entries
  cash_registers
  expenses

Domínio Loyalty:
  loyalty_accounts
  points_ledger

Domínio Platform:
  audit_logs
  product_events
  feature_flags
  integrations
  system_settings
```

---

## 12. Relação com FUTURECOD Layers

| Layer | Como o Studio Letícia usa |
|---|---|
| PHILOSOPHY | Princípios: Documentation First, Clean Architecture, Multi-tenant |
| KNOWLEDGE | Pesquisa de mercado de beleza, benchmarking de concorrentes |
| DPES | Herda architecture, security, coding, quality, git, release |
| CAPABILITIES | Usa Customer, Appointment, Financial, Loyalty (definidas na FUTURECOD) |
| CONTRACTS | Implementa PaymentProvider, NotificationProvider, AIProvider |
| PLATFORM | Consume auth, payments, notifications, analytics, media, audit |
| BBOP FRAMEWORK | Especializa para beleza (profissionais, serviços, comissão) |
| STUDIO LETÍCIA | Produto concreto — este documento |

---

## Approval

| Role | Name | Date |
|---|---|---|
| Chief Architect | Eddie | |
| Product Owner | Raffa | |
| Tech Lead | | |

---

**DOMAIN MODEL v1.0 — Studio Letícia Experience**
*Framework: BBOP v1.0 | Plataforma: FUTURECOD DPES*
