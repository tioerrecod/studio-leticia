---
id: sl-prd
title: "Studio Letícia Experience — Product Requirement Document v1.0"
version: "1.0.0"
status: "prd"
owner: "Raffa"
depends_on: ["slbos", "bbop-capability-model", "bbop-domain-model"]
used_by: ["sl-architecture"]
last_review: "2026-07-13"
next_review: "2026-10-13"
---

# PRD — Studio Letícia Experience v1.0

**Versão**: 1.0.0
**Data**: 2026-07-13
**Autor**: Raffa (Product Owner)
**Baseado em**: BBOP Framework v1.0 — Capability Model v1.0 — SLBOS v2.0

---

## 1. Visão do Produto

Studio Letícia Experience é a plataforma de experiência digital que transforma salões de beleza independentes em **marcas premium**. Não é um "app de agenda" — é a vitrine digital, o hub de relacionamento e o sistema de gestão que um salão de alto padrão precisa para competir com grandes redes.

### Promessa
"Seu salão com experiência de marca premium."

### Diferencial
Enquanto concorrentes focam em funcionalidade, Studio Letícia foca em **experiência emocional** — cada interação (do agendamento ao pagamento) deve fazer o cliente sentir que está interagindo com uma marca de luxo.

### Categoria
Plataforma SaaS de gestão e experiência para salões de beleza independentes.
- **Não é** um ERP genérico
- **Não é** um agregador de agendamentos
- **É** o sistema operacional de marca própria do salão

### Concorrência
| Concorrente | Foco | Fragilidade |
|---|---|---|
| Versatilis | Gestão, feio | UX pobre, parece sistema dos anos 2000 |
| Meni | Agendamento apenas | Sem gestão de comissão, sem fidelidade |
| Appoint | Agenda online | B2C apenas, sem gestão interna |
| Reservio | Internacional | Não resolve realidade brasileira (comissão, PIX, fiado) |

### Oportunidade
Nenhum concorrente entrega: **agenda visual premium + comissão inteligente + fidelidade integrada + experiência de marca** — tudo em um produto com identidade de salão de beleza, não de software empresarial.

## 2. Objetivos

1. **Eliminar planilhas** do dia a dia do salão (agenda, comissão, financeiro)
2. **Reduzir no-show** para < 10% com lembretes inteligentes
3. **Aumentar retorno** de clientes com fidelidade e recomendação integradas
4. **Empoderar o profissional** com visibilidade de agenda e comissão em tempo real
5. **Construir base para multi-tenancy** — o primeiro salão de muitos

## 3. Personas (Refinamento SLBOS)

### Letícia (Dona)
- **Idade**: 30-50
- **Perfil**: Empreendedora, gerencia 3-15 profissionais, usa iPhone, Instagram e WhatsApp para divulgar o salão
- **Dores**: Planilha de comissão, cliente não confirma, não sabe se o dia vai ser bom financeiramente
- **Necessidades**: Ver o salão inteiro em 30 segundos, saber se faturou mais ou menos que ontem
- **Jornada**: Abre o app → snapshot do dia (agendados, realizados, faturamento, comissão pendente) → gerencia exceções

### Carla (Profissional)
- **Idade**: 22-40
- **Perfil**: Cabelereira, manicure, esteticista — usa WhatsApp o dia inteiro, não tem computador
- **Dores**: Não sabe quantos clientes tem hoje, esquece horário de almoço, comissão "some"
- **Necessidades**: Saber o dia em 10 segundos, registrar início/fim do serviço, ver quanto ganhou no dia
- **Jornada**: Chega → abre app → vê timeline do dia → toca "Iniciar" no primeiro serviço → toca "Concluir" → vê comissão acumulada

### Juliana (Cliente Final)
- **Idade**: 25-55
- **Perfil**: Cliente fiel, agenda pelo WhatsApp, valoriza atendimento personalizado
- **Dores**: Demora para responder, não sabe se tem horário, precise ligar para confirmar
- **Necessidades**: Agendar em 3 toques, receber lembrete automático, ver histórico, pagar online
- **Jornada**: Recebe link do salão → vê serviços → escolhe profissional → escolhe horário → confirma → recebe confirmação → lembrete 24h antes

## 4. Capacidades

Implementação do BBOP Capability Model v1.0 para o Studio Letícia.

| Capacidade | Status | Prioridade | Fase |
|---|---|---|---|
| Identity | Full | P0 | MVP |
| Authentication | Full | P0 | MVP |
| Authorization | Full | P0 | MVP |
| Tenant Management | Full | P0 | MVP |
| Profile | Full | P1 | MVP |
| Customer Management | Full | P0 | MVP |
| Scheduling | Full | P0 | MVP |
| Service Management | Full | P0 | MVP |
| Professional Management | Full | P0 | MVP |
| Commission Engine | Full | P0 | MVP |
| Financial Management | Limited | P1 | Expand |
| Catalog | Full | P1 | MVP |
| Payments | Full | P0 | MVP |
| Invoicing | Limited | P2 | Expand |
| Loyalty | Limited | P2 | Grow |
| Notifications | Full | P0 | Expand |
| Gallery | Full | P1 | Expand |
| Analytics | Full | P1 | Expand |
| Reports | Limited | P2 | Expand |
| Audit | Full | P1 | MVP |
| Feature Flags | Full | P1 | MVP |

## 5. MVP por Persona

### Cliente (App)
| ID | Funcionalidade | Descrição |
|---|---|---|
| C-01 | Página do salão | Landing page premium com identidade visual do Studio Letícia (nome, logo, fotos, endereço, horários) |
| C-02 | Vitrine de serviços | Lista de serviços por categoria com foto, descrição, duração e preço |
| C-03 | Escolha de profissional | Grid de profissionais com foto, especialidade, rating e disponibilidade |
| C-04 | Agenda visual | Timeline do profissional com slots disponíveis em destaque |
| C-05 | Confirmação | Resumo do agendamento, dados do cliente, confirmação com 1 toque |
| C-06 | Histórico | Agendamentos passados e futuros, serviços realizados |
| C-07 | Pagamento online | PIX e cartão de crédito via Mercado Pago |

### Profissional (App)
| ID | Funcionalidade | Descrição |
|---|---|---|
| P-01 | Agenda do dia | Timeline vertical com horários, clientes, serviços e status |
| P-02 | Check-in | Botão "Iniciar serviço" → status muda para Em Andamento |
| P-03 | Check-out | Botão "Concluir serviço" → comissão calculada automaticamente |
| P-04 | Comissão do dia | Valor acumulado visível no topo da tela |
| P-05 | Perfil | Foto, especialidades, horários de trabalho, regra de comissão |

### Dona (Admin Web/Mobile)
| ID | Funcionalidade | Descrição |
|---|---|---|
| D-01 | Dashboard | Mapa do dia: agendados, em andamento, concluídos, cancelados; faturamento do dia vs. ontem |
| D-02 | Agenda geral | Visão de todos os profissionais em grid horizontal |
| D-03 | Gestão de profissionais | CRUD: nome, especialidades, comissão, horários, ativo/inativo |
| D-04 | Gestão de serviços | CRUD: nome, categoria, duração, preço, comissão %, ativo/inativo |
| D-05 | Gestão de clientes | Lista, busca, histórico de agendamentos, gasto total, tags |
| D-06 | Financeiro | Vendas do dia, vendas do mês, comissão pendente vs. paga, despesas |
| D-07 | Caixa | Abertura, fechamento, conciliação de pagamentos |
| D-08 | Relatórios | Serviços mais vendidos, profissionais com maior faturamento, retenção de clientes |
| D-09 | Configurações | Dados do salão, horários de funcionamento, métodos de pagamento, integrações |
| D-10 | Galeria | Upload e organização de fotos do salão |

## 6. Casos de Uso

### UC-01: Agendamento Online (Cliente → App)
- **Ator**: Juliana (Cliente)
- **Pré-condição**: Salão possui link público ativo; profissional tem horário disponível
- **Fluxo Principal**:
  1. Juliana abre o link (QR code na mesa, link no Instagram, botão no WhatsApp)
  2. Visualiza página do Studio Letícia com identidade visual completa
  3. Navega pelos serviços por categoria (Ex: Cortes → Escova Progressiva)
  4. Seleciona serviço → vê duração e preço
  5. Vê grid de profissionais que realizam o serviço
  6. Seleciona profissional → vê agenda disponível (slots livres em verde)
  7. Seleciona horário → vê resumo (serviço + profissional + data + hora + valor)
  8. Confirma → sistema verifica disponibilidade em tempo real
  9. Se disponível: agendamento criado, profissional notificado, Juliana recebe confirmação
  10. Se indisponível: mensagem de erro, sugere próximo horário
- **Fluxo Alternativo**: Juliana já tem cadastro → dados pré-preenchidos
- **Pós-condição**: Appointment criado com status `scheduled`

### UC-02: Execução de Serviço (Profissional → App)
- **Ator**: Carla (Profissional)
- **Pré-condição**: Carla logada, dia de trabalho, appointment com status `confirmed`
- **Fluxo Principal**:
  1. Carla abre app → vê timeline do dia (10:00 Maria - Corte, 11:30 João - Barba, ...)
  2. Maria chega → Carla toca "Iniciar" no appointment das 10:00
  3. Status muda para `in_progress`, cliente notificado
  4. Carla executa o serviço
  5. Ao finalizar → toca "Concluir"
  6. Sistema calcula comissão automaticamente (ex: Corte R$80 → 50% = R$40)
  7. Comissão aparece no contador do dia
  8. Status muda para `completed`
- **Fluxo Alternativo**: Serviço não realizado → Carla toca "Cancelar" → informa motivo
- **Pós-condição**: Appointment `completed`, CommissionEntry `pending`, FinancialTransaction `pending`

### UC-03: Fechamento de Caixa (Dona → Admin)
- **Ator**: Letícia (Dona)
- **Pré-condição**: Dia encerrado, todos os appointments do dia estão `completed` ou `cancelled`
- **Fluxo Principal**:
  1. Letícia abre admin → módulo financeiro → "Fechar Caixa"
  2. Sistema exibe resumo do dia:
     - Total de vendas: R$ 1.200,00 (8 serviços)
     - Total recebido: R$ 1.200,00 (PIX: R$ 600, Cartão: R$ 400, Dinheiro: R$ 200)
     - Comissão total: R$ 540,00
     - Despesas do dia: R$ 50,00 (café, água)
  3. Letícia confere valores, ajusta se necessário
  4. Registra despesas do dia
  5. Confirma fechamento → caixa encerrado
- **Pós-condição**: CashRegister `closed`, comissões visíveis para saque, financeiro consolidado

## 7. Experiência Visual

### Direção de Design
Studio Letícia **não** deve parecer um sistema de gestão. Deve parecer o **app de uma marca de beleza premium**.

### Referências Visuais
| Referência | Por quê |
|---|---|
| **Hotel boutique (site)** | Minimalismo elegante, tipografia refinada, fotografia como protagonista |
| **Clinica premium (SP)** | Paleta suave, espaço negativo, transições suaves |
| **Apple (UI)** | Hierarquia clara, gestos naturais, micro-animações que encantam |
| **Marca de beleza (Chanel, Dior apps)** | Identidade forte, curadoria visual, sensação de exclusividade |

### Experiência Emocional por Tela
| Tela | Sentimento | Técnica |
|---|---|---|
| Página do salão (cliente) | "Que salão lindo!" | Fotos em grid assimétrico, tipografia refinada, logo em destaque |
| Escolha de serviço | "Quero tudo!" | Cards com fotos, descrição curta, preço em destaque |
| Escolha de profissional | "Ela é incrível!" | Fotos profissionais, rating com estrelas, bio curta |
| Agenda do profissional | "Que visual!" | Timeline vertical limpa, cores por status, transições suaves |
| Dashboard (dona) | "Tudo sob controle" | Métricas grandes, gráficos minimalistas, cor de destaque para variação |
| Financeiro | "Estou crescendo" | Números grandes, comparativos dia/mês, sparklines |

### Paleta Base
| Token | Cor | Uso |
|---|---|---|
| `--sl-primary` | `#D81B60` (Rosa) | Ações primárias, links, badges |
| `--sl-secondary` | `#FFB300` (Dourado) | Destaques, fidelidade, premium |
| `--sl-bg` | `#F5F0EB` (Off-white) | Fundo geral — sensação de papel/quente |
| `--sl-surface` | `#FFFFFF` | Cards, modais |
| `--sl-text` | `#1A1A1A` | Texto principal |
| `--sl-text-muted` | `#8C8C8C` | Texto secundário |
| `--sl-success` | `#2E7D32` | Confirmado, concluído |
| `--sl-error` | `#C62828` | Cancelado, erro |

### Tipografia
| Uso | Fonte | Peso |
|---|---|---|
| Títulos | Playfair Display | Bold, 24-32px |
| Corpo | Inter | Regular, 14-16px |
| Números | Inter | Semibold, monospace |
| Small | Inter | Regular, 12px |

## 8. Arquitetura SaaS & Multi-tenancy

### Roadmap de Evolução
```
Studio Letícia (primeiro inquilino)
    └── valida produto + identidade visual + modelo de precificação
            │
            ▼
BBOP Platform (multi-tenancy habilitado)
    ├── Salão A (personalização: logo, cores, serviços)
    ├── Salão B (personalização: logo, cores, serviços)
    └── Salão C (...)
            │
            ▼
Expansão para clínicas de estética, spas, barbearias
```

### Decisões de Arquitetura para Multi-tenancy
1. **Isolamento por `tenant_id`** em todas as tabelas (já definido no BBOP Domain Model)
2. **Personalização via dados** (logo, cores, domínio, serviços) — não via fork de código
3. **Feature Flags por tenant** — cada salão ativa funcionalidades no seu ritmo
4. **Domínio próprio** por tenant (ex: studio-leticia.futurecod.com.br → app.meusalao.com.br)
5. **Banco compartilhado + RLS** (row-level security) — isolamento no banco, não no servidor

### O que NÃO muda
- Código base único (monorepo)
- Um deploy, múltiplos tenants
- Contratos iguais (PaymentProvider, NotificationProvider)
- PLATFORM modules iguais

### O que muda por tenant
- Tema (cores, logo, tipografia)
- Catálogo de serviços
- Profissionais
- Regras de comissão
- Configurações de pagamento
- Domínio personalizado

## 9. Modelo de Dados (Entidades Principais)

### tenant
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| name | VARCHAR | Nome do salão |
| slug | VARCHAR | Identificador URL |
| logo_url | TEXT | URL do logo |
| primary_color | VARCHAR | #D81B60 |
| secondary_color | VARCHAR | #FFB300 |
| domain | VARCHAR | Domínio personalizado |
| settings | JSONB | Horários, feriados, regras gerais |
| status | ENUM | active, suspended, trial |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

### user
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| auth_user_id | UUID | Supabase Auth |
| email | VARCHAR | |
| phone | VARCHAR | |
| name | VARCHAR | |
| avatar_url | TEXT | |
| role_id | UUID | FK → role |
| is_active | BOOLEAN | |
| locale | VARCHAR | pt-BR |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

### professional
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| user_id | UUID | FK → user |
| bio | TEXT | |
| photo_url | TEXT | |
| specialties | UUID[] | service IDs |
| commission_default | DECIMAL | Percentual padrão |
| is_active | BOOLEAN | |
| rating_avg | DECIMAL | |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

### work_day (professional schedule)
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| professional_id | UUID | FK → professional |
| day_of_week | INT | 0-6 |
| start_time | TIME | |
| end_time | TIME | |
| is_available | BOOLEAN | |

### customer
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| user_id | UUID | FK → user (nullable) |
| name | VARCHAR | |
| email | VARCHAR | |
| phone | VARCHAR | |
| birth_date | DATE | |
| gender | VARCHAR | |
| notes | TEXT | |
| tags | TEXT[] | |
| total_visits | INT | |
| total_spent | DECIMAL | |
| last_visit_at | TIMESTAMPTZ | |
| source | VARCHAR | whatsapp, app, walkin, indication |
| consent_data | JSONB | LGPD consents |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

### service
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| category_id | UUID | FK → service_category |
| name | VARCHAR | |
| description | TEXT | |
| duration | INT | minutos |
| price | DECIMAL | |
| promotional_price | DECIMAL | nullable |
| commission_percentage | DECIMAL | |
| is_active | BOOLEAN | |
| image_url | TEXT | |
| order | INT | |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

### service_category
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| name | VARCHAR | |
| description | TEXT | |
| icon | VARCHAR | |
| order | INT | |
| is_active | BOOLEAN | |

### appointment
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| customer_id | UUID | FK → customer |
| professional_id | UUID | FK → professional |
| services | JSONB | [{service_id, name, duration, price, commission_pct}] |
| start_at | TIMESTAMPTZ | |
| end_at | TIMESTAMPTZ | |
| status | ENUM | scheduled, confirmed, in_progress, completed, cancelled, no_show, rescheduled |
| total_amount | DECIMAL | |
| commission_amount | DECIMAL | |
| source | VARCHAR | app, admin, whatsapp, walkin |
| notes | TEXT | |
| reschedule_count | INT | |
| cancelled_at | TIMESTAMPTZ | |
| cancellation_reason | TEXT | |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

### commission_entry
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| professional_id | UUID | FK → professional |
| appointment_id | UUID | FK → appointment |
| amount | DECIMAL | |
| percentage | DECIMAL | |
| status | ENUM | pending, approved, paid |
| paid_at | TIMESTAMPTZ | |
| paid_by | UUID | FK → user |
| created_at | TIMESTAMPTZ | |

### payment
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| appointment_id | UUID | FK → appointment |
| method | ENUM | credit_card, debit_card, pix, cash, ticket |
| amount | DECIMAL | |
| installments | INT | |
| gateway | VARCHAR | mercado_pago |
| gateway_payment_id | VARCHAR | |
| status | ENUM | pending, approved, refunded, declined |
| paid_at | TIMESTAMPTZ | |
| created_at | TIMESTAMPTZ | |

### financial_transaction
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| type | ENUM | sale, commission, expense, refund, withdrawal |
| amount | DECIMAL | |
| description | TEXT | |
| reference_id | UUID | appointment_id, etc. |
| reference_type | VARCHAR | |
| payment_method | VARCHAR | |
| status | ENUM | pending, completed, failed |
| reconciled | BOOLEAN | |
| created_at | TIMESTAMPTZ | |

### cash_register
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| opened_by | UUID | FK → user |
| closed_by | UUID | FK → user (nullable) |
| opened_at | TIMESTAMPTZ | |
| closed_at | TIMESTAMPTZ | |
| initial_balance | DECIMAL | |
| expected_balance | DECIMAL | |
| actual_balance | DECIMAL | |
| difference | DECIMAL | |
| status | ENUM | open, closed, reconciled |

### loyalty_account
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| customer_id | UUID | FK → customer |
| points | INT | |
| points_expire_at | DATE | |
| tier | ENUM | bronze, silver, gold, platinum |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

### notification_log
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| user_id | UUID | FK → user |
| appointment_id | UUID | FK → appointment (nullable) |
| channel | ENUM | push, email, whatsapp |
| template | VARCHAR | |
| content | TEXT | |
| status | ENUM | sent, delivered, opened, failed |
| sent_at | TIMESTAMPTZ | |
| delivered_at | TIMESTAMPTZ | |

### audit_log
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| user_id | UUID | FK → user |
| action | ENUM | create, update, delete, login, logout |
| entity_type | VARCHAR | |
| entity_id | UUID | |
| before | JSONB | estado anterior |
| after | JSONB | estado posterior |
| ip_address | VARCHAR | |
| user_agent | TEXT | |
| created_at | TIMESTAMPTZ | |

### feature_flag
| Campo | Tipo | Descrição |
|---|---|---|
| id | UUID | PK |
| tenant_id | UUID | FK → tenant |
| key | VARCHAR | |
| name | VARCHAR | |
| description | TEXT | |
| is_enabled | BOOLEAN | |
| enabled_for_roles | UUID[] | |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

## 10. Integrações

| Integração | Tipo | Provedor | Fase |
|---|---|---|---|
| Autenticação Google | OAuth | Supabase Auth | MVP |
| Autenticação Email/Senha | Built-in | Supabase Auth | MVP |
| Pagamentos PIX | API | Mercado Pago | MVP |
| Pagamentos Cartão | API | Mercado Pago | MVP |
| Notificação Push | API | FCM | Expand |
| Notificação Email | SMTP | Resend/SendGrid | Expand |
| Notificação WhatsApp | API | Weni/WhasSys | Expand |
| Analytics | SDK | PostHog | Expand |
| Armazenamento de imagens | Storage | Supabase Storage | MVP |
| Galeria | Storage | Supabase Storage | Expand |
| IA Assistente | API | OpenAI | Grow |
| Recomendação | API | OpenAI | Grow |
| Google Calendar (sync) | API | Google | Grow |

## 11. Requisitos Não Funcionais

| ID | Requisito | Categoria | Especificação |
|---|---|---|---|
| RNF-001 | Tempo de carregamento da agenda | Performance | < 1.5s |
| RNF-002 | Confirmação de agendamento | Performance | < 1s |
| RNF-003 | Notificações em tempo real | Performance | < 5s do evento |
| RNF-004 | Downtime mensal | Disponibilidade | < 1h/mês |
| RNF-005 | Backup automático | Disponibilidade | Diário + PITR |
| RNF-006 | MFA disponível | Segurança | DPES padrão |
| RNF-007 | Auditoria obrigatória | Segurança | Toda ação crítica logada |
| RNF-008 | LGPD compliance | Segurança | Consentimento + exclusão |
| RNF-009 | RLS em todas as queries | Segurança | tenant_id isolado |
| RNF-010 | App funciona offline parcial | Usabilidade | Agenda em cache |
| RNF-011 | NPS > 70 | Usabilidade | Meta 6 meses |
| RNF-012 | Agendamento em < 30s | Usabilidade | 3 toques |
| RNF-013 | Suporte a telas pequenas | Acessibilidade | Mínimo 320px |
| RNF-014 | Dark mode | Acessibilidade | v2 |

## 12. Feature Flags (MVP)

| Flag | Descrição | Default |
|---|---|---|
| `online_booking` | Agendamento online público | ON |
| `payment_online` | Pagamento online via app | OFF (apenas balcão no MVP) |
| `loyalty_program` | Programa de fidelidade | OFF |
| `whatsapp_reminder` | Lembrete via WhatsApp | OFF |
| `ai_assistant` | Assistente virtual | OFF |
| `gallery_public` | Galeria visível no link público | ON |

## 13. Métricas de Sucesso

| KPI | Fórmula | Meta | Frequência |
|---|---|---|---|
| Agendamentos pelo app | (agendamentos app / total) × 100 | > 50% | Semanal |
| No-show rate | (no_show / total) × 100 | < 10% | Semanal |
| Retenção mensal | (clientes ativos mês / total) × 100 | > 70% | Mensal |
| Ticket médio | receita / appointments | > R$ 80 | Mensal |
| Comissão processada em 24h | comissão paga em 24h / total | > 90% | Diária |
| Profissionais ativos | profissionais que abriram app hoje | > 80% | Diária |
| Tempo de agendamento | tempo médio entre seleção e confirmação | < 30s | Semanal |
| NPS | pesquisa trimestral | > 70 | Trimestral |
| Tempo entre agendamento e realização | horas | < 48h | Mensal |

## 14. Critérios de Aceitação (Gate E — Lançamento)

- [ ] Fluxo completo de agendamento online testado (cliente → escolha → confirmação)
- [ ] Fluxo completo de execução testado (iniciar → concluir → comissão)
- [ ] Fluxo completo de fechamento de caixa testado
- [ ] Pagamento via PIX e cartão funcionando em sandbox Mercado Pago
- [ ] Notificação push enviada em todos os eventos críticos
- [ ] RLS policy criada para todas as tabelas com tenant_id
- [ ] Audit log capturando todas as ações críticas
- [ ] Feature flags operacionais (toggle sem deploy)
- [ ] Todos os appointments respeitam regra de conflito de horário
- [ ] Testes E2E dos 3 fluxos principais passando
- [ ] Performance validada (< 1.5s tela de agenda)
- [ ] Sem vulnerabilidades críticas (dependências auditadas)
- [ ] Onboarding documentado

## 15. Roadmap

| Fase | Período | Marcos |
|---|---|---|
| **Fundação** | Semana 1-2 | BOS aprovado, PRD aprovado, Architecture draft, ADRs |
| **Database** | Semana 3-4 | Migrations, RLS, Seed data, Edge Functions setup |
| **MVP Core** | Semana 5-10 | Auth, Tenant, Professional, Service, Customer, Agenda, Comissão, Caixa |
| **MVP Pagamentos** | Semana 11-12 | Mercado Pago integration (PIX + Cartão), Payment flow |
| **MVP Admin** | Semana 13-14 | Dashboard, Financial, Reports, Configurações |
| **MVP Cliente** | Semana 15-16 | Vitrine pública, agendamento online, histórico |
| **Beta** | Semana 17-18 | Testes com usuário real (Studio Letícia), ajustes |
| **Produção** | Semana 19-20 | Lançamento, monitoramento, suporte |

## 16. Approval

| Role | Name | Date |
|---|---|---|
| Product Owner | Raffa | |
| Chief Architect | Eddie | |
| Tech Lead | | |
| Design Lead | | |

---

**PRD v1.0 — Studio Letícia Experience**
*Framework: BBOP v1.0 | Plataforma: FUTURECOD DPES*
