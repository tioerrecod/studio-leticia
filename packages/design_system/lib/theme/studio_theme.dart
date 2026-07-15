import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';

class StudioTheme {
  StudioTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: SLColors.background,
      colorScheme: const ColorScheme.light(
        primary: SLColors.champagne,
        onPrimary: SLColors.ivory,
        secondary: SLColors.gold,
        onSecondary: SLColors.carbon,
        surface: SLColors.surface,
        onSurface: SLColors.carbon,
        error: SLColors.error,
        onError: SLColors.ivory,
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
        labelMedium: SLTypography.buttonSmall,
        labelSmall: SLTypography.overline,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: SLColors.background,
        foregroundColor: SLColors.carbon,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: SLColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: SLColors.border, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SLColors.champagne,
          foregroundColor: SLColors.ivory,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SLColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SLColors.border, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SLColors.border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SLColors.champagne, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: SLColors.divider,
        thickness: 0.5,
        space: 0,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SLColors.background,
      colorScheme: const ColorScheme.dark(
        primary: SLColors.champagne,
        onPrimary: SLColors.background,
        secondary: SLColors.gold,
        onSecondary: SLColors.background,
        surface: SLColors.surface,
        onSurface: SLColors.ivory,
        error: SLColors.error,
        onError: SLColors.ivory,
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
        labelMedium: SLTypography.buttonSmall,
        labelSmall: SLTypography.overline,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: SLColors.background,
        foregroundColor: SLColors.champagne,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: SLColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: SLColors.border, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SLColors.champagne,
          foregroundColor: SLColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SLColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SLColors.border, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SLColors.border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: SLColors.champagne, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: SLColors.divider,
        thickness: 0.5,
        space: 0,
      ),
    );
  }
}
