import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/supabase_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(completedAppointmentsProvider);

    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Histórico',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: appointmentsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: SLColors.champagne),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
              const SizedBox(height: SLSpacing.md),
              Text('Erro ao carregar histórico', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
              const SizedBox(height: SLSpacing.sm),
              TextButton(
                onPressed: () => ref.invalidate(completedAppointmentsProvider),
                child: Text('Tentar novamente', style: SLTypography.button.copyWith(color: SLColors.champagne)),
              ),
            ],
          ),
        ),
        data: (appointments) {
          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 64, color: SLColors.textDisabled),
                  const SizedBox(height: SLSpacing.md),
                  Text(
                    'Nenhum agendamento encontrado',
                    style: SLTypography.h3.copyWith(color: SLColors.textSecondary),
                  ),
                  const SizedBox(height: SLSpacing.sm),
                  Text(
                    'Seu histórico aparecerá aqui',
                    style: SLTypography.body.copyWith(color: SLColors.textDisabled),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: SLSpacing.lg,
              vertical: SLSpacing.md,
            ),
            itemCount: appointments.length,
            separatorBuilder: (_, __) => const SizedBox(height: SLSpacing.sm),
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return _AppointmentHistoryCard(appointment: appointment);
            },
          );
        },
      ),
    );
  }
}

class _AppointmentHistoryCard extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentHistoryCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final isCompleted = appointment.status == 'completed';
    final isCancelled = appointment.status == 'cancelled';

    return Container(
      padding: const EdgeInsets.all(SLSpacing.md),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: SLColors.carbon.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? SLColors.success.withValues(alpha: 0.1)
                      : isCancelled
                          ? SLColors.error.withValues(alpha: 0.1)
                          : SLColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check : isCancelled ? Icons.close : Icons.schedule,
                  color: isCompleted ? SLColors.success : isCancelled ? SLColors.error : SLColors.warning,
                  size: 24,
                ),
              ),
              const SizedBox(width: SLSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.serviceName ?? appointment.service?.name ?? 'Servico',
                      style: SLTypography.body.copyWith(
                        color: SLColors.carbon,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'com ${appointment.professional?.name ?? 'Profissional'}',
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'R\$ ${(appointment.servicePrice ?? appointment.service?.price ?? 0).toStringAsFixed(2)}',
                    style: SLTypography.body.copyWith(
                      color: SLColors.carbon,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.formattedDate,
                    style: SLTypography.overline.copyWith(
                      color: SLColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SLSpacing.md),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: SLColors.textDisabled),
              const SizedBox(width: 4),
              Text(
                '${appointment.formattedTime} · ${appointment.serviceDuration ?? appointment.service?.duration ?? 0} min',
                style: SLTypography.overline.copyWith(
                  color: SLColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          if (isCompleted) ...[
            const SizedBox(height: SLSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Navigate to booking with this service
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: SLColors.champagne,
                  side: const BorderSide(color: SLColors.champagne),
                  shape: RoundedRectangleBorder(
                    borderRadius: SLRadius.card,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: SLSpacing.sm,
                  ),
                ),
                child: Text(
                  'Agendar novamente',
                  style: SLTypography.caption.copyWith(
                    color: SLColors.champagne,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}