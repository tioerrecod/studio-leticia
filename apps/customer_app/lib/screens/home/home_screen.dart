import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import '../../providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDataProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: homeDataAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: SLColors.accentGold),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
              const SizedBox(height: SLSpacing.space4),
              Text('Erro ao carregar dados', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
              const SizedBox(height: SLSpacing.space3),
              TextButton(
                onPressed: () => ref.invalidate(homeDataProvider),
                child: Text('Tentar novamente', style: SLTypography.button.copyWith(color: SLColors.accentGold)),
              ),
            ],
          ),
        ),
        data: (homeData) => SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: SLSpacing.space10),
                  child: SLStudioHeader(
                    onNotificationTap: () {},
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space8)),

              // ── Greeting ─────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, Juliana',
                        style: SLTypography.display.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: SLColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: SLSpacing.space1),
                      Text(
                        'Seu próximo horário',
                        style: SLTypography.body.copyWith(
                          color: SLColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space6)),

              // ── Card Principal ────────────────────────
              if (homeData.nextAppointment != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
                    child:                     SLAppointmentHeroCard(
                      serviceName: homeData.nextAppointment!.displayServiceName,
                      dateLabel: '${homeData.nextAppointment!.formattedDate} • ${homeData.nextAppointment!.formattedTime}',
                      statusLabel: 'CONFIRMADO',
                      imageUrl: '',
                      onTap: () => context.go('/profile/history'),
                      onDetailsTap: () => context.go('/profile/history'),
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6),
                    child: SLCard(
                      variant: SLCardVariant.elevated,
                      padding: const EdgeInsets.all(SLSpacing.space6),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SLColors.accentGold.withValues(alpha: 0.1),
                            ),
                            child: const Icon(Icons.calendar_today_outlined, size: 22, color: SLColors.accentGold),
                          ),
                          const SizedBox(width: SLSpacing.space4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nenhum agendamento', style: SLTypography.h3.copyWith(color: SLColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text('Que tal marcar sua próxima experiência?', style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space8)),

              // ── Agendamentos Section ──────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Agendamentos', style: SLTypography.h3.copyWith(color: SLColors.textPrimary)),
                      GestureDetector(
                        onTap: () => context.go('/profile/history'),
                        child: Text('Ver todos', style: SLTypography.caption.copyWith(color: SLColors.accentGold)),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space4)),

              // ── Atalhos ───────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
                  child: SLShortcutGrid(
                    items: [
                      ShortcutItem(icon: Icons.schedule_outlined, label: 'Meus Horários', onTap: () => context.go('/profile/history')),
                      ShortcutItem(icon: Icons.explore_outlined, label: 'Inspirações', onTap: () => context.go('/services')),
                      ShortcutItem(icon: Icons.favorite_outline, label: 'Favoritos', onTap: () => context.go('/profile/journey')),
                      ShortcutItem(icon: Icons.chat_outlined, label: 'Conversar', onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Em breve você poderá conversar conosco por aqui!'),
                            backgroundColor: SLColors.accentGold,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space8)),

              // ── Fidelity Card ─────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
                  child: SLFidelityCard(
                    points: homeData.loyaltyPoints,
                    onRewardsTap: () {},
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space8)),

              // ── Categorias ────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6),
                  child: Text('Categorias', style: SLTypography.h3.copyWith(color: SLColors.textPrimary)),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space4)),

              ...['Tranças', 'Mega Hair', 'Penteados', 'Noivas', 'Infantil', 'Cursos'].map(
                (category) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4, vertical: SLSpacing.space2),
                    child: SLCategoryCard(
                      name: category,
                      description: 'Descubra o estilo perfeito para você',
                      imageUrl: '',
                      onTap: () => context.go('/services/category/${Uri.encodeComponent(category)}'),
                    ),
                  ),
                ),
              ),

              // ── Bottom padding for nav bar ────────────
              const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space24)),
            ],
          ),
        ),
      ),
    );
  }
}
