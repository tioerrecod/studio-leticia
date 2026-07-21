import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SLTypography {
  SLTypography._();

  // ══════════════════════════════════════════════════════════════
  // STUDIO LETÍCIA 3.0 — TYPOGRAPHY SCALE
  // Regra: Serifa (Playfair) = emoção/identidade
  //        Sem serifa (Inter) = ação/informação
  // ══════════════════════════════════════════════════════════════

  // ── Emotional / Editorial (Playfair Display) ──────────────
  static TextStyle display = GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle h1 = GoogleFonts.playfairDisplay(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static TextStyle h2 = GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.2,
  );

  // ── Functional (Inter) ────────────────────────────────────
  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Data / Metadata ───────────────────────────────────────
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // ── Labels (uppercase section headers) ────────────────────
  static TextStyle overline = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 2,
  );

  // ── Actions ───────────────────────────────────────────────
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
  );

  static TextStyle buttonSmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
  );

  static TextStyle buttonMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
  );

  static TextStyle buttonLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
  );

  // ── Status / Badge ────────────────────────────────────────
  static TextStyle badge = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // ── Price highlight (serif for elegance) ──────────────────
  static TextStyle price = GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
}
