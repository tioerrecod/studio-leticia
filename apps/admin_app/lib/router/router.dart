import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/agenda/agenda_screen.dart';
import '../screens/crm/crm_screen.dart';
import '../screens/financial/financial_screen.dart';
import '../screens/marketing/marketing_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/admin_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AdminShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/dashboard',
              builder: (_, __) => const DashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/agenda',
              builder: (_, __) => const AgendaScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/crm',
              builder: (_, __) => const CrmScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/financeiro',
              builder: (_, __) => const FinancialScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/marketing',
              builder: (_, __) => const MarketingScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (_, __) => const SettingsScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
