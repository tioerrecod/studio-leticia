---
id: sl-design-system
title: "Studio Letícia Experience — Design System v1.0"
version: "1.0.0"
status: "architecture"
owner: "Design Lead"
depends_on: ["sl-architecture"]
last_review: "2026-07-13"
next_review: "2026-10-13"
---

# DESIGN SYSTEM — Studio Letícia Experience v1.0

**Propósito**: Definir a identidade visual e os componentes que fazem o Studio Letícia parecer uma marca de beleza premium — não um sistema de gestão.

---

## 1. Princípios de Design

1. **Elegância minimalista** — Cada elemento tem um propósito. Nada é decorativo.
2. **Emotional first** — A sensação importa mais que a funcionalidade. Uma tela de agendamento deve ser prazerosa de usar.
3. **Fotografia como protagonista** — Imagens do salão, profissionais e serviços ocupam espaço de destaque.
4. **Toque humano** — Curvas suaves, cantos arredondados, micro-animações que respondem ao toque.
5. **Consistência de marca** — Em cada pixel, o Studio Letícia parece o mesmo produto.

---

## 2. Tokens de Design

### 2.1 Cores

```dart
// lib/shared/design/colors.dart

class SLColors {
  // Primária — ações, badges, destaques
  static const primary = Color(0xFFD81B60);       // Rosa
  static const primaryLight = Color(0xFFFF5C8A);  // Rosa claro (hover)
  static const primaryDark = Color(0xFFA00037);    // Rosa escuro (pressed)

  // Secundária — fidelidade, premium, badges
  static const secondary = Color(0xFFFFB300);      // Dourado
  static const secondaryLight = Color(0xFFFFE54C); // Dourado claro
  static const secondaryDark = Color(0xFFC68400);   // Dourado escuro

  // Neutros — fundos e superfícies
  static const background = Color(0xFFF5F0EB);     // Off-white — sensação de papel
  static const surface = Color(0xFFFFFFFF);         // Branco
  static const surfaceVariant = Color(0xFFF8F4F0);  // Bege claro (cards alternados)
  static const divider = Color(0xFFE8E0D8);         // Linhas sutis

  // Texto
  static const textPrimary = Color(0xFF1A1A1A);     // Quase preto
  static const textSecondary = Color(0xFF8C8C8C);   // Cinza médio
  static const textDisabled = Color(0xFFC4C4C4);    // Cinza claro
  static const textOnPrimary = Color(0xFFFFFFFF);   // Branco sobre rosa
  static const textOnSecondary = Color(0xFF1A1A1A); // Preto sobre dourado

  // Semântica
  static const success = Color(0xFF2E7D32);         // Verde
  static const error = Color(0xFFC62828);           // Vermelho
  static const warning = Color(0xFFF57C00);         // Laranja
  static const info = Color(0xFF1565C0);            // Azul

  // Status (para appointment)
  static const statusScheduled = Color(0xFF1565C0);  // Azul
  static const statusConfirmed = Color(0xFF2E7D32);  // Verde
  static const statusInProgress = Color(0xFFF57C00); // Laranja
  static const statusCompleted = Color(0xFF2E7D32);  // Verde
  static const statusCancelled = Color(0xFFC62828);  // Vermelho
  static const statusNoShow = Color(0xFF8C8C8C);     // Cinza
}
```

### 2.2 Tipografia

```dart
class SLTypography {
  // Títulos — Playfair Display (serifada, elegante)
  static const displayLarge = TextStyle(
    fontFamily: 'Playfair Display',
    fontWeight: FontWeight.w700, // Bold
    fontSize: 32,
    height: 1.2,
    letterSpacing: -0.5,
  );
  static const displayMedium = TextStyle(
    fontFamily: 'Playfair Display',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.3,
    letterSpacing: -0.3,
  );
  static const displaySmall = TextStyle(
    fontFamily: 'Playfair Display',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.3,
  );

  // Corpo — Inter (sans-serif, legível)
  static const bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );
  static const bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
  );
  static const bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.4,
  );

  // Números — Inter Semibold (monospace opcional)
  static const numberLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 28,
    height: 1.2,
    letterSpacing: -0.5,
  );
  static const numberMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.3,
  );

  // Labels — Inter Medium
  static const labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.5,
  );
  static const labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 11,
    letterSpacing: 0.5,
  );
}
```

### 2.3 Espaçamento

```dart
class SLSpacing {
  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}
```

### 2.4 Border Radius

```dart
class SLRadius {
  static const double sm = 8;   // Cards, inputs
  static const double md = 12;  // Modals, sheets
  static const double lg = 16;  // Bottom sheets
  static const double xl = 24;  // FAB, avatars
  static const double full = 999; // Pill buttons, chips
}
```

### 2.5 Elevação (Sombras)

```dart
class SLElevation {
  static const double none = 0;
  static const double sm = 1;    // Cards em lista
  static const double md = 2;    // Bottom bar
  static const double lg = 4;    // Modal, sheet
  static const double xl = 8;    // FAB, snackbar
}
```

### 2.6 Animações

```dart
class SLAnimation {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOutCubic;
  static const Curve spring = Curves.fastOutSlowIn;
}
```

---

## 3. Componentes

### 3.1 Cards

```dart
// Card de Serviço
┌─────────────────────────────────────┐
│  ┌──────────┐                       │
│  │   Foto   │  Corte Feminino       │
│  │  Serviço │  R$ 80,00 · 45min    │
│  └──────────┘  ★ 4.8 (120)         │
└─────────────────────────────────────┘

// Card de Profissional
┌─────────────────────────────────────┐
│ ┌─────┐                             │
│ │     │  Carla Santos               │
│ │ Foto│  Cabelereira · ★ 4.9       │
│ └─────┘  "Especialista em mechas"  │
└─────────────────────────────────────┘

// Card de Agendamento (timeline)
┌─────────────────────────────────────┐
│  10:00  ●●●●●○○○○○                  │
│  Corte + Escova     Em andamento    │
│  Carla · R$ 120,00                  │
└─────────────────────────────────────┘
```

### 3.2 Bottom Sheet (Agendamento)

```
┌─────────────────────────────────────┐
│              ───                     │
│                                      │
│  Confirmar Agendamento              │
│                                      │
│  ┌───────────────────────────────┐  │
│  │ Serviço: Corte Feminino       │  │
│  │ Profissional: Carla Santos    │  │
│  │ Data: 15/07/2026              │  │
│  │ Horário: 10:00                │  │
│  │ Valor: R$ 80,00               │  │
│  └───────────────────────────────┘  │
│                                      │
│  [  Confirmar Agendamento  ]        │
│                                      │
│  Ao confirmar, você receberá um     │
│  lembrete 24h antes do horário.     │
│                                      │
│  Cancelamento grátis até 4h antes.  │
└─────────────────────────────────────┘
```

### 3.3 Bottom Navigation

```dart
// Customer App
[Início] [Serviços] [Agenda] [Perfil]

// Professional App
[Agenda] [Comissão] [Perfil]

// Admin Web (sidebar)
[Dashboard] [Agenda] [Clientes] [Profissionais]
[Serviços] [Financeiro] [Relatórios] [Configurações]
```

### 3.4 Empty States

```dart
// Nenhum agendamento hoje
┌─────────────────────────────────────┐
│                                     │
│         ☀️                          │
//   Nenhum agendamento hoje         │
│                                     │
│   Seu dia está livre!               │
│                                     │
│  [Compartilhar link de agenda]     │
│                                     │
└─────────────────────────────────────┘

// Nenhum cliente encontrado
┌─────────────────────────────────────┐
│                                     │
│         🔍                          │
//   Nenhum cliente encontrado       │
│                                     │
│   Tente buscar por nome ou          │
│   telefone                          │
│                                     │
└─────────────────────────────────────┘
```

### 3.5 Loading States

```dart
// Skeleton para timeline
┌─────────────────────────────────────┐
│  ━━━━━━━━━━━━━━━━━━━━━━━━           │
│  ━━━━━━━━━    ━━━━━━━━━             │
│                                      │
│  ━━━━━━━━━━━━━━━━━━━━━━━━           │
│  ━━━━━━━━━    ━━━━━━━━━             │
│                                      │
│  ━━━━━━━━━━━━━━━━━━━━━━━━           │
│  ━━━━━━━━━    ━━━━━━━━━             │
└─────────────────────────────────────┘

// Shimmer sutil nas bordas, cor do background variante
// Duração: 1.5s, loop infinito
```

### 3.6 Error States

```dart
// Falha ao carregar
┌─────────────────────────────────────┐
│                                     │
│         ⚠️                          │
//   Não foi possível carregar       │
│                                     │
│   Verifique sua conexão e tente     │
│   novamente                         │
│                                     │
│  [Tentar novamente]                 │
│                                     │
└─────────────────────────────────────┘
```

---

## 4. Micro-animações

### 4.1 Transições de Tela

- Push navigation: slide da direita, 300ms, easeOutCubic
- Modal/bottom sheet: slide de baixo, 300ms, easeOutCubic
- Tab switch: cross-fade, 200ms, easeInOut
- Dialog: scale (0.95 → 1.0) + fade, 200ms, spring

### 4.2 Micro-interações

| Elemento | Ação | Animação |
|---|---|---|
| Botão primário | Tap | Scale 1.0 → 0.97 → 1.0 (100ms spring) |
| Card de serviço | Tap | Elevation sm → md (150ms) |
| Card de profissional | Tap | Scale 1.0 → 0.98 (100ms) |
| Checkbox | Tap | Scale + fade check (200ms spring) |
| Pull to refresh | Pull | Loading spinner + haptic feedback |
| Like/favorito | Tap | Heart animation + scale (300ms spring) |
| Agendamento concluído | Trigger | Confetti sutil (500ms) |
| Erro | Trigger | Shake horizontal (300ms) |
| Notificação | Recebida | Slide down from top (300ms) |

### 4.3 Página do Salão (Landing)

```
Ao carregar:
1. Logo fade in (400ms)
2. Foto principal fade in (500ms)
3. Serviços slide up em stagger (100ms cada)
4. Profissionais fade in em stagger (150ms cada)

Sensação: "Entrando em um salão premium"
```

---

## 5. Layout Patterns

### 5.1 Timeline do Profissional

```
┌─────────────────────────────────────┐
│  Hoje, 15 Julho           🔔 ⚙️    │
├─────────────────────────────────────┤
│  09:00 ─────────────────────────────│
│  ● ● ● ● ● ○ ○ ○ ○ ○                │
│                                      │
│  10:00 ┌────────────────────────┐   │
│         │ Corte + Escova        │   │
│         │ Maria Silva           │   │
│         │ R$ 120,00 │ Em andamento ││
│         └────────────────────────┘   │
│                                      │
│  11:30 ┌────────────────────────┐   │
│         │ Escova Progressiva    │   │
│         │ Ana Costa             │   │
│         │ Confirmado            │   │
│         └────────────────────────┘   │
│                                      │
│  13:00 ──── Almoço ─────────────   │
│                                      │
│  14:00 ┌────────────────────────┐   │
│         │ Manicure              │   │
│         │ Juliana Lima          │   │
│         │ Pendente confirmação  │   │
│         └────────────────────────┘   │
└─────────────────────────────────────┘
```

### 5.2 Dashboard do Dono

```
┌─────────────────────────────────────┐
│  Studio Letícia   15/07/2026     ⚙️ │
├─────────────────────────────────────┤
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │  08  │ │  06  │ │R$1.2k│        │
│  │Agenda│ │Realiz│ │Fatura│        │
│  │  dos │ │ ados │ │mento │        │
│  └──────┘ └──────┘ └──────┘        │
│                                      │
│  Faturamento x Ontem: +12% ▲       │
│                                      │
│  ┌────────────────────────────────┐ │
│  │  Profissional do dia           │ │
│  │  Carla · 3 serviços · R$320   │ │
│  └────────────────────────────────┘ │
│                                      │
│  ├─ Agenda ──┤                       │
│  09:00 Corte ● (Maria)              │
│  10:00 Escova ● (Ana) ← atrasada   │
│  11:00 Luzes ● (Julia)             │
│  14:00 Corte ● (Pedro)             │
│  15:00 Manicure ● (Carla)          │
└─────────────────────────────────────┘
```

---

## 6. Responsividade

### 6.1 Breakpoints

| Breakpoint | Largura | Layout |
|---|---|---|
| Mobile | 320-599px | Single column, bottom nav |
| Tablet | 600-1023px | Multi-column, rail navigation |
| Desktop | 1024px+ | Sidebar, grid layouts |

### 6.2 Admin Web (Desktop)

```
┌──────┬──────────────────────────────────┐
│      │                                   │
│ Logo │  Dashboard                        │
│      │                                   │
│ 🏠   │  ┌──────┐ ┌──────┐ ┌──────┐     │
│ Dash │  │  08  │ │  06  │ │R$1.2k│     │
│      │  └──────┘ └──────┘ └──────┘     │
│ 📅   │                                   │
│ Agenda│  ┌──────────────────────────┐    │
│      │  │ Gráfico da semana        │    │
│ 👥   │  └──────────────────────────┘    │
│Clientes│                                 │
│      │  ┌────┬────┬────┬────┬────┐     │
│ 💇   │  │Seg │Ter │Qua │Qui │Sex │     │
│Serviços│  ├────┼────┼────┼────┼────┤     │
│      │  │R$1k│R$1k│R$1k│R$1k│R$1k│     │
│ 💰   │  └────┴────┴────┴────┴────┘     │
│Finance||                                 │
│      │  Últimas vendas                  │
│ 📊   │  [Tabela de transações]          │
│Relat.│                                   │
│      │                                   │
│ ⚙️   │                                   │
│Config│                                   │
└──────┴──────────────────────────────────┘
```

---

## 7. Ilustrações e Ícones

### 7.1 Estilo

- **Ícones**: Material Symbols (preenchidos) — consistentes, modernos, reconhecíveis
- **Ilustrações**: Undraw-style ou custom — traços finos, paleta do Studio Letícia
- **Fotografia**: Prioridade máxima — imagens reais do salão e profissionais
- **Avatar**: Fotos circulares com borda de 2px primary se for destaque

### 7.2 Ícones por Contexto

| Contexto | Ícone |
|---|---|
| Agendamento | `calendar_month` |
| Serviços | `content_cut` |
| Profissionais | `groups` |
| Clientes | `people` |
| Financeiro | `payments` |
| Comissão | `account_balance_wallet` |
| Fidelidade | `cards` |
| Notificações | `notifications` |
| Configurações | `settings` |
| Dashboard | `dashboard` |

---

## 8. Acessibilidade

- Contraste mínimo 4.5:1 para texto normal, 3:1 para texto grande
- Touch targets mínimos de 44x44dp
- Suporte a Dynamic Type / font scaling
- Suporte a leitores de tela (Semantics em Flutter)
- Dark mode previsto para v2

---

## Approval

| Role | Name | Date |
|---|---|---|
| Design Lead | | |
| Product Owner | Raffa | |
| Chief Architect | Eddie | |

---

**DESIGN SYSTEM v1.0 — Studio Letícia Experience**
*Framework: BBOP v1.0 | Plataforma: FUTURECOD DPES*
