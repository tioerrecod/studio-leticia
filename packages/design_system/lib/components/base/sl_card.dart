import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/shadows.dart';

enum SLCardVariant {
  elevated,
  outlined,
  flat,
}

class SLCard extends StatelessWidget {
  final Widget child;
  final SLCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const SLCard({
    super.key,
    required this.child,
    this.variant = SLCardVariant.outlined,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? EdgeInsets.all(SLSpacing.space6),
      child: child,
    );

    final decoration = BoxDecoration(
      color: SLColors.surface,
      borderRadius: borderRadius ?? SLRadius.card,
      border: variant == SLCardVariant.outlined
          ? Border.all(color: SLColors.border, width: 0.5)
          : null,
      boxShadow: _shadows,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
      borderRadius: borderRadius ?? SLRadius.md,
          child: Container(
            decoration: decoration,
            child: content,
          ),
        ),
      );
    }

    return Container(
      decoration: decoration,
      child: content,
    );
  }

  List<BoxShadow>? get _shadows {
    switch (variant) {
      case SLCardVariant.elevated:
        return SLShadows.elevation1;
      case SLCardVariant.outlined:
        return [
          BoxShadow(
            color: SLColors.bgInverse.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ];
      case SLCardVariant.flat:
        return null;
    }
  }
}
