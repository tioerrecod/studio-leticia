import 'package:flutter/material.dart';
import 'package:design_system/tokens/colors.dart';
import 'package:design_system/tokens/radius.dart';

class SLShimmer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SLShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = SLRadius.sm,
  });

  @override
  State<SLShimmer> createState() => _SLShimmerState();
}

class _SLShimmerState extends State<SLShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              colors: const [
                SLColors.bgSecondary,
                SLColors.accentGoldLight,
                SLColors.bgSecondary,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: _animation.value,
              end: Alignment(-_animation.value.x, 0),
            ),
          ),
        );
      },
    );
  }
}
