import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:design_system/design_system.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SLColors', () {
    test('accentGold has correct value', () {
      expect(SLColors.accentGold, const Color(0xFFC9A05C));
    });

    test('bgPrimary has correct value', () {
      expect(SLColors.bgPrimary, const Color(0xFFF5EFE6));
    });

    test('bgInverse has correct value', () {
      expect(SLColors.bgInverse, const Color(0xFF1C1815));
    });

    test('backward-compat aliases point to correct colors', () {
      expect(SLColors.champagne, SLColors.accentGold);
      expect(SLColors.gold, SLColors.accentGoldLight);
      expect(SLColors.cream, SLColors.bgSecondary);
    });
  });

  group('SLSpacing', () {
    test('spacing values are consistent', () {
      expect(SLSpacing.space1, 4);
      expect(SLSpacing.space2, 8);
      expect(SLSpacing.space3, 12);
      expect(SLSpacing.space4, 16);
      expect(SLSpacing.space6, 24);
      expect(SLSpacing.space8, 32);
      expect(SLSpacing.space12, 48);
    });

    test('legacy names match new scale', () {
      expect(SLSpacing.mini, SLSpacing.space1);
      expect(SLSpacing.xs, SLSpacing.space2);
      expect(SLSpacing.sm, SLSpacing.space3);
      expect(SLSpacing.md, SLSpacing.space4);
      expect(SLSpacing.lg, SLSpacing.space6);
      expect(SLSpacing.xl, SLSpacing.space8);
      expect(SLSpacing.xxl, SLSpacing.space12);
    });
  });

  group('SLRadius', () {
    test('radius values are correct', () {
      expect(SLRadius.sm, BorderRadius.circular(12));
      expect(SLRadius.card, BorderRadius.circular(20));
      expect(SLRadius.hero, BorderRadius.circular(28));
      expect(SLRadius.button, BorderRadius.circular(18));
      expect(SLRadius.input, BorderRadius.circular(18));
    });
  });

  group('SLAnimations', () {
    test('animation durations are correct', () {
      expect(SLAnimations.fast, const Duration(milliseconds: 150));
      expect(SLAnimations.fade, const Duration(milliseconds: 200));
      expect(SLAnimations.scale, const Duration(milliseconds: 180));
      expect(SLAnimations.medium, const Duration(milliseconds: 250));
      expect(SLAnimations.hero, const Duration(milliseconds: 300));
      expect(SLAnimations.slow, const Duration(milliseconds: 400));
    });
  });

  group('SLShadows', () {
    test('elevation levels exist', () {
      expect(SLShadows.elevation0, isEmpty);
      expect(SLShadows.elevation1.length, 1);
      expect(SLShadows.elevation2.length, 1);
      expect(SLShadows.elevation3.length, 1);
      expect(SLShadows.elevation4.length, 1);
    });
  });

  group('StudioTheme', () {
    test('light theme is not null', () {
      final theme = StudioTheme.light;
      expect(theme, isNotNull);
    }, skip: 'Requires network access for google_fonts');

    test('light theme uses material3', () {
      final theme = StudioTheme.light;
      expect(theme.useMaterial3, true);
    }, skip: 'Requires network access for google_fonts');

    test('light theme has correct brightness', () {
      final theme = StudioTheme.light;
      expect(theme.brightness, Brightness.light);
    }, skip: 'Requires network access for google_fonts');

    test('dark theme is not null', () {
      final theme = StudioTheme.dark;
      expect(theme, isNotNull);
    }, skip: 'Requires network access for google_fonts');

    test('dark theme has correct brightness', () {
      final theme = StudioTheme.dark;
      expect(theme.brightness, Brightness.dark);
    }, skip: 'Requires network access for google_fonts');
  });

  group('SLAdminModule', () {
    test('has all modules', () {
      expect(SLAdminModule.values.length, 7);
      expect(SLAdminModule.values.contains(SLAdminModule.servicos), true);
    });
  });

  group('SLCustomerTab', () {
    test('has 5 tabs with courses', () {
      expect(SLCustomerTab.values.length, 5);
      expect(SLCustomerTab.values.contains(SLCustomerTab.courses), true);
    });
  });
}
