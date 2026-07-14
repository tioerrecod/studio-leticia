import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';

const _moduleByIndex = <int, SLAdminModule>{
  0: SLAdminModule.dashboard,
  1: SLAdminModule.schedule,
  2: SLAdminModule.customers,
  3: SLAdminModule.finances,
  4: SLAdminModule.marketing,
  5: SLAdminModule.settings,
};

const _indexByModule = <SLAdminModule, int>{
  SLAdminModule.dashboard: 0,
  SLAdminModule.schedule: 1,
  SLAdminModule.customers: 2,
  SLAdminModule.finances: 3,
  SLAdminModule.marketing: 4,
  SLAdminModule.settings: 5,
};

class AdminShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdminShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentModule =
        _moduleByIndex[navigationShell.currentIndex] ?? SLAdminModule.dashboard;

    return Scaffold(
      body: Row(
        children: [
          // ── Sidebar ────────────────────────────────
          SLAdminSidebar(
            currentModule: currentModule,
            studioName: 'Studio Letícia',
            planName: 'Professional',
            onModuleSelected: (module) {
              final index = _indexByModule[module] ?? 0;
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),

          // ── Main content ────────────────────────────
          Expanded(
            child: navigationShell,
          ),
        ],
      ),
    );
  }
}
