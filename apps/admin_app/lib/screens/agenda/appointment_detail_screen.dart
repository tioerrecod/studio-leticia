import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/providers.dart';

class AppointmentDetailScreen extends ConsumerWidget {
  final String appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentAsync = ref.watch(appointmentByIdProvider(appointmentId));

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: SLColors.surface,
        elevation: 0,
        title: Text(
          'Detalhes do Agendamento',
          style: SLTypography.h3.copyWith(
            color: SLColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SLColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: appointmentAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: SLColors.accentGold),
        ),
        error: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(SLSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off,
                    size: 48, color: SLColors.textDisabled),
                const SizedBox(height: SLSpacing.md),
                Text(
                  'Não foi possível carregar os detalhes.',
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
                      ref.invalidate(appointmentByIdProvider(appointmentId)),
                  label: 'Tentar novamente',
                ),
              ],
            ),
          ),
        ),
        data: (appointment) => _AppointmentDetailContent(
          appointment: appointment,
          ref: ref,
        ),
      ),
    );
  }
}

class _AppointmentDetailContent extends StatelessWidget {
  final Appointment appointment;
  final WidgetRef ref;

  const _AppointmentDetailContent({required this.appointment, required this.ref});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SLSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailHeader(appointment: appointment),
          const SizedBox(height: SLSpacing.lg),
          _InfoSection(appointment: appointment),
          const SizedBox(height: SLSpacing.lg),
          _StatusSection(appointment: appointment),
          const SizedBox(height: SLSpacing.lg),
          _ActionsSection(
            appointment: appointment,
            ref: ref,
          ),
        ],
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final Appointment appointment;

  const _DetailHeader({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return SLCard(
      variant: SLCardVariant.elevated,
      padding: const EdgeInsets.all(SLSpacing.lg),
      child: Column(
        children: [
          Text(
            appointment.formattedTime,
            style: SLTypography.display.copyWith(
              color: SLColors.textPrimary,
            ),
          ),
          const SizedBox(height: SLSpacing.xs),
          Text(
            appointment.formattedDate,
            style: SLTypography.body.copyWith(
              color: SLColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final Appointment appointment;

  const _InfoSection({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return SLCard(
      variant: SLCardVariant.outlined,
      padding: const EdgeInsets.all(SLSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações',
            style: SLTypography.h3.copyWith(
              color: SLColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: SLSpacing.md),
          _InfoRow(
            icon: Icons.person,
            label: 'Cliente',
            value: appointment.customerName ?? '---',
          ),
          const Divider(height: SLSpacing.lg),
          _InfoRow(
            icon: Icons.content_cut,
            label: 'Serviço',
            value: appointment.displayServiceName,
          ),
          if (appointment.displayServicePrice > 0) ...[
            const Divider(height: SLSpacing.lg),
            _InfoRow(
              icon: Icons.attach_money,
              label: 'Valor',
              value: 'R\$ ${appointment.displayServicePrice.toStringAsFixed(2)}',
            ),
          ],
          if (appointment.durationMinutes > 0) ...[
            const Divider(height: SLSpacing.lg),
            _InfoRow(
              icon: Icons.timer,
              label: 'Duração',
              value: '${appointment.durationMinutes} min',
            ),
          ],
          const Divider(height: SLSpacing.lg),
          _InfoRow(
            icon: Icons.badge,
            label: 'Profissional',
            value: appointment.professional?.name ?? '---',
          ),
          if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
            const Divider(height: SLSpacing.lg),
            _InfoRow(
              icon: Icons.notes,
              label: 'Observações',
              value: appointment.notes!,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: SLColors.accentGold),
        const SizedBox(width: SLSpacing.md),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: SLTypography.caption.copyWith(
                  color: SLColors.textSecondary,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: SLTypography.body.copyWith(
                    color: SLColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusSection extends StatelessWidget {
  final Appointment appointment;

  const _StatusSection({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return SLCard(
      variant: SLCardVariant.outlined,
      padding: const EdgeInsets.all(SLSpacing.lg),
      child: Row(
        children: [
          Icon(_statusIcon, color: _statusColor, size: 20),
          const SizedBox(width: SLSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                  ),
                ),
                Text(
                  _statusLabel,
                  style: SLTypography.body.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (appointment.cancellationReason != null)
            Flexible(
              child: Text(
                appointment.cancellationReason!,
                style: SLTypography.caption.copyWith(
                  color: SLColors.textSecondary,
                ),
                textAlign: TextAlign.end,
              ),
            ),
        ],
      ),
    );
  }

  String get _statusLabel {
    switch (appointment.status) {
      case 'scheduled': return 'Agendado';
      case 'confirmed': return 'Confirmado';
      case 'completed': return 'Concluído';
      case 'cancelled': return 'Cancelado';
      case 'no_show': return 'Ausente';
      default: return appointment.status;
    }
  }

  Color get _statusColor {
    switch (appointment.status) {
      case 'confirmed': return SLColors.stateSuccess;
      case 'completed': return SLColors.stateInfo;
      case 'cancelled': return SLColors.stateError;
      case 'no_show': return SLColors.stateError;
      default: return SLColors.stateWarning;
    }
  }

  IconData get _statusIcon {
    switch (appointment.status) {
      case 'confirmed': return Icons.check_circle;
      case 'completed': return Icons.verified;
      case 'cancelled': return Icons.cancel;
      case 'no_show': return Icons.person_off;
      default: return Icons.schedule;
    }
  }
}

class _ActionsSection extends StatelessWidget {
  final Appointment appointment;
  final WidgetRef ref;

  const _ActionsSection({required this.appointment, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isPending = appointment.status == 'scheduled';
    final isConfirmed = appointment.status == 'confirmed';
    final isCompleted = appointment.status == 'completed';
    final isCancelled = appointment.status == 'cancelled' || appointment.status == 'no_show';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações',
          style: SLTypography.h3.copyWith(
            color: SLColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: SLSpacing.md),
        if (isPending) ...[
          SLButton(
            variant: SLButtonVariant.primary,
            isExpanded: true,
            onPressed: () => _updateStatus(context, 'confirmed'),
            label: 'Confirmar Agendamento',
          ),
          const SizedBox(height: SLSpacing.sm),
        ],
        if (isPending || isConfirmed) ...[
          SLButton(
            variant: SLButtonVariant.outline,
            isExpanded: true,
            onPressed: () => _updateStatus(context, 'completed'),
            label: 'Concluir Atendimento',
          ),
          const SizedBox(height: SLSpacing.sm),
          SLButton(
            variant: SLButtonVariant.text,
            isExpanded: true,
            onPressed: () => _showCancelDialog(context),
            label: 'Cancelar Agendamento',
          ),
        ],
        if (isCompleted || isCancelled) ...[
          const SizedBox(height: SLSpacing.sm),
          SLButton(
            variant: SLButtonVariant.text,
            isExpanded: true,
            onPressed: () => _confirmDelete(context),
            label: 'Excluir Agendamento',
          ),
        ],
      ],
    );
  }

  Future<void> _updateStatus(BuildContext context, String status) async {
    try {
      final repository = ref.read(appointmentRepositoryProvider);
      await repository.updateAppointment(appointment.id, status: status);
      ref.invalidate(appointmentByIdProvider(appointment.id));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status atualizado para ${_statusName(status)}'),
            backgroundColor: SLColors.stateSuccess,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: SLColors.stateError,
          ),
        );
      }
    }
  }

  String _statusName(String status) {
    switch (status) {
      case 'confirmed': return 'Confirmado';
      case 'completed': return 'Concluído';
      case 'cancelled': return 'Cancelado';
      default: return status;
    }
  }

  void _showCancelDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SLColors.surface,
        title: Text(
          'Cancelar Agendamento',
          style: SLTypography.h3.copyWith(color: SLColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tem certeza que deseja cancelar este agendamento?',
              style: SLTypography.body.copyWith(color: SLColors.textSecondary),
            ),
            const SizedBox(height: SLSpacing.md),
            TextField(
              controller: controller,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Motivo do cancelamento',
                border: OutlineInputBorder(
                  borderRadius: SLRadius.card,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: SLRadius.card,
                  borderSide: const BorderSide(color: SLColors.accentGold),
                ),
              ),
            ),
          ],
        ),
        actions: [
          SLButton(
            variant: SLButtonVariant.text,
            isExpanded: false,
            onPressed: () => Navigator.pop(ctx),
            label: 'Voltar',
          ),
          SLButton(
            variant: SLButtonVariant.text,
            isExpanded: false,
            onPressed: () async {
              Navigator.pop(ctx);
              await _updateStatus(context, 'cancelled');
            },
            label: 'Confirmar Cancelamento',
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SLColors.surface,
        title: Text(
          'Excluir Agendamento',
          style: SLTypography.h3.copyWith(color: SLColors.error),
        ),
        content: Text(
          'Esta ação não pode ser desfeita. Deseja realmente excluir?',
          style: SLTypography.body.copyWith(color: SLColors.textSecondary),
        ),
        actions: [
          SLButton(
            variant: SLButtonVariant.text,
            isExpanded: false,
            onPressed: () => Navigator.pop(ctx),
            label: 'Cancelar',
          ),
          SLButton(
            variant: SLButtonVariant.text,
            isExpanded: false,
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Implement delete when repository supports it
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Exclusão não disponível no momento'),
                  backgroundColor: SLColors.stateWarning,
                ),
              );
            },
            label: 'Excluir',
          ),
        ],
      ),
    );
  }
}
