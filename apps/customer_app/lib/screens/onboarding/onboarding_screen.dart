import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingData(
      emoji: '\u{1F48E}',
      title: 'Sua jornada de beleza',
      subtitle: 'Cada visita ao Studio Let\u00edcia \u00e9 uma experi\u00eancia \u00fanica pensada para real\u00e7ar sua ess\u00eancia.',
    ),
    _OnboardingData(
      emoji: '\u{1F9E0}',
      title: 'Intelig\u00eancia que te conhece',
      subtitle: 'Nossa IA aprende suas prefer\u00eancias e recomenda o tratamento perfeito no momento ideal para voc\u00ea.',
    ),
    _OnboardingData(
      emoji: '\u2728',
      title: 'Pronta para brilhar?',
      subtitle: 'Prepare-se para viver a experi\u00eancia de beleza mais sofisticada da sua vida.',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with skip
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SLSpacing.xl, SLSpacing.md, SLSpacing.xl, 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Text(
                      'Pular',
                      style: SLTypography.bodySmall.copyWith(
                        color: SLColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: SLSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Emoji in elegant circular frame
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: SLColors.surface,
                            border: Border.all(
                              color: SLColors.border,
                              width: 0.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: SLColors.carbon.withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(page.emoji, style: const TextStyle(fontSize: 42)),
                          ),
                        ),
                        const SizedBox(height: SLSpacing.xxxl + SLSpacing.md),

                        // Title
                        Text(
                          page.title,
                          style: SLTypography.h1.copyWith(
                            color: SLColors.carbon,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: SLSpacing.lg),

                        // Gold divider
                        Container(
                          width: 32,
                          height: 1,
                          color: SLColors.champagne,
                        ),
                        const SizedBox(height: SLSpacing.lg),

                        // Subtitle
                        Text(
                          page.subtitle,
                          style: SLTypography.body.copyWith(
                            color: SLColors.textSecondary,
                            height: 1.7,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SLSpacing.xl, SLSpacing.md, SLSpacing.xl, SLSpacing.xxxl,
              ),
              child: Column(
                children: [
                  // Minimal pagination dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? SLColors.carbon : SLColors.divider,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: SLSpacing.xxl),

                  // Premium gold CTA
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: SLRadius.button,
                        gradient: const LinearGradient(
                          colors: [SLColors.champagne, SLColors.gold],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: SLColors.champagne.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: SLColors.textOnDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: SLRadius.button,
                          ),
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1
                              ? 'Continuar'
                              : 'Come\u00e7ar',
                          style: SLTypography.button.copyWith(
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String emoji;
  final String title;
  final String subtitle;

  const _OnboardingData({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });
}
