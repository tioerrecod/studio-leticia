# Studio Letícia — App de Beleza e Agendamento

## Visão Geral
Aplicativo Flutter Web progressivo (PWA) para um estúdio de beleza premium. O app permite que clientes vejam serviços, agendem horários, acompanhem o histórico de visitas, acumulem pontos de fidelidade, e recebam recomendações personalizadas por IA.

**Stack:** Flutter 3.x, Dart, Riverpod (estado), GoRouter (navegação), Design System próprio.

---

## Identidade Visual (BOS v2 — Absolute Black Foundation)

### Paleta de Cores
```dart
// Fundo — ABSOLUTE BLACK
background = #000000      // Fundo geral preto absoluto
surface    = #0D0D0D      // Cards, superfícies elevadas
surfaceVariant = #1A1A1A  // Campos, áreas secundárias
divider    = #2A2A2A      // Bordas, linhas divisórias

// Primária — AUTORIDADE
primary    = #1A1A1A      // Preto estrutural para headers
primaryDark = #0D0D0D     // Variação mais escura

// Secundária — LUXO (Dourado)
secondary     = #D4A843   // Ouro: CTAs, badges, destaques
secondaryLight = #E2BC6A  // Ouro claro: brilho
secondaryDark  = #B89238  // Ouro escuro

// Terciária — BELEZA (Rose Gold)
tertiary     = #C4757A    // Acentos femininos
tertiaryLight = #D99499
tertiaryDark  = #A85A5F

// Texto — OFF-WHITE QUENTE
textPrimary   = #F5F0E8   // Corpo principal
textSecondary = #A39D94   // Subtítulos, metadados
textDisabled  = #6E6A64   // Placeholder, desabilitado
textOnDark    = #F5F0E8   // Texto em fundo escuro
textOnSecondary = #1A1A1A // Texto em fundo dourado

// Semântica
success = #66BB6A   // Verde
error   = #E53935   // Vermelho
warning = #FFA726   // Laranja
info    = #42A5F5   // Azul

// Aliases (compatibilidade com versão anterior)
champagne = secondary   // #D4A843
gold      = secondaryLight
carbon    = textPrimary
ivory     = textPrimary
cream     = surfaceVariant
```

### Gradientes
- **secondaryGradient:** `#D4A843 → #E2BC6A` (dourado) — usado em CTAs, badges, botões principais
- **primaryGradient:** `#1A1A1A → #2D2D2D` — usado em cards premium
- **darkGradient:** `#000000 → #0D0D0D` — headers e nav bars
- **tertiaryGradient:** `#C4757A → #D99499` — selos premium

### Tipografia
- **Playfair Display** (serifada, elegante): `displayLarge(32px)`, `displayMedium(24px)`, `displaySmall(20px)`
  - Usada para títulos: `h1`, `h2`, `h3`, `display`
- **Inter** (sans-serif, legível): `bodyLarge(16px)`, `bodyMedium(14px)`, `bodySmall(12px)`
  - Usada para corpo, labels, captions, botões

### Espaçamento
```dart
mini=4, xs=8, sm=12, md=16, lg=24, xl=32, xxl=48, xxxl=64, huge=96
```

### Raios (BorderRadius)
- `input=8px`, `chip=20px`, `card=16px`, `button=14px`, `sheet=24px`

### Sombras
- `subtle`: opacidade 0.04, blur 8px
- `elevated`: opacidade 0.08, blur 20px (cards elevados)
- `button`: opacidade 0.20, blur 16px (botões)

### Animações
- `instant=100ms`, `fast=200ms`, `normal=300ms`, `slow=500ms`
- Curvas: `easeInOut`, `easeOutCubic`, `spring(elasticOut)`

---

## Fluxo de Navegação

```
/ (SplashScreen) ──(2.5s)──> /onboarding ──(3 páginas)──> /home
                                                              │
                    ┌─────────────────────────────────────────┤
                    │                                         │
              [Home tab]  [Agendar tab]  [Jornada tab]  [Perfil tab]
               /home       /services      /history       /profile
                              │               │
                           /services/book  /history/journey
                           /services/confirm
```

### Splash (`/`)
- Animação fade-in + slide-up com logo (ícone spa + "Studio Letícia")
- Navega automaticamente ao onboarding após 2.5s

### Onboarding (`/onboarding`)
- 3 páginas estilo carrossel:
  1. "Sua jornada de beleza" 💎
  2. "Inteligência que te conhece" 🧠
  3. "Pronta para brilhar?" ✨
- Indicadores de página (bolinhas animadas)
- Botão "Pular" → vai direto ao home
- Botão "Continuar"/"Começar" com gradiente dourado

### Home (`/home`)
- **Hero:** Banner grande (520px) com gradiente escuro, frase "Sua beleza, nossa história" e CTA "Agendar experiência"
- **Próximo Atendimento:** Card com horário, nome do cliente, serviço, selo "Confirmar presença" (se houver) OU card vazio convidando a agendar
- **Assistente IA:** Card com recomendação personalizada (ex: "Baseado no seu perfil, recomendamos...")
- **Lista de Serviços:** Cards horizontais com ícone, nome, descrição, duração, preço, selo "Signature"
- **Fidelidade:** Card escuro com gradiente, pontos acumulados, visitas, indicador de progresso

### Serviços (`/services`)
- AppBar "Serviços"
- Lista completa de serviços (mesmo card do home)
- **Serviços disponíveis:**
  1. Corte Personalizado — 60min — R$ 180 — *Signature*
  2. Hidratação Premium — 90min — R$ 250
  3. Escova Modeladora — 45min — R$ 120
  4. Spa Capilar Experiência — 120min — R$ 350 — *Signature*
  5. Coloração + Corte — 150min — R$ 420

### Agendamento (`/services/book?service=:id`)
- Card com info do serviço selecionado
- **Seleção de Profissional:** Lista horizontal (Letícia, Camila, Ana) com avatar circular e animação de seleção
- **Horários:** Wrap de horários disponíveis (09:00 às 17:00)
- **Observações:** Campo de texto multilinha
- **Botão "Confirmar agendamento":** Desabilitado até selecionar profissional + horário

### Confirmação (`/services/confirm`)
- Animação de sucesso (check circular com escala elástica)
- **Resumo do agendamento:** Data, horário, serviço, profissional, pontos ganhos
- Aviso: "Enviaremos um lembrete 24h antes pelo WhatsApp"
- Botão "Voltar ao início"

### Histórico / Jornada (`/history`)
- AppBar "Minha Jornada"
- Lista de atendimentos passados com:
  - Data (dia + mês)
  - Linha vertical decorativa
  - Nome do serviço, profissional, ano, preço, avaliação (estrelas)
- Se vazio: EmptyState com CTA "Agendar agora"
- Dados mock: 5 entradas (jun, mai, abr, mar 2026)

### Perfil (`/profile`)
- **Avatar:** Círculo com borda dourada, ícone person
- **Nome:** Rafaela (mock)
- **Info:** "Cliente desde junho 2025 · 12 visitas"
- **Card Fidelidade:** Gradiente escuro, badge "OURO", 340pts, barra de progresso (68%), visitas/gasto/indicações
- **Meu Estilo:** Preferências (tipo de cabelo, coloração, produtos, frequência)
- **Minha Memória (IA):** Timeline com memórias do cliente (preferências, eventos, alergias)
- **Minhas Fotos:** Grid 3 colunas com placeholders

### Experiência (`/history/journey`)
- **Antes:** Checklist (WhatsApp confirmado, inspirações enviadas, lembrete)
- **Durante:** Stepper de etapas (Recepção → Diagnóstico → Procedimento → Finalização) com indicadores visuais
- **Depois:** Avaliação com escala de emojis (😞😐🙂😊🤩) + botão "Registrar avaliação"

### Navegação Inferior
- 4 tabs fixas: Inicio, Agendar, Jornada, Perfil
- Ícones outlined/ filled alternam conforme seleção
- Cor ativa: dourado (#D4A843), inativa: texto desabilitado

---

## Funcionalidades Atuais

### Implementado (com dados mock)
- [x] Splash com animação de entrada
- [x] Onboarding em 3 etapas
- [x] Home com hero, próximo atendimento, assistente IA, serviços, fidelidade
- [x] Listagem de serviços
- [x] Fluxo de agendamento (selecionar serviço → profissional → horário → confirmar)
- [x] Tela de confirmação com animação de sucesso
- [x] Histórico de atendimentos
- [x] Perfil do cliente com preferências
- [x] Timeline de memórias IA
- [x] Avaliação pós-atendimento com emojis
- [x] Cards de fidelidade com pontos e progresso
- [x] Bottom navigation com 4 tabs

### Não Implementado (próximos passos)
- [ ] Supabase (auth + banco real)
- [ ] Login/Cadastro
- [ ] Upload de fotos reais
- [ ] Integração Mercado Pago
- [ ] Motor de comissão para profissionais
- [ ] Admin Web
- [ ] Notificações push
- [ ] Dados dinâmicos (atualmente tudo mock)

---

## Arquitetura de Código

```
studio_leticia/
├── lib/
│   ├── main.dart                    # Entry point, tema global
│   ├── router.dart                  # Configuração GoRouter
│   ├── providers/
│   │   └── providers.dart           # Models + Providers Riverpod + Mock data
│   └── screens/
│       ├── splash/
│       │   └── splash_screen.dart
│       ├── onboarding/
│       │   └── onboarding_screen.dart
│       ├── home/
│       │   ├── home_shell.dart      # Scaffold + BottomNav
│       │   └── home_screen.dart     # Conteúdo do Home
│       ├── booking/
│       │   ├── services_screen.dart
│       │   ├── booking_screen.dart
│       │   └── confirmation_screen.dart
│       ├── history/
│       │   └── history_screen.dart
│       ├── journey/
│       │   └── journey_screen.dart
│       └── profile/
│           └── profile_screen.dart
├── design_system/
│   └── lib/
│       ├── design_system.dart       # Barrel export
│       └── src/
│           ├── colors.dart          # SLColors
│           ├── typography.dart      # SLTypography
│           ├── spacing.dart         # SLSpacing
│           ├── radius.dart          # SLRadius
│           ├── shadows.dart         # SLShadows
│           ├── animations.dart      # SLAnimations
│           └── widgets/
│               ├── hero_experience.dart
│               ├── appointment_card.dart
│               ├── ai_concierge_card.dart
│               ├── service_showcase.dart
│               ├── customer_bottom_nav.dart
│               ├── success_animation.dart
│               ├── client_memory_timeline.dart
│               └── empty_state.dart
└── pubspec.yaml
```

---

## Estado Atual do Projeto
- **SDK:** Flutter >=3.0.0 <4.0.0
- **Build web:** OK (~94s)
- **Analyze:** 0 errors, 0 warnings, 15 info (prefer_const em padrões DecoratedBox+ElevatedButton que não podem ser const devido a callbacks runtime)
- **Design System:** Alinhado ao BOS v2.0 com Absolute Black Foundation
- **Dependências:** flutter, flutter_riverpod, go_router, google_fonts, design_system (local)
- **Git:** Commit 4cb97b7 (pronto para reverter se necessário)
