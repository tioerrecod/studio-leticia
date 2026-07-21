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
              color: SLColors.textPrimary.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: Text(
                time,
                style: SLTypography.h3.copyWith(
                  color: SLColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: SLSpacing.md),
            Container(
              width: 1,
              height: 40,
              color: SLColors.border,
            ),
            const SizedBox(width: SLSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    customerName,
                    style: SLTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: SLColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: SLSpacing.space1),
                  Wrap(
                    spacing: SLSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          serviceName,
                          style: SLTypography.caption.copyWith(
                            color: SLColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (rating != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                size: 12, color: SLColors.accentGold),
                            const SizedBox(width: 2),
                            Text(
                              rating!,
                              style: SLTypography.caption.copyWith(
                                color: SLColors.accentGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (iaSuggestion != null) ...[
              const SizedBox(width: SLSpacing.sm),
              _StatusChip(text: iaSuggestion!),
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

class _StatusChip extends StatelessWidget {
  final String text;

  const _StatusChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = _statusColors(text);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SLSpacing.sm,
        vertical: SLSpacing.mini,
      ),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.1),
        borderRadius: SLRadius.chip,
      ),
      child: Text(
        text,
        style: SLTypography.badge.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        softWrap: false,
        overflow: TextOverflow.clip,
      ),
    );
  }

  (Color, Color) _statusColors(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('confirmado') || lower.contains('concluído') || lower.contains('concluido')) {
      return (SLColors.stateSuccess, SLColors.stateSuccess);
    }
    if (lower.contains('cancelado') || lower.contains('ausente')) {
      return (SLColors.stateError, SLColors.stateError);
    }
    if (lower.contains('aguardando') || lower.contains('pendente')) {
      return (SLColors.stateWarning, SLColors.stateWarning);
    }
    return (SLColors.stateInfo, SLColors.stateInfo);
  }
}
