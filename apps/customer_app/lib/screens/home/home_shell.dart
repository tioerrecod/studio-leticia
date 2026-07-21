import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';

class HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SLCustomerBottomNav(
        currentTab: _tabFromIndex(navigationShell.currentIndex),
        onTabSelected: (tab) {
          final index = _indexFromTab(tab);
          if (index != null) {
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
          }
        },
        onFabTap: () => context.go('/services/book'),
      ),
    );
  }

  SLCustomerTab _tabFromIndex(int index) {
    switch (index) {
      case 0: return SLCustomerTab.home;
      case 1: return SLCustomerTab.booking;
      case 2: return SLCustomerTab.courses;
      case 3: return SLCustomerTab.profile;
      default: return SLCustomerTab.home;
    }
  }

  int? _indexFromTab(SLCustomerTab tab) {
    switch (tab) {
      case SLCustomerTab.home: return 0;
      case SLCustomerTab.booking: return 1;
      case SLCustomerTab.courses: return 2;
      case SLCustomerTab.profile: return 3;
      case SLCustomerTab.history: return null;
    }
  }
}
