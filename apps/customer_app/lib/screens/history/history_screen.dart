import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/supabase_providers.dart';

final _sampleAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  return [
    Appointment(
      id: '1',
      professionalId: 'p1',
      professional: const Professional(id: 'p1', name: 'Letícia'),
      startAt: DateTime(2026, 6, 15, 14, 0),
      endAt: DateTime(2026, 6, 15, 15, 30),
      status: 'completed',
      totalAmount: 220.00,
      servicePrice: 220.00,
      serviceName: 'Corte Personalizado',
      serviceDuration: 90,
      createdAt: DateTime(2026, 6, 10),
    ),
    Appointment(
      id: '2',
      professionalId: 'p1',
      professional: const Professional(id: 'p1', name: 'Letícia'),
      startAt: DateTime(2026, 6, 8, 10, 0),
      endAt: DateTime(2026, 6, 8, 11, 0),
      status: 'completed',
      totalAmount: 150.00,
      servicePrice: 150.00,
      serviceName: 'Hidratação Capilar',
      serviceDuration: 60,
      createdAt: DateTime(2026, 6, 3),
    ),
    Appointment(
      id: '3',
      professionalId: 'p1',
      professional: const Professional(id: 'p1', name: 'Letícia'),
      startAt: DateTime(2026, 5, 28, 16, 0),
      endAt: DateTime(2026, 5, 28, 17, 0),
      status: 'completed',
      totalAmount: 180.00,
      servicePrice: 180.00,
      serviceName: 'Design de Sobrancelhas',
      serviceDuration: 60,
      createdAt: DateTime(2026, 5, 20),
    ),
    Appointment(
      id: '4',
      professionalId: 'p2',
      professional: const Professional(id: 'p2', name: 'Camila'),
      startAt: DateTime(2026, 5, 20, 9, 0),
      endAt: DateTime(2026, 5, 20, 10, 30),
      status: 'cancelled',
      totalAmount: 190.00,
      servicePrice: 190.00,
      serviceName: 'Manicure em Gel',
      serviceDuration: 90,
      createdAt: DateTime(2026, 5, 15),
    ),
    Appointment(
      id: '5',
      professionalId: 'p1',
      professional: const Professional(id: 'p1', name: 'Letícia'),
      startAt: DateTime(2026, 5, 12, 15, 0),
      endAt: DateTime(2026, 5, 12, 16, 0),
      status: 'completed',
      totalAmount: 350.00,
      servicePrice: 350.00,
      serviceName: 'Penteado para Evento',
      serviceDuration: 60,
      createdAt: DateTime(2026, 5, 5),
    ),
    Appointment(
      id: '6',
      professionalId: 'p2',
      professional: const Professional(id: 'p2', name: 'Camila'),
      startAt: DateTime(2026, 4, 30, 11, 0),
      endAt: DateTime(2026, 4, 30, 12, 0),
      status: 'completed',
      totalAmount: 120.00,
      servicePrice: 120.00,
      serviceName: 'Escova Modeladora',
      serviceDuration: 60,
      createdAt: DateTime(2026, 4, 25),
    ),
  ];
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(completedAppointmentsProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: appointmentsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: SLColors.accentGold),
          ),
          error: (_, __) => _HistoryContent(
            provider: _sampleAppointmentsProvider,
          ),
          data: (appointments) {
            if (appointments.isEmpty) {
              return _EmptyHistory(ref: ref);
            }
            return _HistoryList(appointments: appointments);
          },
        ),
      ),
    );
  }
}

class _HistoryContent extends ConsumerWidget {
  final FutureProvider<List<Appointment>> provider;

  const _HistoryContent({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);

    return async.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: SLColors.accentGold),
      ),
      error: (_, __) => _EmptyHistory(ref: ref),
      data: (appointments) {
        if (appointments.isEmpty) {
          return _EmptyHistory(ref: ref);
        }
        return _HistoryList(appointments: appointments);
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final WidgetRef? ref;

  const _EmptyHistory({this.ref});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64, color: SLColors.textDisabled),
            const SizedBox(height: SLSpacing.space4),
            Text(
              'Nenhum agendamento encontrado',
              style: SLTypography.h3.copyWith(color: SLColors.textSecondary),
            ),
            const SizedBox(height: SLSpacing.space2),
            Text(
              'Seus atendimentos concluídos aparecerão aqui',
              style: SLTypography.body.copyWith(color: SLColors.textDisabled),
              textAlign: TextAlign.center,
            ),
            if (ref != null) ...[
              const SizedBox(height: SLSpacing.space6),
              SLButton(
                onPressed: () => ref!.invalidate(completedAppointmentsProvider),
                label: 'Tentar novamente',
                variant: SLButtonVariant.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<Appointment> appointments;

  const _HistoryList({required this.appointments});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              SLSpacing.space6,
              SLSpacing.space10,
              SLSpacing.space6,
              SLSpacing.space4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Histórico',
                  style: SLTypography.display.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: SLColors.textPrimary,
                  ),
                ),
                const SizedBox(height: SLSpacing.space1),
                Text(
                  'Seus atendimentos',
                  style: SLTypography.body.copyWith(color: SLColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final appointment = appointments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: SLSpacing.space4),
                  child: _AppointmentHistoryCard(appointment: appointment),
                );
              },
              childCount: appointments.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _AppointmentHistoryCard extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentHistoryCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final day = appointment.startAt.day.toString().padLeft(2, '0');
    final months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
    final month = months[appointment.startAt.month - 1];

    return SLCard(
      variant: SLCardVariant.outlined,
      padding: const EdgeInsets.all(SLSpacing.space4),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Agendamento: ${appointment.displayServiceName} em ${appointment.formattedDate}'),
            backgroundColor: SLColors.accentGold,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                day,
                style: SLTypography.h2.copyWith(
                  color: SLColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                month,
                style: SLTypography.caption.copyWith(
                  color: SLColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: SLSpacing.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.serviceName ?? 'Serviço',
                  style: SLTypography.h3.copyWith(color: SLColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  'com ${appointment.professional?.name ?? 'Profissional'}',
                  style: SLTypography.caption.copyWith(color: SLColors.textSecondary),
                ),
                const SizedBox(height: SLSpacing.space2),
                _StatusBadge(status: appointment.status),
              ],
            ),
          ),
          const SizedBox(width: SLSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${(appointment.servicePrice ?? appointment.totalAmount ?? 0).toStringAsFixed(2)}',
                style: SLTypography.price.copyWith(color: SLColors.textPrimary),
              ),
              const SizedBox(height: SLSpacing.space1),
              Icon(Icons.chevron_right, size: 20, color: SLColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'completed':
        return SLBadge(
          label: 'Concluído',
          variant: SLBadgeVariant.success,
        );
      case 'cancelled':
        return SLBadge(
          label: 'Cancelado',
          variant: SLBadgeVariant.error,
        );
      default:
        return SLBadge(
          label: status,
          variant: SLBadgeVariant.info,
        );
    }
  }
}
