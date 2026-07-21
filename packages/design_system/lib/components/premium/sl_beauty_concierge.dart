import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';

class SLBeautyConcierge extends StatelessWidget {
  final String clientName;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  const SLBeautyConcierge({
    super.key,
    required this.clientName,
    required this.message,
    required this.actionLabel,
    this.onAction,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SLSpacing.md),
      padding: const EdgeInsets.all(SLSpacing.lg),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SLColors.accentGold, SLColors.accentGoldLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: SLRadius.chip,
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome, color: SLColors.bgPrimary, size: 16),
                ),
              ),
              const SizedBox(width: SLSpacing.sm),
              Text(
                'IA Beauty Concierge',
                style: SLTypography.caption.copyWith(
                  color: SLColors.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (onDismiss != null)
                GestureDetector(
                  onTap: onDismiss,
                  child: const Icon(
                    Icons.close,
                    color: SLColors.textDisabled,
                    size: 16,
                  ),
                ),
            ],
          ),
          const SizedBox(height: SLSpacing.md),
          Text(
            message,
            style: SLTypography.body.copyWith(
              color: SLColors.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: SLSpacing.md),
          if (onAction != null)
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SLColors.accentGold.withValues(alpha: 0.1),
                  foregroundColor: SLColors.accentGold,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: SLRadius.chip,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: SLSpacing.md),
                ),
                child: Text(
                  actionLabel,
                  style: SLTypography.buttonSmall.copyWith(
                    color: SLColors.accentGold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
