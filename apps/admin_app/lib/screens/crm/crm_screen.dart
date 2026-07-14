import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class CrmScreen extends StatelessWidget {
  const CrmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'CRM 360\u00b0',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(SLSpacing.md),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: SLSpacing.md),
            decoration: BoxDecoration(
              color: SLColors.surface,
              borderRadius: SLRadius.input,
              border: Border.all(color: SLColors.border, width: 0.5),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: SLColors.textDisabled, size: 18),
                SizedBox(width: SLSpacing.sm),
                Text(
                  'Buscar cliente...',
                  style: TextStyle(
                    color: SLColors.textDisabled,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SLSpacing.xl),

          _ClientCard(
            name: 'Rafaela',
            visits: 12,
            lastVisit: '15 jun 2026',
            totalSpent: 'R\$ 1.320',
            nextAppointment: '20 jul 2026',
          ),
          _ClientCard(
            name: 'Mariana',
            visits: 8,
            lastVisit: '10 jun 2026',
            totalSpent: 'R\$ 890',
          ),
          _ClientCard(
            name: 'Ana Beatriz',
            visits: 24,
            lastVisit: '05 jul 2026',
            totalSpent: 'R\$ 3.450',
            nextAppointment: '14 jul 2026',
          ),
          _ClientCard(
            name: 'Camila',
            visits: 15,
            lastVisit: '20 mai 2026',
            totalSpent: 'R\$ 1.890',
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final String name;
  final int visits;
  final String lastVisit;
  final String totalSpent;
  final String? nextAppointment;

  const _ClientCard({
    required this.name,
    required this.visits,
    required this.lastVisit,
    required this.totalSpent,
    this.nextAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: SLSpacing.sm),
      padding: const EdgeInsets.all(SLSpacing.md),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: SLColors.carbon.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: SLColors.cream,
            ),
            child: const Center(
              child: Icon(Icons.person, color: SLColors.champagne, size: 22),
            ),
          ),
          const SizedBox(width: SLSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: SLTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SLColors.carbon,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$visits visitas',
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SLSpacing.xs),
                Row(
                  children: [
                    Text(
                      totalSpent,
                      style: SLTypography.bodySmall.copyWith(
                        color: SLColors.champagne,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: SLSpacing.sm),
                    Text(
                      '\u00daltima: $lastVisit',
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (nextAppointment != null) ...[
                  const SizedBox(height: SLSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SLSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: SLColors.sage.withValues(alpha: 0.1),
                      borderRadius: SLRadius.chip,
                    ),
                    child: Text(
                      'Pr\u00f3ximo: $nextAppointment',
                      style: SLTypography.caption.copyWith(
                        color: SLColors.sage,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: SLColors.textDisabled,
            size: 18,
          ),
        ],
      ),
    );
  }
}
