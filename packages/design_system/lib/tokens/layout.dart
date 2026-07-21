import 'package:flutter/material.dart';

class SLLayout {
  SLLayout._();

  // ══════════════════════════════════════════════════════════
  // STUDIO LETÍCIA 3.0 — LAYOUT TOKENS
  // ══════════════════════════════════════════════════════════

  /// Margem lateral padrão de tela
  static const double marginScreen = 24.0;

  /// Espaço entre cards na mesma lista
  static const double gapCardList = 12.0;

  /// Espaço entre seções/blocos
  static const double gapSection = 32.0;

  /// Altura da bottom navigation (excluindo safe area)
  static const double bottomNavHeight = 64.0;

  /// Altura total da barra de CTA fixo inferior (inclui padding interno)
  static const double ctaBarHeight = 88.0;

  /// Padding horizontal padrão para conteúdo de tela
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 24.0);

  /// Padding horizontal + vertical para conteúdo de tela
  static const EdgeInsets screenPaddingAll = EdgeInsets.all(24.0);

  /// Hero image height ratio (56% of viewport)
  static const double heroHeightRatio = 0.56;

  /// Hero min height (dp)
  static const double heroMinHeight = 380.0;

  /// Hero max height (dp)
  static const double heroMaxHeight = 480.0;
}
