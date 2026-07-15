import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';

enum SLAdminModule {
  dashboard,
  schedule,
  customers,
  finances,
  marketing,
  settings,
}

class SLAdminSidebar extends StatelessWidget {
  final SLAdminModule currentModule;
  final String studioName;
  final String planName;
  final ValueChanged<SLAdminModule> onModuleSelected;

  const SLAdminSidebar({
    super.key,
    required this.currentModule,
    required this.studioName,
    required this.planName,
    required this.onModuleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: SLColors.surface,
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.all(SLSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studioName,
                  style: SLTypography.h2.copyWith(
                    color: SLColors.carbon,
                  ),
                ),
                const SizedBox(height: SLSpacing.mini),
                Text(
                  planName,
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  isSelected: currentModule == SLAdminModule.dashboard,
                  onTap: () => onModuleSelected(SLAdminModule.dashboard),
                ),
                _SidebarItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Agenda',
                  isSelected: currentModule == SLAdminModule.schedule,
                  onTap: () => onModuleSelected(SLAdminModule.schedule),
                ),
                _SidebarItem(
                  icon: Icons.people_outline,
                  label: 'Clientes',
                  isSelected: currentModule == SLAdminModule.customers,
                  onTap: () => onModuleSelected(SLAdminModule.customers),
                ),
                _SidebarItem(
                  icon: Icons.attach_money_outlined,
                  label: 'Financeiro',
                  isSelected: currentModule == SLAdminModule.finances,
                  onTap: () => onModuleSelected(SLAdminModule.finances),
                ),
                _SidebarItem(
                  icon: Icons.campaign_outlined,
                  label: 'Marketing',
                  isSelected: currentModule == SLAdminModule.marketing,
                  onTap: () => onModuleSelected(SLAdminModule.marketing),
                ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Configurações',
                  isSelected: currentModule == SLAdminModule.settings,
                  onTap: () => onModuleSelected(SLAdminModule.settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? SLColors.champagne : SLColors.textSecondary,
        size: 20,
      ),
      title: Text(
        label,
        style: SLTypography.body.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? SLColors.carbon : SLColors.textSecondary,
        ),
      ),
      selected: isSelected,
      selectedTileColor: SLColors.champagne.withValues(alpha: 0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: SLRadius.input,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: SLSpacing.md),
      onTap: onTap,
    );
  }
}
