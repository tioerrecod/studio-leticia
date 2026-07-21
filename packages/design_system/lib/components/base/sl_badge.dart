import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

enum SLBadgeVariant {
  gold,
  success,
  error,
  warning,
  info,
}

class SLBadge extends StatelessWidget {
  final String label;
  final SLBadgeVariant variant;

  const SLBadge({
    super.key,
    required this.label,
    this.variant = SLBadgeVariant.gold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SLSpacing.space3,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _bgColor.withValues(alpha: 0.1),
        borderRadius: SLRadius.lg,
      ),
      child: Text(
        label,
        style: SLTypography.overline.copyWith(
          color: _textColor,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Color get _bgColor {
    switch (variant) {
      case SLBadgeVariant.gold:
        return SLColors.accentGold;
      case SLBadgeVariant.success:
        return SLColors.stateSuccess;
      case SLBadgeVariant.error:
        return SLColors.stateError;
      case SLBadgeVariant.warning:
        return SLColors.stateWarning;
      case SLBadgeVariant.info:
        return SLColors.stateInfo;
    }
  }

  Color get _textColor {
    switch (variant) {
      case SLBadgeVariant.gold:
        return SLColors.accentGoldLight;
      case SLBadgeVariant.success:
        return SLColors.stateSuccess;
      case SLBadgeVariant.error:
        return SLColors.stateError;
      case SLBadgeVariant.warning:
        return SLColors.stateWarning;
      case SLBadgeVariant.info:
        return SLColors.stateInfo;
    }
  }
}
