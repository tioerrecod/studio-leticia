import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleIn = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: ScaleTransition(
            scale: _scaleIn,
            child: SlideTransition(
              position: _slideUp,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gold circle emblem
                  Container(
                    width: 88,
                    height: 88,
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
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.spa_outlined, size: 40, color: SLColors.background),
                    ),
                  ),
                  const SizedBox(height: SLSpacing.xxl),
                  // "Studio" in light weight
                  Text(
                    'Studio',
                    style: SLTypography.display.copyWith(
                      color: SLColors.carbon,
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: SLSpacing.xs),
                  // "Letícia" in elegant medium weight
                  Text(
                    'Letícia',
                    style: SLTypography.display.copyWith(
                      color: SLColors.carbon,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: SLSpacing.lg),
                  // Thin gold divider
                  Container(
                    width: 40,
                    height: 1,
                    color: SLColors.champagne,
                  ),
                  const SizedBox(height: SLSpacing.lg),
                  // Tagline
                  Text(
                    'SUA BELEZA, NOSSA HISTÓRIA',
                    style: SLTypography.overline.copyWith(
                      color: SLColors.champagne,
                      letterSpacing: 5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: SLSpacing.xxl),

                  // Loading dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (_, __) {
                          final delay = 0.2 + (i * 0.15);
                          final opacity = _controller.value > delay
                              ? ((_controller.value - delay) / 0.3).clamp(0.0, 1.0)
                              : 0.0;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SLColors.champagne.withValues(alpha: opacity * 0.6),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
