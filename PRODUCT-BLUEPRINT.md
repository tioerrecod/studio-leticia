# PRODUCT BLUEPRINT — Studio Letícia Experience

**Versão:** 1.0
**Baseado em:** SLBOS 2.0, PRD 1.0, DOMAIN-MODEL 1.0, DATABASE-DESIGN 1.1 (22 migrations)

---

## 1. Product Vision

### Posicionamento

**Studio Letícia** não é um sistema de agenda para salão.

É uma **plataforma de relacionamento inteligente** que transforma cada cliente em uma história contínua, usando IA para entender preferências, antecipar necessidades e criar relacionamentos de longo prazo entre profissionais de beleza e seus clientes.

### One-liner

> A memória digital do seu negócio de beleza.

### O Problema

Um profissional de beleza hoje usa ferramentas desconectadas:
- WhatsApp para conversar
- Instagram para atrair
- Google Agenda para horários
- Planilha para controle financeiro
- Papel para histórico
- Sistemas separados para pagamento
- Própria memória para lembrar preferências

O Studio Letícia une tudo em uma plataforma: **Atrair → Conhecer → Agendar → Encantar → Reter → Vender novamente**.

### Promessa de Valor

> "Cada cliente que entra no seu estúdio, o sistema já sabe quem ela é, o que prefere, quando volta e como encantá-la."

---

## 2. Arquitetura dos Aplicativos

### 2.1 App Cliente — "Minha Experiência"

Não parece aplicativo de salão. Parece um **concierge digital de beleza**.

**Tom:** Premium, acolhedor, pessoal, emocional
**Referências:** Apple Health, Airbnb, marcas de skincare premium
**Plateforma:** Android + iOS (Flutter)
**Público:** Clientes finais dos estúdios

#### Mapa de Telas

```
[Splash] → [Onboarding] → [Home] → [Agendar] → [Confirmação]
                                     ↓
                                  [Perfil Beleza]
                                     ↓
                                  [Histórico]
                                     ↓
                                  [Benefícios]
```

#### 2.1.1 Splash & Onboarding

```
┌─────────────────────────┐
│                         │
│     [Logo animado]      │
│    Studio Letícia       │
│                         │
│  "Sua beleza, nossa     │
│   história"             │
│                         │
│  [Começar experiência]  │
│                         │
└─────────────────────────┘
```

Onboarding em 3 passos:

1. **Conheça seu estúdio** — Fotos, ambiente, profissionais
2. **Seu perfil de beleza** — Nome, telefone, preferências iniciais
3. **Pronto para começar** — Permissão de notificações

#### 2.1.2 Home

A tela principal. Vende desejo, não funções.

```
┌──────────────────────────────────┐
│  ┌──────┐                        │
│  │📷 IA │   Bom dia, Letícia ✨   │
│  └──────┘                        │
│                                  │
│  Seu último corte foi há 42 dias │
│  — momento ideal para renovar    │
│                                  │
│  ┌──────────────────────────────┐│
│  │    [Minha próxima            ││
│  │     experiência]             ││
│  │                              ││
│  │  15 de Agosto · 14:30        ││
│  │  Letícia · Coloração Premium ││
│  │  Duração: 2h30               ││
│  └──────────────────────────────┘│
│                                  │
│  ✨ 340 pontos · Cliente Gold    │
│                                  │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐   │
│  │Home│ │Agd.│ │Hist│ │Perf│   │
│  └────┘ └────┘ └────┘ └────┘   │
└──────────────────────────────────┘
```

**Elementos:**
- Foto premium do profissional/estúdio (hero image)
- Mensagem personalizada gerada por IA (memória da migration 021)
- Próximo agendamento destacado (se existir)
- Botão CTA principal: "Minha próxima experiência"
- Card de benefícios (pontos, nível fidelidade)
- Bottom navigation: Home, Agendar, Histórico, Perfil

**Estados:**
- **Sem agendamento:** Mostra "Que tal começar sua experiência hoje?" + galeria de serviços
- **Com agendamento próximo:** Card destacado com contagem regressiva
- **Pós-atendimento:** "Como foi sua experiência?" + avaliação

#### 2.1.3 Agendar Experiência

Fluxo de agendamento em etapas (uma por tela):

**Etapa 1 — Escolha o momento**

```
┌──────────────────────────────────┐
│         Nova Experiência         │
│                                  │
│  ┌──────────────────────────────┐│
│  │ [Profissional Letícia]  →    ││
│  └──────────────────────────────┘│
│                                  │
│  Serviço                         │
│  ┌──────────────────────────────┐│
│  │ ○ Corte Feminino    R$ 80   ││
│  │ ○ Coloração Premium R$ 250  ││
│  │ ● Hidratação        R$ 60   ││
│  │ ○ Manicure          R$ 35   ││
│  └──────────────────────────────┘│
│                                  │
│  Quando?                         │
│  ┌─────┬─────┬─────┬─────┬────┐ │
│  │ Seg │ Ter │ Qua │ Qui │ Sex│ │
│  │ 12  │ 13  │ ●14 │ 15  │ 16 │ │
│  └─────┴─────┴─────┴─────┴────┘ │
│                                  │
│  14:00    14:30    15:00    15:30│
│  ● Disp.  ○ Disp.  ○ Disp.  ○   │
│                                  │
│  ┌──────────────────────────────┐│
│  │      Confirmar Agendamento   ││
│  └──────────────────────────────┘│
└──────────────────────────────────┘
```

**Etapa 2 — Personalizar**

```
┌──────────────────────────────────┐
│   Quase lá... Vamos personalizar │
│                                  │
│  Observações para o profissional │
│  ┌──────────────────────────────┐│
│  │ Gostaria de tonalizar...     ││
│  └──────────────────────────────┘│
│                                  │
│  Adicionais:                     │
│  ☐ Hidratação extra    +R$ 30   │
│  ☐ Finalização         +R$ 20   │
│                                  │
│  Lembrar de:                     │
│  ☐ Enviar inspirações            │
│  ☐ WhatsApp de confirmação       │
│                                  │
│  ┌──────────────────────────────┐│
│  │         Confirmar            ││
│  └──────────────────────────────┘│
└──────────────────────────────────┘
```

**Etapa 3 — Confirmação**

```
┌──────────────────────────────────┐
│       Tudo pronto! ✨             │
│                                  │
│  ┌──────────────────────────────┐│
│  │  🎉                          ││
│  │                              ││
│  │  Seu momento está marcado    ││
│  │                              ││
│  │  📅 Qui, 14 de Agosto        ││
│  │  ⏰ 14:30                    ││
│  │  💇 Letícia                  ││
│  │  💎 Coloração Premium        ││
│  │  ⏱ 2h30                     ││
│  │  💰 R$ 250                   ││
│  └──────────────────────────────┘│
│                                  │
│  ✨ Você ganhou 25 pontos        │
│                                  │
│  Lembrete automático:            │
│  ✅ WhatsApp 24h antes           │
│  ✅ Push 1h antes                │
│                                  │
│  [Compartilhar]  [Voltar para Home]│
└──────────────────────────────────┘
```

#### 2.1.4 Perfil de Beleza

Não é cadastro. É uma **memória viva**.

```
┌──────────────────────────────────┐
│         Meu Perfil               │
│                                  │
│  ┌──────────────────────────────┐│
│  │   👩 Letícia                  ││
│  │   Cliente desde Mar/2025     ││
│  │   12 visitas · R$ 2.450      ││
│  └──────────────────────────────┘│
│                                  │
│  Meu estilo                      │
│  ┌──────────────────────────────┐│
│  │ Corte: Cacheado médio        ││
│  │ Cor: Castanho claro          ││
│  │ Prefere: Tons quentes        ││
│  │ Evita: Muita química         ││
│  │ Produto favorito: Wella      ││
│  └──────────────────────────────┘│
│                                  │
│  Minha memória ✨                 │
│  ┌──────────────────────────────┐│
│  │ "Letícia prefere conversar   ││
│  │  pouco durante química"      ││
│  │                              ││
│  │ "Está planejando casamento   ││
│  │  para setembro"              ││
│  │                              ││
│  │ "Prefere sábado de manhã"    ││
│  └──────────────────────────────┘│
│                                  │
│  Minhas fotos                    │
│  ┌────┐ ┌────┐ ┌────┐           │
│  │📷  │ │📷  │ │📷  │           │
│  │Ante│ │Dura│ │Depo│           │
│  └────┘ └────┘ └────┘           │
└──────────────────────────────────┘
```

**Dados exibidos (da migration 021 — ai_customer_memory):**
- Preferências de estilo
- Comportamentos
- Conversas anteriores
- Observações do profissional
- Produtos preferidos

#### 2.1.5 Jornada do Atendimento (Experiência)

```
┌──────────────────────────────────┐
│     Sua experiência hoje         │
│                                  │
│  Antes                           │
│  ┌──────────────────────────────┐│
│  │ ✅ Agendamento confirmado    ││
│  │ ✅ Inspirações enviadas      ││
│  │ ☐ Lembrete 24h antes         ││
│  └──────────────────────────────┘│
│                                  │
│  Durante                         │
│  ┌──────────────────────────────┐│
│  │ 🔴 Recepção                  ││
│  │ ⚪ Diagnóstico               ││
│  │ ⚪ Procedimento              ││
│  │ ⚪ Finalização               ││
│  └──────────────────────────────┘│
│                                  │
│  Depois                          │
│  ┌──────────────────────────────┐│
│  │ ⭐ Como foi sua experiência? ││
│  │                              ││
│  │  😍  😊  😐  🙁  😢          ││
│  │                              ││
│  │ [Registrar avaliação]        ││
│  └──────────────────────────────┘│
└──────────────────────────────────┘
```

#### 2.1.6 Histórico

```
┌──────────────────────────────────┐
│       Minha Jornada              │
│                                  │
│  2026                            │
│  ┌──────────────────────────────┐│
│  │ ● Julho                      ││
│  │                              ││
│  │  15 Jul — Corte + Hidratação ││
│  │  Prof: Letícia · R$ 140      ││
│  │  ★★★★☆                      ││
│  │                              ││
│  │  02 Jun — Coloração Premium  ││
│  │  Prof: Letícia · R$ 250      ││
│  │  ★★★★★                       ││
│  └──────────────────────────────┘│
│                                  │
│  2025                            │
│  ┌──────────────────────────────┐│
│  │ ● Maio                       ││
│  │  20 Mai — Manicure           ││
│  │  ★★★☆☆                       ││
│  └──────────────────────────────┘│
└──────────────────────────────────┘
```

### 2.2 App Admin — "Beauty Command Center"

Não é dashboard. É o **cérebro do negócio**.

**Tom:** Profissional, inteligente, dados, IA
**Referências:** Notion, Linear, Tesla dashboard
**Plateforma:** Flutter Web (responsivo)
**Público:** Donos de estúdio, profissionais, gerentes

#### Mapa de Telas

```
[Login] → [Command Center] → [Agenda Inteligente]
                                → [Perfil 360º Cliente]
                                → [Financeiro]
                                → [Marketing]
                                → [Produtos]
                                → [Configurações]
```

#### 2.2.1 Command Center (Home)

```
┌──────────────────────────────────────────────────────┐
│ ☰ Beauty Command Center          🔔  👤 Letícia      │
├──────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────┐  Bom dia, Letícia                          │
│  │📷    │                                            │
│  └──────┘  Hoje: 12/08 · 8 clientes · ☀️ 28°C       │
│                                                      │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌──────────┐   │
│  │ 12      │ │ R$2.840 │ │ 87%     │ │ 3        │   │
│  │hoje     │ │previsto │ │retorno  │ │oportunid │   │
│  └─────────┘ └─────────┘ └─────────┘ └──────────┘   │
│                                                      │
│  ─── IA Recomenda ────────────────────────────────   │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │ ⚠ Maria Silva — 74 dias sem voltar             │  │
│  │ Probabilidade de retorno: 18%                   │  │
│  │ Último: Coloração Premium (R$250)               │  │
│  │ Sugestão: Enviar campanha de recuperação        │  │
│  │                                        [Enviar] │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │ 💡 Ana Costa — interesse em hidratação         │  │
│  │ Comentou na última visita que quer testar      │  │
│  │ nossa hidratação premium com queratina         │  │
│  │                                        [Oferecer]│  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  ─── Próximos Atendimentos ──────────────────────    │
│                                                      │
│  14:00 │ Ana Silva        │ Coloração │ ★★★★★ │    │
│  15:00 │ Beatriz          │ Corte     │ ★★★★  │    │
│  16:30 │ Carla            │ Hidratação│ ★★★   │    │
│                                                      │
│  ─── Indicadores Rápidos ────────────────────────    │
│  Receita mês:   R$ 18.450  ↗ 12% vs julho           │
│  Ticket médio:  R$ 142     → estável                 │
│  Retenção:      82%        ↗ 5%                      │
│  Agendamentos:  84         ↗ 8%                      │
└──────────────────────────────────────────────────────┘
```

#### 2.2.2 Perfil 360º do Cliente

A tela mais importante do produto.

```
┌──────────────────────────────────────────────────────┐
│ ☰ ← Clientes               MARIA SILVA               │
├──────────────────────────────────────────────────────┤
│                                                      │
│  ┌───┐  Maria Silva          ★★★★★  (12 avaliações) │
│  │📷 │                        ⏰ Cliente há 2 anos   │
│  └───┘  (11) 99999-9999       💰 R$ 4.850 gerados    │
│         maria@email.com       📍 Zona Sul             │
│                                                      │
│  ─── Próximo Atendimento ──────────────────────────  │
│  Último: Coloração Premium — 14 Jul 2026 (30 dias)   │
│  Ciclo ideal: 45 dias → ⚠ 15 dias para o alerta     │
│                                                      │
│  ─── Memória IA ──────────────────────────────────   │
│  ┌────────────────────────────────────────────────┐  │
│  │ 🧠 "Prefere conversar pouco durante química"   │  │
│  │ 🧠 "Está planejando casamento em setembro"     │  │
│  │ 🧠 "Não gosta de tons muito claros"            │  │
│  │ 🧠 "Melhor horário: sábado de manhã"           │  │
│  │ 🧠 "Comprou Wella Fusion na última visita"     │  │
│  │                              [+ Adicionar]      │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  ─── Recomendações IA ────────────────────────────   │
│  ┌────────────────────────────────────────────────┐  │
│  │ 💡 Botox capilar — compatível com perfil       │  │
│  │   Maria tem cabelos quimicamente tratados e    │  │
│  │   pode se beneficiar de reconstrução capilar   │  │
│  │                                        [Oferecer]│  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  ─── Histórico ──────────────────────────────────    │
│  ┌────┬──────────────┬──────────┬───────┬──────┐    │
│  │Data│ Serviço      │Prof      │ Valor │Status│    │
│  ├────┼──────────────┼──────────┼───────┼──────┤    │
│  │14/7│ Coloração    │Letícia   │ R$250 │ ✅   │    │
│  │02/6│ Corte        │Letícia   │ R$ 80 │ ✅   │    │
│  │20/5│ Hidratação   │Carla     │ R$ 60 │ ✅   │    │
│  └────┴──────────────┴──────────┴───────┴──────┘    │
│                                                      │
│  ─── Produtos Comprados ──────────────────────────   │
│  Shampoo Reconstrutor      14 Jul       R$ 45,90     │
│  Máscara Hidratação        02 Jun       R$ 79,90     │
│                                                      │
│  ─── Campanhas Recebidas ────────────────────────    │
│  Aniversário             10 Mar      ✅ aberta       │
│  Retorno 60 dias         15 Jul      ❌ não aberta   │
│                                                      │
│  ─── Ações Rápidas ──────────────────────────────    │
│  [Agendar] [Enviar WhatsApp] [Criar Campanha]        │
└──────────────────────────────────────────────────────┘
```

#### 2.2.3 Agenda Inteligente

```
┌──────────────────────────────────────────────────────┐
│ ☰ Agenda                  Qui, 14 de Agosto 2026     │
├──────────────────────────────────────────────────────┤
│  [Hoje] [Semana] [Mês]                    ← Hoje →   │
│                                                      │
│  08:00 ────────────────────────────────────────────  │
│  09:00 │                                             │
│  10:00 │   Ana — Coloração Premium [2h30]     ★★★★★ │
│        │   "Prefere conversar pouco"                 │
│  11:00 │                                             │
│  12:00 │   ⬜ Intervalo                               │
│  13:00 │                                             │
│  14:00 │   Beatriz — Corte [30min]             ★★★★  │
│  14:30 │   Carla — Hidratação [40min]          ★★★   │
│        │   💡 IA: Sugerir reconstrução               │
│  15:00 │                                             │
│  16:00 │   ⬜ Livre                                   │
│  17:00 │   ⬜ Livre                                   │
│  18:00 │                                             │
│                                                      │
│  KPIs do Dia:                                        │
│  5 atendimentos · R$ 1.240 · 78% ocupação            │
└──────────────────────────────────────────────────────┘
```

#### 2.2.4 Financeiro

```
┌──────────────────────────────────────────────────────┐
│ ☰ Financeiro                    Agosto 2026          │
├──────────────────────────────────────────────────────┤
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌──────────┐   │
│  │R$18.450 │ │ R$5.200 │ │R$13.250 │ │   72%    │   │
│  │Receita  │ │Custo    │ │Lucro    │ │Margem    │   │
│  └─────────┘ └─────────┘ └─────────┘ └──────────┘   │
│                                                      │
│  ─── Receita por Serviço ────────────────────────    │
│  Coloração Premium        R$ 8.200     44%           │
│  Corte                    R$ 4.500     24%           │
│  Hidratação               R$ 3.200     17%           │
│  Manicure                 R$ 1.800     10%           │
│  Produtos                 R$ 750        5%           │
│                                                      │
│  ─── Comissões ──────────────────────────────────    │
│  Profissional  │ Serviços │ Comissão │  %   │ Pago  │
│  Letícia       │    12    │ R$ 620   │ 50%  │  ✅   │
│  Carla         │     8    │ R$ 310   │ 40%  │  ⏳    │
│                                                      │
│  ─── Fluxo de Caixa ────────────────────────────     │
│  ┌────────────────────────────────────────────────┐  │
│  │ 💰 Caixa: R$ 3.200  │   Aberto: 08h             │  │
│  │ Entradas: R$ 840    │   Saídas: R$ 120          │  │
│  └────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────┘
```

#### 2.2.5 Marketing

```
┌──────────────────────────────────────────────────────┐
│ ☰ Marketing                  Campanhas Ativas: 3     │
├──────────────────────────────────────────────────────┤
│                                                      │
│  ─── Campanhas Ativas ───────────────────────────    │
│                                                      │
│  📅 Aniversariantes do mês                           │
│  │ Público: 12 clientes · Enviados: 8                │
│  │ Abertos: 6 · Convertidos: 2                       │
│  ├───────────────────────────────────────────────    │
│                                                      │
│  📅 Clientes inativos (60+ dias)                     │
│  │ Público: 23 clientes · Enviados: 23               │
│  │ Abertos: 12 · Convertidos: 4                      │
│  ├───────────────────────────────────────────────    │
│                                                      │
│  📅 Promoção Primavera                               │
│  │ Público: 45 clientes · Agendado: 01 Set           │
│  │ Status: Rascunho                                  │
│                                                      │
│  ─── Automações ─────────────────────────────────    │
│  ✅ Lembrete 24h antes              → Ativo          │
│  ✅ Confirmação de agendamento      → Ativo          │
│  ✅ Pós-atendimento (avaliação)     → Ativo          │
│  ⏳ Cliente inativo (60 dias)       → Desativado     │
│                                                      │
│  ─── Cupons Ativos ──────────────────────────────    │
│  │ Código     │ Tipo     │ Usos │ Validade          │
│  │ BEMVINDO   │ 20% off  │ 12   │ 31/12             │
│  │ INDICA200  │ R$200    │  3   │ 30/09             │
│  │ HIDRATACAO │ R$30     │  8   │ 31/08             │
└──────────────────────────────────────────────────────┘
```

#### 2.2.6 Configurações

```
┌──────────────────────────────────────────────────────┐
│ ☰ Configurações                                      │
├──────────────────────────────────────────────────────┤
│                                                      │
│  Plano: Professional         [Gerenciar Assinatura]  │
│  Próxima cobrança: 01 Set · R$ 99,90                 │
│                                                      │
│  ─── Módulos Ativos ──────────────────────────────   │
│  ✅ Núcleo do sistema         ✅ Agenda inteligente   │
│  ✅ CRM completo              ✅ Financeiro           │
│  ✅ Fidelidade                ✅ Campanhas            │
│  ✅ IA de insights            ✅ IA de memória        │
│  ❌ White label               ❌ API pública          │
│                                                      │
│  ─── Equipe ──────────────────────────────────────   │
│  │ Nome      │ Função       │ Acesso                │
│  │ Letícia   │ Admin        │ Completo              │
│  │ Carla     │ Profissional │ Agenda + Clientes     │
│  │ Mariana   │ Financeiro   │ Financeiro + Relat.   │
│                                                      │
│  ─── Integrações ────────────────────────────────    │
│  ✅ WhatsApp    │ Conectado                         │
│  ⏳ Mercado Pago│ Pendente                          │
│  ❌ Google      │ Não configurado                   │
└──────────────────────────────────────────────────────┘
```

---

## 3. Fluxos Completos

### 3.1 Novo Cliente (Aquisição)

```
Instagram/Indicação/Busca
        │
        ▼
Landing Page Personalizada
  "Sua próxima experiência começa aqui"
  [Agendar agora]
        │
        ▼
Cadastro Rápido (30s)
  Nome · WhatsApp · Email
  [Permitir notificações]
        │
        ▼
IA cria perfil inicial
  Preferências básicas
  Serviço desejado
  Primeira impressão
        │
        ▼
Escolha Profissional + Serviço
  ⭐ Bio · Fotos · Avaliações
        │
        ▼
Agenda Inteligente
  IA sugere melhores horários
        │
        ▼
Confirmação
  Lembrete automático agendado
        │
        ▼
EXP. 01 — Primeira Experiência
  Antes: Inspirações enviadas
  Durante: Profissional registra preferências
  Depois: Avaliação + Foto + IA cria memória
        │
        ▼
Pós-atendimento (Automático)
  24h: "Como foi sua experiência?"
  7 dias: "Dicas de cuidados"
  30 dias: "Hora de agendar manutenção"
  Ciclo identificado: IA aprende o retorno ideal
```

### 3.2 Ciclo de Retenção (Automático)

```
Cliente fez Coloração Premium
        │
        ▼
IA identifica retorno ideal → 45 dias
        │
        ▼
Dia 40: WhatsApp automático
  "Oi Ana, já está quase na hora de renovar sua cor.
   Seu último coloração foi há 40 dias.
   Quer agendar sua manutenção?"
        │
        ▼
Cliente agenda → Ciclo recomeça
        │
        ▼
Cliente não responde → Dia 50: Campanha de recuperação
  "Sentimos sua falta 💛 Seu cabelo merece um cuidado.
   Cupom especial: HIDRATA10 — 10% off em tratamentos."
        │
        ▼
Cliente não volta → Dia 74 (dados de churn)
  IA registra: churn_score alto
  Perfil vai para lista de recuperação
  Nova tentativa em 90 dias
```

### 3.3 Experiência Premium (Durante o Atendimento)

```
Cliente chega no estúdio
        │
        ▼
Recepção Digital
  App mostra: "Bem-vinda, Ana! ✨"
  Profissional recebe notificação: "Ana chegou"
        │
        ▼
Diagnóstico com IA
  Profissional vê no tablet:
    • Histórico completo da cliente
    • Preferências (memória IA)
    • Últimos serviços
    • Recomendações do dia
        │
        ▼
Procedimento
  Checklist de experiência steps
  Registro de fotos (antes/durante/depois)
  Anotações do profissional → alimentam ai_customer_memory
        │
        ▼
Finalização
  "Como foi sua experiência?"
  Cliente avalia (emoji + estrelas)
  Foto do resultado final
        │
        ▼
Pós-atendimento
  IA cria:
    • Resumo da experiência
    • Atualiza memória (ai_customer_memory)
    • Calcula próximo retorno ideal
    • Sugere produtos/ serviços
```

---

## 4. Design System 2026

### 4.1 Filosofia

**Luxury Wellness Tech** — a estética do cuidado sofisticado.

Referências: Apple Health, Airbnb, Soho House, Aesop, marcas premium de skincare.

### 4.2 Paleta de Cores

```yaml
colors:
  ivory: "#F7F3EE"        # Fundo — sensação de luxo, calma
  champagne: "#C9A66B"    # Detalhes premium, selos, badges
  carbon: "#161616"        # Textos principais — tecnologia
  sage: "#9AA58A"          # Natureza, cuidado, sustentabilidade
  rose_dust: "#C9A1A1"    # Feminino sutil, sem clichê
  gold: "#B89B5E"          # Ouro discreto — vitórias, conquistas
  cream: "#FAF7F2"         # Cards, superfícies elevadas
  error: "#C84B4B"         # Erro, alertas
  success: "#5A8F6F"       # Sucesso, confirmação
```

### 4.3 Tipografia

```yaml
typography:
  headings:
    font: "Canela"  # ou equivalente serif elegante
    weights: [Light, Regular, Medium]
    sizes:
      display: 48
      h1: 32
      h2: 24
      h3: 20

  body:
    font: "Inter"
    weights: [Light, Regular, Medium, Semibold]
    sizes:
      large: 18
      regular: 16
      small: 14
      caption: 12
```

### 4.4 Componentes

#### Cards

```
┌──────────────────────────────────┐
│   Card com borda suave           │
│   Elevação: none                 │
│   Border-radius: 16              │
│   Background: cream (#FAF7F2)   │
│   Padding: 20                    │
│   Sombras: suave (box-shadow)    │
└──────────────────────────────────┘
```

#### Botões

```yaml
buttons:
  primary:
    background: "carbon (#161616)"
    text: "ivory (#F7F3EE)"
    border-radius: 12
    padding: [16, 24]
    font: "Inter Semibold 16"

  secondary:
    background: "transparent"
    text: "carbon (#161616)"
    border: "1px carbon"

  ghost:
    background: "transparent"
    text: "champagne (#C9A66B)"

  cta:
    background: "linear gradient(champagne, gold)"
    text: "ivory"
    border-radius: 24
    height: 56
```

#### Navigation (Bottom Bar)

```
┌──────────────────────────────────┐
│                                  │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐   │
│  │Home│ │Agd.│ │Hist│ │Perf│   │
│  └────┘ └────┘ └────┘ └────┘   │
│                                  │
│  Ativo: Ícone preenchido +       │
│         label carbon             │
│  Inativo: Ícone outline +        │
│           label champagne        │
└──────────────────────────────────┘
```

#### Navigation (Admin Sidebar)

```yaml
sidebar:
  width: 240
  background: "carbon"
  items:
    active: "gold underline + text white"
    inactive: "text gray"
  profile_section: true
```

#### Animações

```yaml
animations:
  page_transition: "slide_up 300ms ease-out"
  card_enter: "fade_in + scale(0.98→1) 400ms"
  button_hover: "scale(1.02) 150ms"
  button_press: "scale(0.98) 100ms"
  skeleton_loader: "shimmer 1.5s infinite"
  like_animation: "heart_beat 400ms"
```

### 4.5 Micro-interações

- **Pull to refresh:** Animação suave com logo do Studio Letícia
- **Empty state:** Ilustração + "Nada aqui ainda. Que tal agendar sua primeira experiência?"
- **Loading:** Skeleton loader com cantos arredondados (cor ivory → cream pulsando)
- **Error state:** "Algo deu errado" + botão "Tentar novamente" com fade-in
- **Success toast:** ícone ✅ + mensagem, slide down, auto-dismiss 3s

---

## 5. Modelo SaaS

### 5.1 Planos e Preços

| Funcionalidade | Free | Starter | Professional | Enterprise |
|---|---|---|---|---|
| **Preço mensal** | Grátis | R$ 49,90 | R$ 99,90 | R$ 299,90 |
| **Profissionais** | 1 | 3 | 10 | Ilimitado |
| **Clientes** | 100 | 500 | 2.000 | Ilimitado |
| **Armazenamento** | 200 MB | 1 GB | 2 GB | 5 GB |
| **Agenda básica** | ✅ | ✅ | ✅ | ✅ |
| **Agenda inteligente** | ❌ | ✅ | ✅ | ✅ |
| **CRM básico** | ✅ | ✅ | ✅ | ✅ |
| **CRM avançado** | ❌ | ✅ | ✅ | ✅ |
| **Financeiro básico** | ❌ | ✅ | ✅ | ✅ |
| **Relatórios financeiros** | ❌ | ❌ | ✅ | ✅ |
| **Fidelidade** | ❌ | ❌ | ✅ | ✅ |
| **Venda de produtos** | ❌ | ❌ | ✅ | ✅ |
| **Campanhas** | ❌ | ❌ | ✅ | ✅ |
| **Cupons** | ❌ | ❌ | ✅ | ✅ |
| **Lembretes WhatsApp** | ❌ | ✅ | ✅ | ✅ |
| **Automação avançada** | ❌ | ❌ | ✅ | ✅ |
| **IA insights** | ❌ | ❌ | ✅ | ✅ |
| **IA memória** | ❌ | ❌ | ✅ | ✅ |
| **IA recomendações** | ❌ | ❌ | ❌ | ✅ |
| **API pública** | ❌ | ❌ | ❌ | ✅ |
| **White label** | ❌ | ❌ | ❌ | ✅ |
| **Suporte prioritário** | ❌ | ❌ | ❌ | ✅ |

### 5.2 Trial Flow

```
Novo usuário acessa studioleticia.com.br
        │
        ▼
Cadastro
  Nome · Email · WhatsApp · Senha
        │
        ▼
Onboarding do Estúdio
  Nome do estúdio · Endereço · Foto
  Quantos profissionais?
        │
        ▼
Escolha do Plano
  Trial 14 dias — Starter (recomendado)
  ou começar com Free
        │
        ▼
Ativação (Trial)
  subscription.status = 'trial'
  trial_end = now() + 14 days
        │
        ▼
Configuração Inicial
  Convidar profissionais
  Cadastrar serviços
  Configurar horários
  Conectar WhatsApp
        │
        ▼
Primeiro agendamento
        │
        ▼
Dia 10: "Seu trial termina em 4 dias"
Dia 14: Trial expira → downgrade para Free
        OU
        Escolhe plano → subscription.status = 'active'
```

### 5.3 Métricas de Sucesso (KPIs)

| Indicador | Meta | Medição |
|---|---|---|
| **MRR** (Monthly Recurring Revenue) | R$ 50k em 12 meses | Soma de subscriptions ativas |
| **Churn mensal** | < 5% | Cancelamentos / Total ativos |
| **LTV médio** | > R$ 1.200 | Ticket médio × tempo de retenção |
| **NPS** | > 70 | Pesquisa trimestral |
| **Ativação (Trial → Pago)** | > 20% | Conversão de trials |
| **Clientes por estúdio** | > 50 | Média de customers por tenant |
| **Agendamentos mensais** | > 100/studio | Total appointments mês |

---

## 6. Roadmap de Implementação

### Sprint 1 — Foundation (Semanas 1-2)

```
✅ Database (22 migrations)
⬜ Flutter project scaffold
⬜ Design System package (cores, tipografia, tokens)
⬜ packages/core (auth, api, database)
⬜ App shell (customer + admin)
```

### Sprint 2 — Customer App Core (Semanas 3-4)

```
⬜ Onboarding + Login
⬜ Home (hero + próximo agendamento + mensagem IA)
⬜ Agendamento (fluxo completo: serviço → horário → confirmação)
⬜ Perfil de Beleza
⬜ Histórico de experiências
```

### Sprint 3 — Admin App Core (Semanas 5-6)

```
⬜ Command Center (dashboard + KPIs + IA recomendações)
⬜ Agenda Inteligente (timeline + drag & drop)
⬜ Perfil 360º do Cliente
⬜ CRM (cadastro, busca, tags, interações)
```

### Sprint 4 — Monetização (Semanas 7-8)

```
⬜ SaaS onboarding (cadastro → trial → plano)
⬜ Checkout (Mercado Pago)
⬜ Gestão de assinatura
⬜ Feature flags por plano
⬜ Convite de profissionais
```

### Sprint 5 — IA & Automação (Semanas 9-10)

```
⬜ IA insights no Command Center
⬜ IA memory no Perfil do Cliente
⬜ Automação de notificações (Edge Functions)
⬜ Campanhas + Cupons
⬜ Lembretes WhatsApp
```

### Sprint 6 — Experiência & Polimento (Semanas 11-12)

```
⬜ Jornada do atendimento (antes/durante/depois)
⬜ Galeria de fotos (antes/depois)
⬜ Programa de fidelidade (app cliente)
⬜ Animações e micro-interações
⬜ Testes E2E
⬜ Beta fechado
```

---

## 7. Dicionário de Telas (para devs)

### Customer App

| Tela | Rota | Widgets Principais | Dados |
|---|---|---|---|
| Splash | `/` | Logo animado, fade-in | — |
| Onboarding | `/onboarding` | PageView, 3 steps, CTA | — |
| Home | `/home` | HeroImage, NextAppointmentCard, BenefitCard, BottomNav | appointments, customers, ai_memory |
| Agendar | `/book` | StepIndicator, ProfessionalSelector, ServicePicker, Calendar, TimeSlots | services, professionals, appointments |
| Confirmação | `/confirm` | SuccessAnimation, AppointmentCard, ShareButton | appointment |
| Perfil Beleza | `/profile` | Avatar, PreferenceList, MemoryCard, PhotoGrid | customer, ai_customer_memory |
| Histórico | `/history` | TimelineList, FilterChips | appointments, customer_experiences |
| Benefícios | `/benefits` | PointsCard, TierCard, RewardList | loyalty_accounts, loyalty_rewards |

### Admin App

| Tela | Rota | Widgets Principais | Dados |
|---|---|---|---|
| Login | `/login` | EmailInput, PasswordInput, MagicLink | auth |
| Command Center | `/admin` | KPIcards, IARecommendationCard, AgendaTimeline, MetricChart | appointments, customers, ai_insights, financial |
| Agenda | `/admin/schedule` | DayTimeline, AppointmentCard, DragHandle | appointments, professionals |
| Perfil Cliente | `/admin/customer/:id` | ProfileHeader, MemorySection, HistoryTable, ActionButtons | customers, ai_memory, appointments |
| Financeiro | `/admin/finances` | RevenueChart, CommissionTable, CashRegisterCard | financial_transactions, commission_entries |
| Marketing | `/admin/marketing` | CampaignList, AutomationToggle, CouponTable | campaigns, automation_rules, coupons |
| Produtos | `/admin/products` | ProductGrid, InventoryAlert, StockInput | products, inventory_movements |
| Configurações | `/admin/settings` | PlanCard, ModuleList, TeamTable, IntegrationList | saas_plans, subscriptions, staff |

---

## 8. Estrutura Flutter Planejada

```
apps/
├── customer_app/                  # App cliente (Android + iOS)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── modules/
│   │   │   ├── home/
│   │   │   ├── booking/
│   │   │   ├── profile/
│   │   │   ├── history/
│   │   │   └── benefits/
│   │   └── core/
│   └── pubspec.yaml
│
├── admin_app/                     # App administrativo (Web)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── modules/
│   │   │   ├── dashboard/
│   │   │   ├── schedule/
│   │   │   ├── customers/
│   │   │   ├── finances/
│   │   │   ├── marketing/
│   │   │   ├── products/
│   │   │   └── settings/
│   │   └── core/
│   └── pubspec.yaml
│
└── packages/
    ├── design_system/             # Tokens, components, animations
    │   ├── lib/
    │   │   ├── tokens/
    │   │   │   ├── colors.dart
    │   │   │   ├── typography.dart
    │   │   │   ├── spacing.dart
    │   │   │   └── animation.dart
    │   │   ├── components/
    │   │   │   ├── cards/
    │   │   │   ├── buttons/
    │   │   │   ├── inputs/
    │   │   │   ├── navigation/
    │   │   │   ├── feedback/
    │   │   │   └── layout/
    │   │   └── theme.dart
    │   └── pubspec.yaml
    │
    ├── core/                      # Auth, API, database, models
    │   ├── lib/
    │   │   ├── auth/
    │   │   ├── api/
    │   │   ├── database/
    │   │   ├── models/
    │   │   └── utils/
    │   └── pubspec.yaml
    │
    ├── customer_models/           # Modelos específicos do app cliente
    │   ├── lib/
    │   │   ├── experience.dart
    │   │   └── ...
    │   └── pubspec.yaml
    │
    └── admin_models/              # Modelos específicos do admin
        ├── lib/
        │   ├── dashboard.dart
        │   └── ...
        └── pubspec.yaml
```

---

## 9. Considerações de Design

### O que EVITAR

- ❌ Rosa choque, rosa bebê — remete a "salão tradicional"
- ❌ Ícones genéricos de beleza (tesoura, pente)
- ❌ Fonte cursiva ou decorativa demais
- ❌ Cards com bordas coloridas exageradas
- ❌ Animações lentas ou desnecessárias
- ❌ "Agenda" como termo principal no app cliente

### O que PRIORIZAR

- ✅ Fotos de alta qualidade (hero images)
- ✅ Espaçamento generoso (whitespace = luxo)
- ✅ Tipografia serif para títulos (sofisticação)
- ✅ Micro-animações suaves (delicadeza)
- ✅ Tons neutros com detalhes dourados/champagne
- ✅ "Experiência" como palavra-chave, não "agenda"
- ✅ Cards com cantos arredondados (16px)
- ✅ Skeleton loading elegante (sem spinners genéricos)

---

## 10. Próximos Passos

Com este Blueprint validado:

1. **Wireframes navegáveis** — transformar as telas descritas aqui em wireframes de alta fidelidade (Figma ou equivalente)
2. **Design System package** — implementar tokens e componentes no Flutter (packages/design_system)
3. **Sprint 1 Foundation** — scaffold dos apps + packages/core
4. **Sprint 2 Customer App** — implementar Home + Agendamento
5. **Beta fechado** — 5 estúdios reais para validar fluxos
