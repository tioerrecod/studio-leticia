import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import 'sl_card.dart';

class SLFidelityCard extends StatelessWidget {
  final int points;
  final VoidCallback? onRewardsTap;

  const SLFidelityCard({
    super.key,
    required this.points,
    this.onRewardsTap,
  });

  @override
  Widget build(BuildContext context) {
    return SLCard(
      variant: SLCardVariant.elevated,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sua jornada com a gente',
                  style: SLTypography.label.copyWith(
                    color: SLColors.textSecondary,
                  ),
                ),
                const SizedBox(height: SLSpacing.space2),
                Text(
                  '${points.toStringAsFixed(0).replaceAllMapped(
                    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                    (m) => '${m[1]}.',
                  )} Pontos',
                  style: SLTypography.price.copyWith(
                    fontSize: 28,
                    color: SLColors.accentGold,
                  ),
                ),
                const SizedBox(height: SLSpacing.space2),
                if (onRewardsTap != null)
                  GestureDetector(
                    onTap: onRewardsTap,
                    child: Text(
                      'VER RECOMPENSAS',
                      style: SLTypography.buttonSmall.copyWith(
                        color: SLColors.accentGold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.3,
            child: Icon(
              Icons.eco_outlined,
              size: 44,
              color: SLColors.accentGoldLight,
            ),
          ),
        ],
      ),
    );
  }
}
