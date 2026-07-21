import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/providers.dart';

final _todayAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.read(appointmentRepositoryProvider);
  return repository.getAppointments();
});

class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(_todayAppointmentsProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: appointmentsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: SLColors.accentGold),
          ),
          error: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(appointmentCount: 0),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(SLSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off,
                            size: 48, color: SLColors.textDisabled),
                        const SizedBox(height: SLSpacing.md),
                        Text(
                          'Não foi possível carregar sua agenda.',
                          style: SLTypography.body.copyWith(
                            color: SLColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: SLSpacing.lg),
                        SLButton(
                          variant: SLButtonVariant.outline,
                          isExpanded: false,
                          onPressed: () =>
                              ref.invalidate(_todayAppointmentsProvider),
                          label: 'Tentar novamente',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          data: (appointments) {
            final today = DateTime.now();
            final todayAppointments = appointments.where((a) {
              return a.startAt.year == today.year &&
                  a.startAt.month == today.month &&
                  a.startAt.day == today.day;
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(appointmentCount: todayAppointments.length),
                Expanded(
                  child: todayAppointments.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(SLSpacing.xxl),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.event_busy,
                                    size: 48, color: SLColors.textDisabled),
                                const SizedBox(height: SLSpacing.md),
                                Text(
                                  'Nenhum agendamento para hoje',
                                  style: SLTypography.body.copyWith(
                                    color: SLColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(_todayAppointmentsProvider);
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: SLSpacing.xxl),
                            itemCount: todayAppointments.length,
                            itemBuilder: (context, index) {
                              final a = todayAppointments[index];
                              return SLAppointmentCard(
                                time: a.formattedTime,
                                customerName: a.customerName ?? '---',
                                serviceName: a.displayServiceName,
                                iaSuggestion: _statusLabel(a.status),
                                onTap: () =>
                                    context.push('/agenda/detalhes/${a.id}'),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'scheduled': return 'Agendado';
      case 'confirmed': return 'Confirmado';
      case 'completed': return 'Concluído';
      case 'cancelled': return 'Cancelado';
      case 'no_show': return 'Ausente';
      default: return status;
    }
  }
}

class _Header extends StatelessWidget {
  final int appointmentCount;

  const _Header({required this.appointmentCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SLSpacing.xl, SLSpacing.md, SLSpacing.xl, SLSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Segunda, 13 de julho',
            style: SLTypography.h2.copyWith(
              color: SLColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: SLSpacing.xs),
          Row(
            children: [
              Text(
                '$appointmentCount agendamentos hoje',
                style: SLTypography.caption.copyWith(
                  color: SLColors.textSecondary,
                ),
              ),
              const Spacer(),
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
        ],
      ),
    );
  }
}
