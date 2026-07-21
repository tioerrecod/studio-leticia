import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      title: 'Bem-vinda ao\nStudio Letícia',
      subtitle: 'Sua experiência de beleza premium começa aqui',
      icon: Icons.spa_outlined,
      gradient: [SLColors.accentGold, SLColors.accentGoldLight],
    ),
    OnboardingPage(
      title: 'Agende com\nFacilidade',
      subtitle: 'Escolha seu horário favorito em poucos toques',
      icon: Icons.calendar_today_outlined,
      gradient: [SLColors.stateSuccess, SLColors.accentGold],
    ),
    OnboardingPage(
      title: 'Experiência\nPersonalizada',
      subtitle: 'Recomendações inteligentes baseadas no seu perfil',
      icon: Icons.auto_awesome_outlined,
      gradient: [SLColors.accentGoldLight, SLColors.accentGold],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: SLButton(
                label: 'Pular',
                variant: SLButtonVariant.text,
                onPressed: () => _navigateToHome(),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _OnboardingPageView(page: _pages[index]);
                },
              ),
            ),

            // Page Indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: SLSpacing.xl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? SLColors.accentGold
                          : SLColors.border,
                      borderRadius: SLRadius.chip,
                    ),
                  ),
                ),
              ),
            ),

            // Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SLSpacing.xl, 0, SLSpacing.xl, SLSpacing.xxl,
              ),
              child: SLButton(
                label: _currentPage < _pages.length - 1 ? 'Próximo' : 'Começar',
                variant: SLButtonVariant.primary,
                isExpanded: true,
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _navigateToHome();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome() {
    context.go('/home');
  }
}

class _OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: page.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.gradient[0].withValues(alpha: 0.3),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 48,
              color: SLColors.surface,
            ),
          ),
          const SizedBox(height: SLSpacing.xxl),

          // Title
          Text(
            page.title,
            style: SLTypography.display.copyWith(
              color: SLColors.textPrimary,
              fontWeight: FontWeight.w300,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SLSpacing.md),

          // Subtitle
          Text(
            page.subtitle,
            style: SLTypography.bodyLarge.copyWith(
              color: SLColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}
