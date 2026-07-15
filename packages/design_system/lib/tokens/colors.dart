import 'package:flutter/material.dart';

class SLColors {
  SLColors._();

  // ══════════════════════════════════════════════════════════════
  // PALETA PREMIUM — ABSOLUTE BLACK FOUNDATION
  // ──────────────────────────────────────────────────────────────
  // Fundo   → Preto absoluto (#000000) — autoridade máxima
  // Dourado → Luxo silencioso, prestígio, excelência
  // Off-white → Autenticidade, pureza quente, elegância
  // Rose Gold → Beleza feminina, sofisticação íntima
  // Sage     → Natureza, equilíbrio, calma
  // ══════════════════════════════════════════════════════════════

  // ── Fundo — ABSOLUTE BLACK ──
  static const Color background = Color(0xFF000000);

  // ── Superfícies — hierarquia sem quebrar o preto ──
  static const Color surface = Color(0xFF0D0D0D);
  static const Color surfaceVariant = Color(0xFF1A1A1A);
  static const Color divider = Color(0xFF2A2A2A);

  // ── Primary — AUTORIDADE / AUTENTICIDADE ──
  static const Color champagne = Color(0xFFD4A843);
  static const Color gold = Color(0xFFE2BC6A);
  static const Color cream = Color(0xFF1A1A1A);

  // ── Neutrals ─────────────────────────────────────────
  static const Color ivory = Color(0xFFF5F0E8);
  static const Color carbon = Color(0xFFF5F0E8);
  static const Color sage = Color(0xFF66BB6A);

  // ── Text — claros para contraste no preto ──
  static const Color textPrimary = Color(0xFFF5F0E8);
  static const Color textSecondary = Color(0xFFA39D94);
  static const Color textDisabled = Color(0xFF6E6A64);
  static const Color textOnDark = Color(0xFFF5F0E8);
  static const Color textOnPrimary = Color(0xFFF5F0E8);
  static const Color textOnSecondary = Color(0xFF1A1A1A);

  // ── Borders ──────────────────────────────────────────
  static const Color border = Color(0xFF2E2E2E);

  // ── Semantic — contrastantes no preto ──
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF42A5F5);
  static const Color warning = Color(0xFFFFA726);

  // ── Disabled ─────────────────────────────────────────
  static const Color disabled = Color(0xFF6E6A64);
}
