import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';

class SLExperiencePass extends StatelessWidget {
  final String day;
  final String month;
  final String time;
  final String serviceName;
  final String professionalName;
  final String duration;
  final VoidCallback? onTap;

  const SLExperiencePass({
    super.key,
    required this.day,
    required this.month,
    required this.time,
    required this.serviceName,
    required this.professionalName,
    required this.duration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: SLSpacing.md),
        padding: const EdgeInsets.all(SLSpacing.lg),
        decoration: BoxDecoration(
          color: SLColors.surface,
          borderRadius: SLRadius.card,
          border: Border.all(color: SLColors.border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: SLColors.carbon.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Date badge
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [SLColors.champagne, SLColors.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: SLRadius.input,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: SLTypography.h2.copyWith(
                      color: SLColors.ivory,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  Text(
                    month.toUpperCase(),
                    style: SLTypography.caption.copyWith(
                      color: SLColors.ivory,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SLSpacing.md),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceName,
                    style: SLTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: SLColors.carbon,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$professionalName · $time · $duration',
                    style: SLTypography.caption.copyWith(
                      color: SLColors.textSecondary,
                    ),
                  ),
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
      ),
    );
  }
}
