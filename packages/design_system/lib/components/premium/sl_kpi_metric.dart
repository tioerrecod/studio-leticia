import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';

class SLKpiMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String change;
  final bool isPositive;

  const SLKpiMetric({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.change,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SLSpacing.md),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: SLColors.accentGold.withValues(alpha: 0.1),
                  borderRadius: SLRadius.chip,
                ),
                child: Icon(icon, size: 14, color: SLColors.accentGold),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 10,
                    color: isPositive ? SLColors.success : SLColors.error,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    change,
                    style: SLTypography.caption.copyWith(
                      color: isPositive ? SLColors.success : SLColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SLSpacing.sm),
          Text(
            value,
            style: SLTypography.h2.copyWith(
              color: SLColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: SLTypography.caption.copyWith(
              color: SLColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
