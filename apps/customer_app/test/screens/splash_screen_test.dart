import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_leticia/screens/splash/splash_screen.dart';

Widget createTestApp() {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const SizedBox()),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('SplashScreen renders Studio Letícia branding', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pump();

    expect(find.text('Studio'), findsOneWidget);
    expect(find.text('Letícia'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('SplashScreen auto-navigates to onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pump();

    expect(find.text('Studio'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Studio'), findsNothing);
  });
}
