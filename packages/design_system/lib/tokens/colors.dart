import 'package:flutter/material.dart';

class SLColors {
  SLColors._();

  // ══════════════════════════════════════════════════════════════
  // STUDIO LETÍCIA 3.0 — BEIGE & GOLD
  // ──────────────────────────────────────────────────────────────
  // Fundo    → Bege quente (#F5EFE6) — acolhimento, ateliê
  // Carvão   → Contraste de marca (#1C1815) — exclusividade
  // Dourado  → Luxo discreto (#C9A05C) — old money, confiança
  // ══════════════════════════════════════════════════════════════

  // ── Background ──────────────────────────────────────────
  static const Color background = Color(0xFFF5EFE6);
  static const Color bgPrimary = Color(0xFFF5EFE6);
  static const Color bgSecondary = Color(0xFFEDE3D3);
  static const Color bgInverse = Color(0xFF1C1815);

  // ── Surfaces ───────────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEDE3D3);
  static const Color surfaceCardDark = Color(0xFF2A2420);
  static const Color divider = Color(0xFFE3D8C4);

  // ── Accent — Gold ──────────────────────────────────────
  static const Color accentGold = Color(0xFFC9A05C);
  static const Color accentGoldDark = Color(0xFFA9803F);
  static const Color accentGoldLight = Color(0xFFE8D5AF);

  // ── Backward-compatible aliases ────────────────────────
  static const Color champagne = accentGold;
  static const Color gold = accentGoldLight;
  static const Color cream = bgSecondary;

  // ── Neutral ────────────────────────────────────────────
  static const Color textOnDark = Color(0xFFF5EFE6);

  // ═══ DEPRECATED — kept for migration, will remove ══════
  // carbon was light#F5F0E8 → now dark#1C1815
  // ivory was #F5F0E8 → now bgPrimary
  static const Color carbon = Color(0xFF1C1815);
  static const Color ivory = Color(0xFFF5EFE6);
  static const Color sage = Color(0xFF5A7D5A);

  // ── Text ───────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1C1815);
  static const Color textSecondary = Color(0xFF6B6154);
  static const Color textDisabled = Color(0xFFA39D94);
  static const Color textInverse = Color(0xFFF5EFE6);
  static const Color textOnPrimary = Color(0xFFF5EFE6);
  static const Color textOnSecondary = Color(0xFF1C1815);
  static const Color textOnGold = Color(0xFF1C1815);

  // ── Borders ────────────────────────────────────────────
  static const Color border = Color(0xFFE3D8C4);
  static const Color borderSubtle = Color(0xFFE3D8C4);
  static const Color borderFocus = Color(0xFFC9A05C);

  // ── Semantic ───────────────────────────────────────────
  static const Color stateSuccess = Color(0xFF5A7D5A);
  static const Color stateError = Color(0xFFB05A4A);
  static const Color stateWarning = Color(0xFFC99A4A);
  static const Color stateInfo = Color(0xFF5C7A8A);

  // ── Backward-compatible semantic aliases ───────────────
  static const Color success = stateSuccess;
  static const Color error = stateError;
  static const Color warning = stateWarning;
  static const Color info = stateInfo;

  // ── Disabled ───────────────────────────────────────────
  static const Color disabled = Color(0xFFA39D94);
}
