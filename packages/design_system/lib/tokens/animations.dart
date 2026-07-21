import 'package:flutter/material.dart';

class SLAnimations {
  SLAnimations._();

  // ══════════════════════════════════════════════════════════
  // STUDIO LETÍCIA 3.0 — MOTION TOKENS
  // ══════════════════════════════════════════════════════════

  // ── Durations (Spec Part 07) ────────────────────────────
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration fade = Duration(milliseconds: 200);
  static const Duration scale = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration hero = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);

  // ── Legacy alias ────────────────────────────────────────
  static const Duration normal = medium;

  // ── Easing Curves ────────────────────────────────────────
  static const Curve easingStandard = Curves.easeInOutCubic;
  static const Curve easingEmphasized = Curves.easeOutBack;
}
