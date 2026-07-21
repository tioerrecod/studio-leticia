import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';

const _moduleByIndex = <int, SLAdminModule>{
  0: SLAdminModule.dashboard,
  1: SLAdminModule.schedule,
  2: SLAdminModule.customers,
  3: SLAdminModule.finances,
  4: SLAdminModule.marketing,
  5: SLAdminModule.servicos,
  6: SLAdminModule.settings,
};

const _indexByModule = <SLAdminModule, int>{
  SLAdminModule.dashboard: 0,
  SLAdminModule.schedule: 1,
  SLAdminModule.customers: 2,
  SLAdminModule.finances: 3,
  SLAdminModule.marketing: 4,
  SLAdminModule.servicos: 5,
  SLAdminModule.settings: 6,
};

class AdminShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdminShell({super.key, required this.navigationShell});

  void _goToModule(SLAdminModule module) {
    final index = _indexByModule[module] ?? 0;
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentModule =
        _moduleByIndex[navigationShell.currentIndex] ?? SLAdminModule.dashboard;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                SLAdminSidebar(
                  currentModule: currentModule,
                  studioName: 'Studio Letícia',
                  planName: 'Professional',
                  onModuleSelected: _goToModule,
                ),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }

        if (isTablet) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _indexByModule[currentModule] ?? 0,
                  onDestinationSelected: (i) => _goToModule(_moduleByIndex[i]!),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('SL', style: SLTypography.h3.copyWith(color: SLColors.accentGold)),
                  ),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Dashboard')),
                    NavigationRailDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: Text('Agenda')),
                    NavigationRailDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: Text('Clientes')),
                    NavigationRailDestination(icon: Icon(Icons.attach_money_outlined), selectedIcon: Icon(Icons.attach_money), label: Text('Financeiro')),
                    NavigationRailDestination(icon: Icon(Icons.campaign_outlined), selectedIcon: Icon(Icons.campaign), label: Text('Marketing')),
                    NavigationRailDestination(icon: Icon(Icons.photo_library_outlined), selectedIcon: Icon(Icons.photo_library), label: Text('Mídia')),
                    NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Config')),
                  ],
                ),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }

        // Mobile
        return Scaffold(
          appBar: AppBar(
            backgroundColor: SLColors.surface,
            elevation: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: SLColors.textPrimary),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Text(
              ['Dashboard', 'Agenda', 'Clientes', 'Financeiro', 'Marketing', 'Mídia', 'Config'][_indexByModule[currentModule] ?? 0],
              style: SLTypography.h3.copyWith(color: SLColors.textPrimary, fontWeight: FontWeight.w400),
            ),
          ),
          drawer: Drawer(
            child: SLAdminSidebar(
              currentModule: currentModule,
              studioName: 'Studio Letícia',
              planName: 'Professional',
              onModuleSelected: (module) {
                Navigator.of(context).pop();
                _goToModule(module);
              },
            ),
          ),
          body: SafeArea(child: navigationShell),
        );
      },
    );
  }
}
