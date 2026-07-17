import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_leticia/screens/home/home_screen.dart';
import 'package:studio_leticia/screens/home/home_shell.dart';
import 'package:studio_leticia/screens/booking/services_screen.dart';
import 'package:studio_leticia/screens/history/history_screen.dart';
import 'package:studio_leticia/screens/profile/profile_screen.dart';

Widget createTestApp() {
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/services', builder: (_, __) => const ServicesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('HomeScreen renders hero section', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Studio Letícia'), findsOneWidget);
    expect(find.text('Agendar experiência'), findsWidgets);
  });

  testWidgets('HomeScreen renders quick actions after scroll', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pump();

    expect(find.text('Meus Horários'), findsOneWidget);
    expect(find.text('Inspirações'), findsOneWidget);
    expect(find.text('Favoritos'), findsOneWidget);
    expect(find.text('Conversar'), findsOneWidget);
  });

  testWidgets('HomeScreen renders service cards after scroll', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
    await tester.pump();

    expect(find.text('Corte Personalizado'), findsWidgets);
  });
}
