import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import '../../providers/providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(dashboardMetricsProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SLSpacing.xl, SLSpacing.xl, SLSpacing.xl, SLSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Command Center',
                      style: SLTypography.h2.copyWith(
                        color: SLColors.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: SLSpacing.xs),
                    Text(
                      'Studio Let\u00edcia',
                      style: SLTypography.bodySmall.copyWith(
                        color: SLColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: SLSpacing.md),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: SLSpacing.sm,
                  crossAxisSpacing: SLSpacing.sm,
                  childAspectRatio: 1.6,
                ),
                delegate: SliverChildListDelegate([
                  metrics.when(
                    data: (m) => SLKpiMetric(
                      icon: Icons.trending_up,
                      label: 'Faturamento',
                      value: m.formattedRevenue,
                      change: '+${m.revenueChange}%',
                      isPositive: true,
                    ),
                    loading: () => const SLKpiMetric(
                      icon: Icons.trending_up,
                      label: 'Faturamento',
                      value: '...',
                      change: '',
                      isPositive: true,
                    ),
                    error: (_, __) => const SLKpiMetric(
                      icon: Icons.trending_up,
                      label: 'Faturamento',
                      value: '--',
                      change: '',
                      isPositive: true,
                    ),
                  ),
                  metrics.when(
                    data: (m) => SLKpiMetric(
                      icon: Icons.people,
                      label: 'Clientes Ativos',
                      value: '${m.activeClients}',
                      change: '+${m.activeClientsChange}%',
                      isPositive: true,
                    ),
                    loading: () => const SLKpiMetric(
                      icon: Icons.people,
                      label: 'Clientes Ativos',
                      value: '...',
                      change: '',
                      isPositive: true,
                    ),
                    error: (_, __) => const SLKpiMetric(
                      icon: Icons.people,
                      label: 'Clientes Ativos',
                      value: '--',
                      change: '',
                      isPositive: true,
                    ),
                  ),
                  metrics.when(
                    data: (m) => SLKpiMetric(
                      icon: Icons.calendar_today,
                      label: 'Agendamentos Hoje',
                      value: '${m.todayAppointments}',
                      change: '${m.appointmentsChange}%',
                      isPositive: false,
                    ),
                    loading: () => const SLKpiMetric(
                      icon: Icons.calendar_today,
                      label: 'Agendamentos Hoje',
                      value: '...',
                      change: '',
                      isPositive: false,
                    ),
                    error: (_, __) => const SLKpiMetric(
                      icon: Icons.calendar_today,
                      label: 'Agendamentos Hoje',
                      value: '--',
                      change: '',
                      isPositive: false,
                    ),
                  ),
                  metrics.when(
                    data: (m) => SLKpiMetric(
                      icon: Icons.auto_awesome,
                      label: 'Previs\u00e3o Retorno',
                      value: '${m.returnPrediction}%',
                      change: '${m.aiRecommendations} insights',
                      isPositive: true,
                    ),
                    loading: () => const SLKpiMetric(
                      icon: Icons.auto_awesome,
                      label: 'Previs\u00e3o Retorno',
                      value: '...',
                      change: '',
                      isPositive: true,
                    ),
                    error: (_, __) => const SLKpiMetric(
                      icon: Icons.auto_awesome,
                      label: 'Previs\u00e3o Retorno',
                      value: '--',
                      change: '',
                      isPositive: true,
                    ),
                  ),
                ]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SLSpacing.xl, SLSpacing.xxl, SLSpacing.xl, SLSpacing.sm,
                ),
                child: Text(
                  'INSIGHTS DA IA',
                  style: SLTypography.overline.copyWith(
                    color: SLColors.accentGold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SLBeautyConcierge(
                clientName: 'Equipe',
                message:
                    'Rafaela n\u00e3o visita h\u00e1 3 semanas. Clientes com esse perfil t\u00eam 78% de chance de reativar com uma oferta personalizada.',
                actionLabel: 'Criar oferta',
                onAction: () {},
                onDismiss: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SLSpacing.xl, SLSpacing.xl, SLSpacing.xl, SLSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Agenda de hoje',
                      style: SLTypography.h3.copyWith(
                        color: SLColors.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/agenda/completa'),
                      child: Text(
                        'Ver todas',
                        style: SLTypography.caption.copyWith(
                          color: SLColors.accentGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SLAppointmentCard(
                time: '09:00',
                customerName: 'Rafaela',
                serviceName: 'Hidrata\u00e7\u00e3o Premium',
                rating: '5.0',
                iaSuggestion: 'Confirmado',
                onTap: () => context.push('/agenda/detalhes/1'),
              ),
            ),
            SliverToBoxAdapter(
              child: SLAppointmentCard(
                time: '10:30',
                customerName: 'Mariana',
                serviceName: 'Corte Personalizado',
                iaSuggestion: 'Aguardando',
                onTap: () => context.push('/agenda/detalhes/2'),
              ),
            ),
            SliverToBoxAdapter(
              child: SLAppointmentCard(
                time: '14:00',
                customerName: 'Ana Beatriz',
                serviceName: 'Colora\u00e7\u00e3o + Corte',
                rating: '4.5',
                onTap: () => context.push('/agenda/detalhes/3'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.huge)),
          ],
        ),
      ),
    );
  }
}
