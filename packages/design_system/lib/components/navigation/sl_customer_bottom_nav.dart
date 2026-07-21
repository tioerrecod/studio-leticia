import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';

enum SLCustomerTab {
  home,
  booking,
  history,
  profile,
  courses,
}

class SLCustomerBottomNav extends StatelessWidget {
  final SLCustomerTab currentTab;
  final ValueChanged<SLCustomerTab> onTabSelected;
  final VoidCallback? onFabTap;

  const SLCustomerBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: SLColors.bgInverse.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: SLSpacing.space2, bottom: SLSpacing.space1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Início',
                isSelected: currentTab == SLCustomerTab.home,
                onTap: () => onTabSelected(SLCustomerTab.home),
              ),
              _NavItem(
                icon: Icons.grid_view_outlined,
                label: 'Serviços',
                isSelected: currentTab == SLCustomerTab.booking,
                onTap: () => onTabSelected(SLCustomerTab.booking),
              ),

              // ── FAB Center ────────────────────────────
              GestureDetector(
                onTap: onFabTap,
                child: Transform.translate(
                  offset: const Offset(0, -14),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [SLColors.accentGold, SLColors.accentGoldLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: SLColors.accentGold.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: SLColors.textOnDark, size: 28),
                  ),
                ),
              ),

              _NavItem(
                icon: Icons.school_outlined,
                label: 'Cursos',
                isSelected: currentTab == SLCustomerTab.courses,
                onTap: () => onTabSelected(SLCustomerTab.courses),
              ),
              _NavItem(
                icon: Icons.person_outline,
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
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
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
            icon,
            size: 24,
            color: isSelected ? SLColors.accentGold : SLColors.textDisabled,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: SLTypography.caption.copyWith(
              color: isSelected ? SLColors.accentGold : SLColors.textDisabled,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
