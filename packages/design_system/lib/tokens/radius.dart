import 'package:flutter/material.dart';

class SLRadius {
  SLRadius._();

  // ══════════════════════════════════════════════════════════
  // STUDIO LETÍCIA 3.0 — RADIUS SCALE
  // ══════════════════════════════════════════════════════════

  // New scale — semantic naming (Spec Part 06)
  static const BorderRadius xs = BorderRadius.all(Radius.circular(6));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(12));
  static const BorderRadius md = BorderRadius.all(Radius.circular(16));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(20));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(28));
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(24));
  static const BorderRadius full = BorderRadius.all(Radius.circular(999));

  // Named semantic (Spec Part 06)
  static const BorderRadius input = BorderRadius.all(Radius.circular(18));
  static const BorderRadius button = BorderRadius.all(Radius.circular(18));
  static const BorderRadius card = lg;
  static const BorderRadius hero = xl;
  static const BorderRadius bottomSheet = xl;
  static const BorderRadius dialog = xxl;
  static const BorderRadius modal = xl;
  static const BorderRadius chip = lg;
}
