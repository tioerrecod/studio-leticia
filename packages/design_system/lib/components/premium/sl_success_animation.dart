import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';

class SLSuccessAnimation extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onComplete;

  const SLSuccessAnimation({
    super.key,
    required this.title,
    required this.subtitle,
    this.onComplete,
  });

  @override
  State<SLSuccessAnimation> createState() => _SLSuccessAnimationState();
}

class _SLSuccessAnimationState extends State<SLSuccessAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated checkmark
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [SLColors.champagne, SLColors.gold],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: SLColors.champagne.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                color: SLColors.ivory,
                size: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: SLSpacing.xl),
        // Title
        FadeTransition(
          opacity: _opacityAnimation,
          child: Text(
            widget.title,
            style: SLTypography.h2.copyWith(
              color: SLColors.carbon,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: SLSpacing.sm),
        // Subtitle
        FadeTransition(
          opacity: _opacityAnimation,
          child: Text(
            widget.subtitle,
            style: SLTypography.body.copyWith(
              color: SLColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
