import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SLTypography {
  SLTypography._();

  // ── Display ──────────────────────────────────────────
  static TextStyle display = GoogleFonts.playfairDisplay(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -1.5,
  );

  // ── Headings ─────────────────────────────────────────
  static TextStyle h1 = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle h2 = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ── Body ─────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Caption ──────────────────────────────────────────
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Overline ─────────────────────────────────────────
  static TextStyle overline = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 2,
  );

  // ── Buttons ──────────────────────────────────────────
  static TextStyle button = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 1,
  );

  static TextStyle buttonSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 1,
  );
}
