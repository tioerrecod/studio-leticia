---
id: slbos
title: "Studio Letícia Business Operating System v2.0"
version: "2.0.0"
status: "bos"
owner: "Raffa"
depends_on: ["bbop-vision", "bbop-capability-model", "bbop-domain-model", "dpes-manifesto"]
used_by: ["sl-prd"]
last_review: "2026-07-13"
next_review: "2026-10-13"
---

# SLBOS — Studio Letícia Business Operating System v2.0

**Empresa**: Studio Letícia — Salão de Beleza
**Framework**: BBOP v1.0 (Beauty Business Operating Platform)
**Stack**: DPES Architecture + PLATFORM Components + CONTRACTS Abstractions

---

## 1. Estratégia

### Missão
Oferecer a melhor experiência digital para salões de beleza independentes, organizando agenda, clientes e finanças com simplicidade e elegância.

### Visão
Ser o sistema operacional preferido de salões e clínicas de estética no Brasil.

### Proposta de Valor
Gestão completa de agendamento, profissionais e comissões — simplificada para o dia a dia do salão, com cara de salão.

### Diferenciais Estratégicos
| Diferencial | Descrição | Defesa |
|---|---|---|
| Agenda Visual | Quadro de profissionais com slots em tempo real | UX proprietária |
| Comissão Automática | Regras por serviço, categoria ou profissional | Motor de comissão configurável |
| Fidelidade Integrada | Programa de pontos automático por consumo | Lealdade vs. desconto |
| Relatórios por Profissional | Performance individual, comissão, retenção | Dados que o dono precisa |

## 2. Personas

### Letícia (Dona do Salão)
- **Perfil**: Empreendedora, 30-50 anos, gerencia 3-15 profissionais
- **Dores**: Planilha no Excel, comissão calculada na mão, cliente não confirma horário
- **Necessidades**: Visão do dia, faturamento em tempo real, relatórios simples
- **Jornada**: Abre o app → vê agenda do dia → confirma agendamentos → fecha caixa

### Carla (Profissional)
- **Perfil**: Cabelereira/esthetician, 22-40 anos, usa WhatsApp para tudo
- **Dores**: Não sabe se tem cliente agendado, esquece horário, comissão atrasa
- **Necessidades**: Ver agenda do dia, saber quanto vai ganhar, avisar atraso
- **Jornada**: Chega → olha agenda no celular → executa serviços → vê comissão do dia

### Juliana (Cliente)
- **Perfil**: Cliente fiel, 25-55 anos, agenda pelo WhatsApp
- **Dores**: Demora para responder, não sabe se tem horário, precisa confirmar
- **Necessidades**: Agendar rápido, lembrete automático, ver histórico
- **Jornada**: Abre link → escolhe serviço + profissional → agenda → recebe confirmação

## 3. Capacidades (BBOP → Studio Letícia)

Studio Letícia implementa as seguintes capacidades do BBOP Capability Model v1.0.

| Capacidade | Status | Prioridade | Módulo PLATFORM |
|---|---|---|---|
| Identity | Full | P0 | platform-auth |
| Authentication | Full (Google + Email) | P0 | platform-auth |
| Authorization | Full (9 níveis) | P0 | platform-auth |
| Tenant Management | Full (single-tenant nativo) | P0 | platform-auth |
| Profile | Full | P1 | platform-auth |
| Customer Management | Full | P0 | bbop-crm |
| Scheduling | Full | P0 | bbop-scheduling |
| Service Management | Full | P0 | bbop-service-catalog |
| Professional Management | Full | P0 | bbop-professional |
| Commission Engine | Full | P0 | bbop-financial |
| Inventory Management | Not Used (v2) | — | — |
| Task Management | Not Used (v2) | — | — |
| Financial Management | Limited (simplificado) | P1 | bbop-financial |
| Catalog | Full | P1 | bbop-service-catalog |
| Payments | Full (Mercado Pago) | P0 | platform-payments |
| POS | Not Used (v2) | — | — |
| Invoicing | Limited (recibo) | P2 | bbop-financial |
| Loyalty | Limited (v1 simplificada) | P2 | bbop-loyalty |
| Notifications | Full (push + e-mail) | P0 | platform-notifications |
| Marketing | Not Used (v2) | — | — |
| Courses | Not Used (v3) | — | — |
| Gallery | Full (fotos do salão) | P1 | platform-media |
| Analytics | Full (dashboards) | P1 | platform-analytics |
| Reports | Limited (básico v1) | P2 | platform-analytics |
| AI Recommendations | Not Used (v2) | — | platform-ai |
| AI Assistant | Not Used (v2) | — | platform-ai |
| Audit | Full | P1 | platform-audit |
| Feature Flags | Full (8 flags) | P1 | platform-feature-flags |
| Integrations | Limited (Mercado Pago + Google) | P1 | platform-events |

## 4. Contratos (CONTRACTS)

| Contrato | Provider | Implementação |
|---|---|---|
| `PaymentProvider` | Mercado Pago | platform-payments |
| `NotificationProvider` | FCM + e-mail | platform-notifications |
| `AIProvider` | OpenAI | platform-ai |
| `AnalyticsProvider` | PostHog | platform-analytics |

## 5. Jornadas Principais

### J-01: Agendamento pelo App
1. Cliente abre o app ou link público
2. Escolhe serviço → vê profissionais disponíveis
3. Seleciona horário → confirma
4. Profissional recebe notificação push
5. Sistema envia lembrete automático 24h antes
6. Se confirmado → bloco reservado; se não → libera horário

### J-02: Check-in e Execução
1. Cliente chega ao salão
2. Profissional marca "Iniciou" no app
3. Serviço executado
4. Profissional marca "Concluído"
5. Comissão calculada automaticamente
6. Financeiro registra venda

### J-03: Fechamento do Dia
1. Dono abre o app admin
2. Vê agenda do dia (realizado vs. agendado)
3. Vê faturamento do dia
4. Vê comissões por profissional
5. Fecha caixa (concilia pagamentos)

## 6. Regras de Negócio (Business Rules)

### Agendamento
- BR-001: Profissional não pode ter 2 agendamentos no mesmo horário
- BR-002: Cliente bloqueado não pode agendar
- BR-003: Agendamento online requer confirmação 24h antes
- BR-004: Cancelamento gratuito até 4h antes; após, taxa de 50%
- BR-005: Cliente pode remarcar 1x grátis por agendamento

### Comissão
- BR-010: Comissão padrão = 50% do serviço
- BR-011: Comissão pode ser fixa (R$) ou percentual por serviço
- BR-012: Comissão é calculada no momento da conclusão
- BR-013: Comissão só é paga se o pagamento for confirmado
- BR-014: Profissional pode ter regra geral + regras específicas por serviço

### Financeiro
- BR-020: Venda pode ser paga em dinheiro, cartão, PIX ou fiado
- BR-021: Fiado tem prazo máximo de 30 dias
- BR-022: Caixa deve ser fechado ao final do expediente
- BR-023: Recebimento em cartão tem taxa de 3-5% (repassada ao salão)
- BR-024: Despesas do dia devem ser registradas no fechamento

### Fidelidade
- BR-030: 1 ponto por R$ 1 gasto
- BR-031: 100 pontos = R$ 10 de desconto
- BR-032: Pontos expiram em 12 meses
- BR-033: Indicação de novo cliente = 50 pontos bônus

## 7. Fases de Implementação

### Fase 1 — MVP (Fundação)
| ID | Funcionalidade | Capacidade | Módulo |
|---|---|---|---|
| F-001 | Autenticação (Google + Email) | Authentication | platform-auth |
| F-002 | Gestão de profissionais | Professional Management | bbop-professional |
| F-003 | Gestão de serviços | Service Management | bbop-service-catalog |
| F-004 | Agenda visual | Scheduling | bbop-scheduling |
| F-005 | Check-in e conclusão | Scheduling | bbop-scheduling |
| F-006 | Vendas no balcão | Payments | platform-payments |
| F-007 | Cadastro de clientes | Customer Management | bbop-crm |
| F-008 | Perfil do profissional | Profile | platform-auth |

### Fase 2 — Engajamento
| ID | Funcionalidade | Capacidade | Módulo |
|---|---|---|---|
| F-009 | Agendamento online (link público) | Scheduling | bbop-scheduling |
| F-010 | Lembrete automático (push) | Notifications | platform-notifications |
| F-011 | Lembrete automático (WhatsApp) | Notifications | platform-notifications |
| F-012 | Dashboard do dono | Analytics | platform-analytics |
| F-013 | Relatório de comissão | Reports | platform-analytics |
| F-014 | Fechamento de caixa | Financial Management | bbop-financial |
| F-015 | Galeria de fotos | Gallery | platform-media |

### Fase 3 — Crescimento
| ID | Funcionalidade | Capacidade | Módulo |
|---|---|---|---|
| F-016 | Programa de fidelidade | Loyalty | bbop-loyalty |
| F-017 | Inovice (recibo digital) | Invoicing | bbop-financial |
| F-018 | Indicar amigo (bônus) | Loyalty | bbop-loyalty |
| F-019 | Histórico do cliente | Customer Management | bbop-crm |
| F-020 | Campanhas de marketing | Marketing | platform-notifications |

### Fase 4 — Inteligência
| ID | Funcionalidade | Capacidade | Módulo |
|---|---|---|---|
| F-021 | Recomendação de serviços | AI Recommendations | platform-ai |
| F-022 | Assistente virtual | AI Assistant | platform-ai |
| F-023 | Detecção de no-show | Anomaly Detection | platform-ai |
| F-024 | Relatórios avançados | Reports | platform-analytics |

## 8. Stack Técnica

| Camada | Tecnologia | Fonte |
|---|---|---|
| Mobile | Flutter | DPES Architecture |
| Admin Web | Flutter Web | DPES Architecture |
| Backend | Supabase (PostgreSQL + Edge Functions) | DPES Architecture |
| Auth | Supabase Auth | PLATFORM |
| Pagamentos | Mercado Pago | CONTRACTS → PLATFORM |
| Notificações | FCM + WhatsApp | CONTRACTS → PLATFORM |
| IA | OpenAI | CONTRACTS → PLATFORM |
| Analytics | PostHog | CONTRACTS → PLATFORM |
| Storage | Supabase Storage | PLATFORM |
| Deploy | Vercel + GitHub Actions | DPES |

## 9. Eventos de Domínio

| Evento | Publisher | Descrição |
|---|---|---|
| `appointment.created` | bbop-scheduling | Novo agendamento |
| `appointment.confirmed` | bbop-scheduling | Cliente confirmou |
| `appointment.cancelled` | bbop-scheduling | Agendamento cancelado |
| `appointment.completed` | bbop-scheduling | Serviço concluído |
| `payment.approved` | platform-payments | Pagamento confirmado |
| `commission.calculated` | bbop-financial | Comissão calculada |
| `customer.created` | bbop-crm | Novo cliente cadastrado |
| `customer.loyalty_updated` | bbop-loyalty | Pontos alterados |

## 10. Critérios de Sucesso (KRs)

| KR | Meta | Prazo | Fase |
|---|---|---|---|
| Agendamentos pelo app > 50% | 50% | 3 meses pós Fase 2 | F2 |
| No-show rate < 10% | < 10% | 3 meses pós Fase 2 | F2 |
| NPS > 70 | > 70 | 6 meses pós MVP | F3 |
| 80% dos profissionais usam o app diariamente | 80% | 3 meses pós MVP | F1 |
| Tempo médio de agendamento < 30s | < 30s | MVP | F1 |

## 11. Approval

| Role | Name | Date |
|---|---|---|
| Product Owner | Raffa | |
| Chief Architect | Eddie | |
| Tech Lead | | |
| Design Lead | | |

---

**SLBOS v2.0 — Studio Letícia Experience**
*Framework: BBOP v1.0 | Platform: FUTURECOD DPES*
