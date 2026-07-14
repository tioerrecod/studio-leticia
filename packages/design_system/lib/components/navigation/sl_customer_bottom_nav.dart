import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

enum SLCustomerTab {
  home,
  booking,
  history,
  profile,
}

class SLCustomerBottomNav extends StatelessWidget {
  final SLCustomerTab currentTab;
  final ValueChanged<SLCustomerTab> onTabSelected;

  const SLCustomerBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: SLColors.surface,
        border: Border(
          top: BorderSide(
            color: SLColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Início',
                isSelected: currentTab == SLCustomerTab.home,
                onTap: () => onTabSelected(SLCustomerTab.home),
              ),
              _NavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Serviços',
                isSelected: currentTab == SLCustomerTab.booking,
                onTap: () => onTabSelected(SLCustomerTab.booking),
              ),
              _NavItem(
                icon: Icons.history_outlined,
                activeIcon: Icons.history,
                label: 'Histórico',
                isSelected: currentTab == SLCustomerTab.history,
                onTap: () => onTabSelected(SLCustomerTab.history),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Perfil',
                isSelected: currentTab == SLCustomerTab.profile,
                onTap: () => onTabSelected(SLCustomerTab.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            size: 24,
            color: isSelected ? SLColors.champagne : SLColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: SLTypography.caption.copyWith(
              color: isSelected ? SLColors.champagne : SLColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
