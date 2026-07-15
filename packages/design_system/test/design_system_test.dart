import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:design_system/design_system.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SLColors', () {
    test('champagne has correct value', () {
      expect(SLColors.champagne.toARGB32(), 0xFFD4A843);
    });

    test('carbon has correct value', () {
      expect(SLColors.carbon.toARGB32(), 0xFFF5F0E8);
    });

    test('background has correct value', () {
      expect(SLColors.background.toARGB32(), 0xFF000000);
    });
  });

  group('SLSpacing', () {
    test('spacing values are consistent', () {
      expect(SLSpacing.mini, 4);
      expect(SLSpacing.xs, 8);
      expect(SLSpacing.sm, 12);
      expect(SLSpacing.md, 16);
      expect(SLSpacing.lg, 24);
      expect(SLSpacing.xl, 32);
      expect(SLSpacing.xxl, 48);
    });
  });

  group('SLAnimations', () {
    test('animation durations are correct', () {
      expect(SLAnimations.fast, const Duration(milliseconds: 150));
      expect(SLAnimations.normal, const Duration(milliseconds: 300));
      expect(SLAnimations.slow, const Duration(milliseconds: 500));
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
      expect(SLAdminModule.values.length, 6);
    });
  });

  group('SLCustomerTab', () {
    test('has all tabs', () {
      expect(SLCustomerTab.values.length, 4);
    });
  });
}
