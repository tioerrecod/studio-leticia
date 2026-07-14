import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';

class SLAppointmentCard extends StatelessWidget {
  final String time;
  final String customerName;
  final String serviceName;
  final String? rating;
  final String? iaSuggestion;
  final VoidCallback? onTap;

  const SLAppointmentCard({
    super.key,
    required this.time,
    required this.customerName,
    required this.serviceName,
    this.rating,
    this.iaSuggestion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: SLSpacing.md,
          vertical: SLSpacing.xs,
        ),
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
            // Time
            SizedBox(
              width: 48,
              child: Text(
                time,
                style: SLTypography.h3.copyWith(
                  color: SLColors.carbon,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Divider
            Container(
              width: 1,
              height: 40,
              color: SLColors.border,
            ),
            const SizedBox(width: SLSpacing.md),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName,
                    style: SLTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: SLColors.carbon,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    serviceName,
                    style: SLTypography.caption.copyWith(
                      color: SLColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Rating
            if (rating != null)
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: SLColors.champagne),
                  const SizedBox(width: 2),
                  Text(
                    rating!,
                    style: SLTypography.caption.copyWith(
                      color: SLColors.champagne,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            // IA Suggestion
            if (iaSuggestion != null) ...[
              const SizedBox(width: SLSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SLSpacing.sm,
                  vertical: SLSpacing.mini,
                ),
                decoration: BoxDecoration(
                  color: SLColors.sage.withValues(alpha: 0.1),
                  borderRadius: SLRadius.chip,
                ),
                child: Text(
                  iaSuggestion!,
                  style: SLTypography.caption.copyWith(
                    color: SLColors.sage,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(width: SLSpacing.sm),
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
