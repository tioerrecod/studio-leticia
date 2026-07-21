import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';

class SLBeautyPassport extends StatelessWidget {
  final String name;
  final String tierName;
  final int points;
  final int pointsToNext;
  final int visits;
  final String memberSince;

  const SLBeautyPassport({
    super.key,
    required this.name,
    required this.tierName,
    required this.points,
    required this.pointsToNext,
    required this.visits,
    required this.memberSince,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SLSpacing.md),
      padding: const EdgeInsets.all(SLSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [SLColors.surfaceVariant, Color(0xFF0D0D0D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: SLRadius.card,
        boxShadow: [
          BoxShadow(
            color: SLColors.textPrimary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BEAUTY PASSPORT',
                style: SLTypography.overline.copyWith(
                  color: SLColors.accentGold,
                  letterSpacing: 3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SLSpacing.sm,
                  vertical: SLSpacing.mini,
                ),
                decoration: BoxDecoration(
                  color: SLColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: SLRadius.chip,
                ),
                child: Text(
                  tierName,
                  style: SLTypography.overline.copyWith(
                    color: SLColors.accentGold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SLSpacing.lg),
          Text(
            name,
            style: SLTypography.h1.copyWith(
              color: SLColors.bgPrimary,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: SLSpacing.md),
          Row(
            children: [
              _PassportStat(
                value: '$points',
                label: 'pontos',
              ),
              const SizedBox(width: SLSpacing.xl),
              _PassportStat(
                value: '$visits',
                label: 'visitas',
              ),
              const SizedBox(width: SLSpacing.xl),
              _PassportStat(
                value: memberSince,
                label: 'membro',
              ),
            ],
          ),
          const SizedBox(height: SLSpacing.md),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$pointsToNext pts para próximo nível',
                    style: SLTypography.caption.copyWith(
                      color: SLColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SLSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: points / (points + pointsToNext),
                  backgroundColor: SLColors.accentGold.withValues(alpha: 0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(SLColors.accentGold),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PassportStat extends StatelessWidget {
  final String value;
  final String label;

  const _PassportStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: SLTypography.h3.copyWith(
            color: SLColors.bgPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: SLTypography.caption.copyWith(
            color: SLColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
