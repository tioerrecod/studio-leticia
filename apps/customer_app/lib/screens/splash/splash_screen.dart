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
  late final Animation<double> _photoFade;
  late final Animation<double> _contentFade;
  late final Animation<double> _ctaFade;
  late final Animation<double> _monogramFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _photoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _ctaFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
      ),
    );

    _monogramFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final safeTop = MediaQuery.of(context).padding.top;
    final heroHeight = (height - safeTop) * 0.75;

    return Scaffold(
      backgroundColor: SLColors.bgInverse,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Stack(
          children: [
            // ── Hero Photo ──────────────────────────────
            Positioned(
              top: safeTop,
              left: 0,
              right: 0,
              height: heroHeight,
              child: FadeTransition(
                opacity: _photoFade,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2A2420), Color(0xFF1C1815)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.woman_rounded,
                      size: 180,
                      color: SLColors.accentGold.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              ),
            ),

            // ── Gradient Overlay ─────────────────────────
            Positioned(
              top: safeTop,
              left: 0,
              right: 0,
              height: heroHeight,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        SLColors.bgInverse.withValues(alpha: 0.3),
                        SLColors.bgInverse.withValues(alpha: 0.85),
                        SLColors.bgInverse,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Logo + Text Content ──────────────────────
            Positioned(
              left: 28,
              right: 28,
              top: safeTop + heroHeight * 0.42,
              child: FadeTransition(
                opacity: _contentFade,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Studio Letícia',
                      style: SLTypography.display.copyWith(
                        fontSize: 42,
                        height: 1.1,
                        color: SLColors.textInverse,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, top: 6),
                      child: Text(
                        'EXPERIENCE',
                        style: SLTypography.label.copyWith(
                          color: SLColors.accentGold,
                          fontSize: 11,
                          letterSpacing: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'BELEZA QUE TRANSFORMA.\nEXPERIÊNCIAS QUE MARCAM.',
                      style: SLTypography.body.copyWith(
                        color: SLColors.textInverse.withValues(alpha: 0.8),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Bem-vinda ao seu novo jeito de viver\na beleza como uma experiência exclusiva.',
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textInverse.withValues(alpha: 0.5),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── CTA Button ──────────────────────────────
            Positioned(
              left: 28,
              right: 28,
              top: safeTop + heroHeight + 24,
              child: FadeTransition(
                opacity: _ctaFade,
                child: SLButton(
                  label: 'AGENDAR EXPERIÊNCIA',
                  onPressed: () => context.go('/auth-choice'),
                  height: 56,
                  icon: Icons.arrow_forward,
                ),
              ),
            ),

            // ── Monogram ────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 24,
              child: FadeTransition(
                opacity: _monogramFade,
                child: Text(
                  'SL',
                  textAlign: TextAlign.center,
                  style: SLTypography.label.copyWith(
                    color: SLColors.textInverse.withValues(alpha: 0.25),
                    fontSize: 14,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
