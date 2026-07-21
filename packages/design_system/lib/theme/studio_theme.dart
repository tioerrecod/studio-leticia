import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';

class StudioTheme {
  StudioTheme._();

  /// Tema padrão — Studio Leticia 3.0 Light (Bege + Dourado)
  /// Usado em 80% da experiência operacional (Home, Serviços, Agendamento, Histórico, Perfil)
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: SLColors.bgPrimary,
      colorScheme: const ColorScheme.light(
        primary: SLColors.accentGold,
        onPrimary: SLColors.textOnGold,
        secondary: SLColors.accentGoldLight,
        onSecondary: SLColors.textPrimary,
        surface: SLColors.surface,
        onSurface: SLColors.textPrimary,
        error: SLColors.stateError,
        onError: SLColors.textInverse,
      ),
      textTheme: TextTheme(
        displayLarge: SLTypography.display,
        headlineLarge: SLTypography.h1,
        headlineMedium: SLTypography.h2,
        headlineSmall: SLTypography.h3,
        bodyLarge: SLTypography.bodyLarge,
        bodyMedium: SLTypography.body,
        bodySmall: SLTypography.bodySmall,
        labelLarge: SLTypography.button,
        labelMedium: SLTypography.label,
        labelSmall: SLTypography.badge,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: SLColors.bgPrimary,
        foregroundColor: SLColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: SLColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: SLRadius.md,
          side: const BorderSide(color: SLColors.borderSubtle, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SLColors.accentGold,
          foregroundColor: SLColors.textOnGold,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: SLSpacing.space6,
            vertical: SLSpacing.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: SLRadius.xl,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SLColors.surface,
        border: OutlineInputBorder(
          borderRadius: SLRadius.sm,
          borderSide: const BorderSide(color: SLColors.borderSubtle, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: SLRadius.sm,
          borderSide: const BorderSide(color: SLColors.borderSubtle, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: SLRadius.sm,
          borderSide: const BorderSide(color: SLColors.borderFocus, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SLSpacing.space4,
          vertical: SLSpacing.space3,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: SLColors.divider,
        thickness: 0.5,
        space: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SLColors.surface,
        selectedItemColor: SLColors.accentGold,
        unselectedItemColor: SLColors.textDisabled,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Tema escuro — Absolute Black (legado BOS v2)
  /// Usado em momentos de assinatura de marca via bgInverse explícito nas telas
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SLColors.bgInverse,
      colorScheme: const ColorScheme.dark(
        primary: SLColors.accentGold,
        onPrimary: SLColors.bgInverse,
        secondary: SLColors.accentGoldLight,
        onSecondary: SLColors.bgInverse,
        surface: SLColors.surfaceCardDark,
        onSurface: SLColors.textInverse,
        error: SLColors.stateError,
        onError: SLColors.textInverse,
      ),
      textTheme: TextTheme(
        displayLarge: SLTypography.display.copyWith(color: SLColors.textInverse),
        headlineLarge: SLTypography.h1.copyWith(color: SLColors.textInverse),
        headlineMedium: SLTypography.h2.copyWith(color: SLColors.textInverse),
        headlineSmall: SLTypography.h3.copyWith(color: SLColors.textInverse),
        bodyLarge: SLTypography.bodyLarge.copyWith(color: SLColors.textInverse),
        bodyMedium: SLTypography.body.copyWith(color: SLColors.textInverse),
        bodySmall: SLTypography.bodySmall.copyWith(color: SLColors.textInverse),
        labelLarge: SLTypography.button.copyWith(color: SLColors.textInverse),
        labelMedium: SLTypography.label.copyWith(color: SLColors.textInverse),
        labelSmall: SLTypography.badge.copyWith(color: SLColors.textInverse),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: SLColors.textInverse,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: SLColors.surfaceCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: SLRadius.md,
          side: const BorderSide(color: SLColors.borderSubtle, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SLColors.accentGold,
          foregroundColor: SLColors.textOnGold,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: SLSpacing.space6,
            vertical: SLSpacing.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: SLRadius.xl,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SLColors.surfaceCardDark,
        border: OutlineInputBorder(
          borderRadius: SLRadius.sm,
          borderSide: const BorderSide(color: SLColors.borderSubtle, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: SLRadius.sm,
          borderSide: const BorderSide(color: SLColors.borderSubtle, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: SLRadius.sm,
          borderSide: const BorderSide(color: SLColors.accentGold, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SLSpacing.space4,
          vertical: SLSpacing.space3,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: SLColors.borderSubtle,
        thickness: 0.5,
        space: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SLColors.surfaceCardDark,
        selectedItemColor: SLColors.accentGold,
        unselectedItemColor: SLColors.textDisabled,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
