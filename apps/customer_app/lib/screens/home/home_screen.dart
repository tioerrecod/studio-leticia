import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import '../../providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeDataProvider);

    return Scaffold(
      backgroundColor: SLColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Editorial Hero ──────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 520,
              width: double.infinity,
              child: Stack(
                children: [
                  // Full-bleed image
                  Positioned.fill(
                    child: Image.network(
                      homeData.heroImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [SLColors.sage.withValues(alpha: 0.4), SLColors.carbon],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Gradient overlay — subtle, editorial
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            SLColors.carbon.withValues(alpha: 0.3),
                            SLColors.carbon.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    left: SLSpacing.xl,
                    right: SLSpacing.xl,
                    bottom: SLSpacing.xxxl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Overline tag
                        Text(
                          homeData.tagline.toUpperCase(),
                          style: SLTypography.overline.copyWith(
                            color: SLColors.champagne,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: SLSpacing.sm),
                        // Main headline
                        Text(
                          'Bem-vinda novamente,\n${homeData.studioName.split(' ').first}',
                          style: SLTypography.display.copyWith(
                            color: SLColors.ivory,
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: SLSpacing.sm),
                        Text(
                          'Sua pr\u00f3xima experi\u00eancia est\u00e1 esperando',
                          style: SLTypography.bodyLarge.copyWith(
                            color: SLColors.textOnDark.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: SLSpacing.xl),
                        // Gold CTA — like a jewelry piece
                        SizedBox(
                          width: 220,
                          height: 52,
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
                                  color: SLColors.champagne.withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => context.go('/services'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: SLColors.textOnDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: SLRadius.button,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Agendar experi\u00eancia',
                                    style: SLTypography.buttonSmall.copyWith(
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(width: SLSpacing.xs),
                                  const Icon(Icons.arrow_forward, size: 16),
                                ],
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
          ),

          // ── Spacer ──────────────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.xl)),

          // ── Next Appointment (Experience Pass) ──────
          if (homeData.nextAppointment != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: SLSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: SLSpacing.md + SLSpacing.xs,
                        bottom: SLSpacing.sm,
                      ),
                      child: Text(
                        'SUA PR\u00d3XIMA EXPERI\u00caNCIA',
                        style: SLTypography.overline.copyWith(
                          color: SLColors.champagne,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    SLExperiencePass(
                      day: homeData.nextAppointment!.formattedDate.split(' ').first,
                      month: homeData.nextAppointment!.formattedDate.split(' ').last,
                      time: homeData.nextAppointment!.formattedTime,
                      serviceName: homeData.nextAppointment!.service.name,
                      professionalName: homeData.nextAppointment!.professional.name,
                      duration: homeData.nextAppointment!.service.duration,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SLSpacing.xl,
                  vertical: SLSpacing.xxl,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: SLColors.cream,
                      ),
                      child: const Icon(
                        Icons.spa_outlined,
                        size: 24,
                        color: SLColors.champagne,
                      ),
                    ),
                    const SizedBox(height: SLSpacing.lg),
                    Text(
                      'Que tal come\u00e7ar sua experi\u00eancia hoje?',
                      style: SLTypography.h2.copyWith(
                        color: SLColors.carbon,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SLSpacing.sm),
                    Text(
                      'Descubra servi\u00e7os pensados para real\u00e7ar sua ess\u00eancia.',
                      style: SLTypography.body.copyWith(
                        color: SLColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SLSpacing.xl),
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: SLRadius.button,
                          gradient: const LinearGradient(
                            colors: [SLColors.champagne, SLColors.gold],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () => context.go('/services'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: SLColors.textOnDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: SLRadius.button,
                            ),
                          ),
                          child: const Text('Ver experi\u00eancias'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Beauty Concierge ────────────────────────
          if (homeData.aiConciergeMessage != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: SLSpacing.lg),
                child: SLBeautyConcierge(
                  clientName: 'Let\u00edcia',
                  message: homeData.aiConciergeMessage!,
                  actionLabel: 'Ver recomenda\u00e7\u00e3o',
                  onAction: () {},
                  onDismiss: () {},
                ),
              ),
            ),

          // ── Section: Experi\u00eancias ────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SLSpacing.md + SLSpacing.xs,
                SLSpacing.xl,
                SLSpacing.md + SLSpacing.xs,
                SLSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Experi\u00eancias',
                    style: SLTypography.h2.copyWith(
                      color: SLColors.carbon,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/services'),
                    child: Text(
                      'Ver todas',
                      style: SLTypography.caption.copyWith(
                        color: SLColors.champagne,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Service cards
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final service = homeData.upcomingServices[i];
                return SLServiceExperience(
                  imageUrl: service.imageUrl ?? '',
                  title: service.name,
                  tagline: service.isSignature ? 'Experi\u00eancia exclusiva' : service.category,
                  resultDescription: service.description,
                  duration: service.duration,
                  price: service.formattedPrice,
                  isSignature: service.isSignature,
                  onSelect: () => context.go('/services/book?service=${service.id}'),
                );
              },
              childCount: homeData.upcomingServices.length,
            ),
          ),

          // ── Loyalty Passport Preview ────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SLSpacing.md, SLSpacing.xxl, SLSpacing.md, SLSpacing.huge,
              ),
              child: Container(
                padding: const EdgeInsets.all(SLSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: SLRadius.card,
                  color: SLColors.surface,
                  border: Border.all(color: SLColors.border, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: SLColors.carbon.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: SLColors.cream,
                      ),
                      child: const Center(
                        child: Icon(Icons.card_membership, color: SLColors.champagne, size: 20),
                      ),
                    ),
                    const SizedBox(width: SLSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${homeData.loyaltyPoints} pontos',
                            style: SLTypography.h3.copyWith(color: SLColors.carbon),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${homeData.lifetimeVisits} visitas \u00b7 Fidelidade Studio Let\u00edcia',
                            style: SLTypography.caption.copyWith(
                              color: SLColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SLSpacing.sm,
                        vertical: SLSpacing.mini,
                      ),
                      decoration: BoxDecoration(
                        color: SLColors.champagne.withValues(alpha: 0.1),
                        borderRadius: SLRadius.chip,
                      ),
                      child: Text(
                        'OURO',
                        style: SLTypography.overline.copyWith(
                          color: SLColors.gold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
