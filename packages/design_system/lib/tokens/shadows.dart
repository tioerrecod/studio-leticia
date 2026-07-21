import 'package:flutter/material.dart';

class SLShadows {
  SLShadows._();

  // ══════════════════════════════════════════════════════════
  // STUDIO LETÍCIA 3.0 — ELEVATION SHADOWS
  // Todas as sombras usam a cor base do bgInverse (#1C1815)
  // com opacidade variável — consistência cromática.
  // ══════════════════════════════════════════════════════════

  /// elevation-0 — sem sombra (fundo, texto)
  static const List<BoxShadow> elevation0 = [];

  /// elevation-1 — 0px 2px 8px rgba(28,24,21,0.06)
  /// Cards de lista, elevados sutilmente do fundo
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Color(0x0F1C1815),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// elevation-2 — 0px 6px 16px rgba(28,24,21,0.10)
  /// Card de destaque, próximo horário
  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Color(0x1A1C1815),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  /// elevation-3 — 0px 12px 28px rgba(28,24,21,0.16)
  /// Bottom sheet, modal
  static const List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Color(0x291C1815),
      blurRadius: 28,
      offset: Offset(0, 12),
    ),
  ];

  /// elevation-4 — 0px 20px 40px rgba(28,24,21,0.22)
  /// CTA flutuante (raro), alertas
  static const List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Color(0x381C1815),
      blurRadius: 40,
      offset: Offset(0, 20),
    ),
  ];
}
