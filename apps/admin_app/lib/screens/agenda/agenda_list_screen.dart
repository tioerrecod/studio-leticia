import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/providers.dart';

final _searchProvider = StateProvider<String>((ref) => '');
final _statusFilterProvider = StateProvider<String?>((ref) => null);

final _allAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.read(appointmentRepositoryProvider);
  return repository.getAppointments();
});

final _filteredAppointmentsProvider = Provider<List<Appointment>>((ref) {
  final appointments = ref.watch(_allAppointmentsProvider).valueOrNull ?? [];
  final search = ref.watch(_searchProvider).toLowerCase();
  final statusFilter = ref.watch(_statusFilterProvider);

  return appointments.where((a) {
    if (search.isNotEmpty) {
      final name = (a.customerName ?? '').toLowerCase();
      final service = (a.serviceName ?? a.service?.name ?? '').toLowerCase();
      if (!name.contains(search) && !service.contains(search)) {
        return false;
      }
    }
    if (statusFilter != null && a.status != statusFilter) {
      return false;
    }
    return true;
  }).toList();
});

class AgendaListScreen extends ConsumerWidget {
  const AgendaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(_allAppointmentsProvider);
    final filtered = ref.watch(_filteredAppointmentsProvider);
    final search = ref.watch(_searchProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: SLColors.surface,
        elevation: 0,
        title: Text(
          'Agenda',
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
      body: Column(
        children: [
          _SearchBar(
            value: search,
            onChanged: (v) => ref.read(_searchProvider.notifier).state = v,
          ),
          _StatusFilterRow(
            current: ref.watch(_statusFilterProvider),
            onChanged: (v) => ref.read(_statusFilterProvider.notifier).state = v,
            totalCount: ref.watch(_allAppointmentsProvider).valueOrNull?.length ?? 0,
          ),
          const SizedBox(height: SLSpacing.sm),
          Expanded(
            child: appointmentsAsync.when(
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
                            ref.invalidate(_allAppointmentsProvider),
                        label: 'Tentar novamente',
                      ),
                    ],
                  ),
                ),
              ),
              data: (_) {
                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(SLSpacing.xxl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off,
                              size: 48, color: SLColors.textDisabled),
                          const SizedBox(height: SLSpacing.md),
                          Text(
                            'Nenhum agendamento encontrado',
                            style: SLTypography.body.copyWith(
                              color: SLColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(_allAppointmentsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: SLSpacing.xxl),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final appointment = filtered[index];
                      return SLAppointmentCard(
                        time: appointment.formattedTime,
                        customerName: appointment.customerName ?? '---',
                        serviceName: appointment.displayServiceName,
                        iaSuggestion: _statusLabel(appointment.status),
                        onTap: () => context.push('/agenda/detalhes/${appointment.id}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
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

class _SearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SLSpacing.md, SLSpacing.md, SLSpacing.md, 0,
      ),
      child: TextField(
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: value,
            selection: TextSelection.collapsed(offset: value.length),
          ),
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Buscar por cliente ou serviço...',
          prefixIcon: const Icon(Icons.search, color: SLColors.textDisabled),
          suffixIcon: value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: SLColors.textSecondary),
                  onPressed: () => onChanged(''),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: SLRadius.card,
            borderSide: const BorderSide(color: SLColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: SLRadius.card,
            borderSide: const BorderSide(color: SLColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: SLRadius.card,
            borderSide: const BorderSide(color: SLColors.accentGold),
          ),
          filled: true,
          fillColor: SLColors.surface,
        ),
      ),
    );
  }
}

class _StatusFilterRow extends StatelessWidget {
  final String? current;
  final ValueChanged<String?> onChanged;
  final int totalCount;

  const _StatusFilterRow({
    required this.current,
    required this.onChanged,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final filters = <String?, String>{
      null: 'Todos ($totalCount)',
      'scheduled': 'Agendado',
      'confirmed': 'Confirmado',
      'completed': 'Concluído',
      'cancelled': 'Cancelado',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: SLSpacing.md,
        vertical: SLSpacing.sm,
      ),
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = current == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: SLSpacing.sm),
            child: GestureDetector(
              onTap: () => onChanged(isSelected ? null : entry.key),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SLSpacing.md,
                  vertical: SLSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? SLColors.accentGold : SLColors.surface,
                  borderRadius: SLRadius.chip,
                  border: Border.all(
                    color: isSelected ? SLColors.accentGold : SLColors.border,
                  ),
                ),
                child: Text(
                  entry.value,
                  style: SLTypography.label.copyWith(
                    color: isSelected
                        ? SLColors.textOnGold
                        : SLColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
