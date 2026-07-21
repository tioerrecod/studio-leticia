import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/animations.dart';

enum SLButtonVariant {
  primary,
  outline,
  text,
}

class SLButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final SLButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final double? height;

  const SLButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = SLButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height,
  });

  @override
  State<SLButton> createState() => _SLButtonState();
}

class _SLButtonState extends State<SLButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    final height = widget.height ?? 52.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: SLAnimations.fast,
        width: widget.isExpanded ? double.infinity : null,
        height: height,
        decoration: _buildDecoration(isDisabled),
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: _textColor(),
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: SLColors.textDisabled,
            padding: EdgeInsets.symmetric(
              horizontal: SLSpacing.space6,
              vertical: SLSpacing.space3,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: SLRadius.button,
              side: widget.variant == SLButtonVariant.outline
                  ? BorderSide(
                      color: isDisabled
                          ? SLColors.textDisabled
                          : SLColors.accentGold,
                      width: 1.5,
                    )
                  : BorderSide.none,
            ),
          ),
          child: widget.isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.variant == SLButtonVariant.text
                          ? SLColors.accentGold
                          : SLColors.textOnDark,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18),
                      const SizedBox(width: SLSpacing.space2),
                    ],
                    Text(
                      widget.label,
                      style: SLTypography.buttonSmall.copyWith(
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Decoration _buildDecoration(bool isDisabled) {
    switch (widget.variant) {
      case SLButtonVariant.primary:
        if (isDisabled) {
          return BoxDecoration(
            borderRadius: SLRadius.button,
            color: SLColors.disabled,
          );
        }
        return BoxDecoration(
          borderRadius: SLRadius.button,
          gradient: LinearGradient(
            colors: [
              SLColors.accentGold,
              SLColors.accentGoldLight,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: SLColors.accentGold.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: SLColors.accentGold.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        );
      case SLButtonVariant.outline:
        return BoxDecoration(
          borderRadius: SLRadius.button,
          color: isDisabled ? Colors.transparent : Colors.transparent,
        );
      case SLButtonVariant.text:
        return const BoxDecoration();
    }
  }

  Color _textColor() {
    if (widget.isLoading) return Colors.transparent;
    switch (widget.variant) {
      case SLButtonVariant.primary:
        return SLColors.textOnDark;
      case SLButtonVariant.outline:
        return SLColors.accentGold;
      case SLButtonVariant.text:
        return SLColors.accentGold;
    }
  }
}
