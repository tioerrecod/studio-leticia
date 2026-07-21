import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/providers.dart';
import '../../providers/supabase_providers.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String? serviceId;

  const BookingScreen({super.key, this.serviceId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _currentStep = 1;
  final _pageController = PageController();

  String? _selectedStyle;
  String? _selectedLength;
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedProfessionalId;
  bool _isBooking = false;

  static const _totalSteps = 7;
  static const _stepLabels = [
    'Estilo', 'Comp.', 'Data', 'Hora', 'Resumo', 'Pagar', 'Confirmação',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step < 0 || step >= _totalSteps) return;
    _pageController.animateToPage(
      step,
      duration: SLAnimations.medium,
      curve: SLAnimations.easingStandard,
    );
    setState(() => _currentStep = step);
  }

  void _nextStep() => _goToStep(_currentStep + 1);
  void _previousStep() => _goToStep(_currentStep - 1);

  Future<void> _handleBooking() async {
    setState(() => _isBooking = true);

    try {
      final service = ref.read(bookingServiceProvider).service;
      if (service == null) return;

      final professionals = ref.read(professionalsFromSupabaseProvider).valueOrNull ?? [];
      final professional = professionals.firstWhere(
        (p) => p.id == (_selectedProfessionalId ?? professionals.first.id),
        orElse: () => professionals.first,
      );

      final parts = (_selectedTime ?? '14:00').split(':');
      final date = _selectedDate ?? DateTime.now().add(const Duration(days: 1));
      final dateTime = DateTime(date.year, date.month, date.day,
          int.parse(parts[0]), int.parse(parts[1]));

      final appointment = Appointment(
        id: '',
        customerName: '',
        professionalId: professional.id,
        startAt: dateTime,
        service: service,
        professional: professional,
        dateTime: dateTime,
        status: 'scheduled',
        createdAt: DateTime.now(),
      );

      await ref.read(appointmentRepositoryProvider).createAppointment(appointment);
      ref.read(bookingServiceProvider.notifier).clear();

      if (mounted) {
        _goToStep(6);
      }
    } catch (e) {
      setState(() => _isBooking = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao agendar: $e'), backgroundColor: SLColors.stateError),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesFromSupabaseProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: SLColors.accentGold)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
              const SizedBox(height: SLSpacing.space4),
              Text('Erro ao carregar', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
            ],
          ),
        ),
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_outlined, size: 64, color: SLColors.textDisabled),
                  SizedBox(height: SLSpacing.md),
                  Text(
                    'Nenhum servi\u00e7o dispon\u00edvel no momento',
                    style: SLTypography.body.copyWith(color: SLColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          final service = widget.serviceId != null
              ? services.firstWhere((s) => s.id == widget.serviceId, orElse: () => services.first)
              : services.first;

          if (ref.read(bookingServiceProvider).service?.id != service.id) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(bookingServiceProvider.notifier).setService(service);
            });
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: SLSpacing.space4),
                child: SLStepper(totalSteps: _totalSteps, currentStep: _currentStep),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _currentStep = i),
                  children: [
                    _StyleStep(selected: _selectedStyle, onSelect: (v) { setState(() => _selectedStyle = v); _nextStep(); }),
                    _LengthStep(selected: _selectedLength, onSelect: (v) { setState(() => _selectedLength = v); _nextStep(); }),
                    _DateStep(selected: _selectedDate, onSelect: (v) { setState(() => _selectedDate = v); _nextStep(); }),
                    _TimeStep(selected: _selectedTime, onSelect: (v) { setState(() => _selectedTime = v); _nextStep(); }),
                    _SummaryStep(service: service, selectedDate: _selectedDate, selectedTime: _selectedTime, selectedStyle: _selectedStyle, selectedLength: _selectedLength, onNext: _nextStep),
                    _PaymentStep(isBooking: _isBooking, onConfirm: _handleBooking, onBack: _previousStep),
                    _ConfirmationStep(serviceName: service.name, onHome: () => context.go('/home')),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: SLColors.bgPrimary,
      foregroundColor: SLColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: _currentStep > 0 && _currentStep < 6
          ? IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18), onPressed: _previousStep)
          : null,
      title: Text(
        _currentStep < 6 ? _stepLabels[_currentStep] : '',
        style: SLTypography.h3.copyWith(fontWeight: FontWeight.w400, color: SLColors.textPrimary),
      ),
      centerTitle: true,
    );
  }
}

// ── Step 1: Style ───────────────────────────────────────
class _StyleStep extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  _StyleStep({required this.selected, required this.onSelect});

  static final _styles = ['Box Braids', 'Boho', 'Twist', 'Nagô', 'Fulani', 'Goddess', 'Rasteira', 'Lace Braids'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space2, vertical: SLSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Escolha seu estilo', style: SLTypography.h2.copyWith(color: SLColors.textPrimary)),
                const SizedBox(height: SLSpacing.space1),
                Text('Cada estilo cria uma experiência única.', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: SLSpacing.space12),
              itemCount: _styles.length,
              separatorBuilder: (_, __) => const SizedBox(height: SLSpacing.space3),
              itemBuilder: (_, i) {
                final isSelected = _styles[i] == selected;
                return GestureDetector(
                  onTap: () => onSelect(_styles[i]),
                  child: AnimatedContainer(
                    duration: SLAnimations.fast,
                    padding: const EdgeInsets.all(SLSpacing.space4),
                    decoration: BoxDecoration(
                      color: SLColors.surface,
                      borderRadius: SLRadius.card,
                      border: Border.all(
                        color: isSelected ? SLColors.accentGold : SLColors.border,
                        width: isSelected ? 1.5 : 0.5,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(color: SLColors.accentGold.withValues(alpha: 0.15), blurRadius: 8),
                      ] : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(color: SLColors.bgSecondary, borderRadius: SLRadius.sm),
                          child: Icon(Icons.spa_outlined, color: SLColors.accentGold, size: 22),
                        ),
                        const SizedBox(width: SLSpacing.space4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_styles[i], style: SLTypography.h3.copyWith(color: SLColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text('Estilo de trança', style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: SLColors.accentGold, size: 22)
                        else
                          const Icon(Icons.chevron_right, color: SLColors.textDisabled),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 2: Length ──────────────────────────────────────
class _LengthStep extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  _LengthStep({required this.selected, required this.onSelect});

  static final _lengths = [
    ('Curto', 'Até o ombro'),
    ('Médio', 'Ombro até o meio das costas'),
    ('Longo', 'Meio das costas até a cintura'),
    ('Extra Longo', 'Abaixo da cintura'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space2, vertical: SLSpacing.space4),
            child: Text('Qual comprimento você deseja?', style: SLTypography.h2.copyWith(color: SLColors.textPrimary)),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: SLSpacing.space12),
              itemCount: _lengths.length,
              separatorBuilder: (_, __) => const SizedBox(height: SLSpacing.space3),
              itemBuilder: (_, i) {
                final isSelected = _lengths[i].$1 == selected;
                return GestureDetector(
                  onTap: () => onSelect(_lengths[i].$1),
                  child: AnimatedContainer(
                    duration: SLAnimations.fast,
                    padding: const EdgeInsets.all(SLSpacing.space4),
                    decoration: BoxDecoration(
                      color: SLColors.surface,
                      borderRadius: SLRadius.card,
                      border: Border.all(
                        color: isSelected ? SLColors.accentGold : SLColors.border,
                        width: isSelected ? 1.5 : 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_lengths[i].$1, style: SLTypography.h3.copyWith(color: SLColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text(_lengths[i].$2, style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: SLColors.accentGold, size: 22),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 3: Date ────────────────────────────────────────
class _DateStep extends StatefulWidget {
  final DateTime? selected;
  final ValueChanged<DateTime> onSelect;
  _DateStep({required this.selected, required this.onSelect});

  @override
  State<_DateStep> createState() => _DateStepState();
}

class _DateStepState extends State<_DateStep> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space2, vertical: SLSpacing.space4),
            child: Text('Escolha a data', style: SLTypography.h2.copyWith(color: SLColors.textPrimary)),
          ),
          // Month header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _focusedMonth.month > now.month || _focusedMonth.year > now.year
                    ? () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1))
                    : null,
              ),
              Text(
                '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
                style: SLTypography.h3.copyWith(color: SLColors.textPrimary),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1)),
              ),
            ],
          ),
          const SizedBox(height: SLSpacing.space4),
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'].map((d) =>
              SizedBox(width: 36, child: Text(d, textAlign: TextAlign.center,
                style: SLTypography.caption.copyWith(color: SLColors.textSecondary, fontWeight: FontWeight.w600))),
            ).toList(),
          ),
          const SizedBox(height: SLSpacing.space3),
          // Days grid
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, childAspectRatio: 1, mainAxisSpacing: 4, crossAxisSpacing: 4,
              ),
              itemCount: firstWeekday + daysInMonth,
              itemBuilder: (_, i) {
                if (i < firstWeekday) return const SizedBox();
                final day = i - firstWeekday + 1;
                final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
                final isPast = date.isBefore(DateTime(now.year, now.month, now.day));
                final isSelected = widget.selected != null &&
                    widget.selected!.year == date.year &&
                    widget.selected!.month == date.month &&
                    widget.selected!.day == date.day;

                return GestureDetector(
                  onTap: isPast ? null : () => widget.onSelect(date),
                  child: AnimatedContainer(
                    duration: SLAnimations.fast,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? SLColors.accentGold : null,
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: SLTypography.bodySmall.copyWith(
                          color: isPast
                              ? SLColors.textDisabled
                              : isSelected
                                  ? SLColors.textOnDark
                                  : SLColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Legend
          Padding(
            padding: const EdgeInsets.only(bottom: SLSpacing.space8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(SLColors.accentGold, 'Disponível'),
                const SizedBox(width: SLSpacing.space4),
                _legendDot(SLColors.stateWarning.withValues(alpha: 0.5), 'Poucas vagas'),
                const SizedBox(width: SLSpacing.space4),
                _legendDot(SLColors.textDisabled, 'Indisponível'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text(label, style: SLTypography.caption.copyWith(color: SLColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  String _monthName(int m) => ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'][m - 1];
}

// ── Step 4: Time ────────────────────────────────────────
class _TimeStep extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  _TimeStep({required this.selected, required this.onSelect});

  static final _times = ['09:00','09:30','10:00','10:30','11:00','11:30','13:00','13:30','14:00','14:30','15:00','15:30','16:00','16:30','17:00'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space2, vertical: SLSpacing.space4),
            child: Text('Escolha seu horário', style: SLTypography.h2.copyWith(color: SLColors.textPrimary)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: SLSpacing.space12),
              child: Wrap(
                spacing: SLSpacing.space3,
                runSpacing: SLSpacing.space3,
                children: _times.map((time) {
                  final isSelected = time == selected;
                  return GestureDetector(
                    onTap: () => onSelect(time),
                    child: AnimatedContainer(
                      duration: SLAnimations.fast,
                      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6, vertical: SLSpacing.space3),
                      decoration: BoxDecoration(
                        color: isSelected ? SLColors.accentGold : SLColors.surface,
                        borderRadius: SLRadius.input,
                        border: Border.all(
                          color: isSelected ? SLColors.accentGold : SLColors.border,
                          width: isSelected ? 1 : 0.5,
                        ),
                      ),
                      child: Text(time, style: SLTypography.bodySmall.copyWith(
                        color: isSelected ? SLColors.textOnDark : SLColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      )),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 5: Summary ──────────────────────────────────────
class _SummaryStep extends StatelessWidget {
  final ServiceItem service;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? selectedStyle;
  final String? selectedLength;
  final VoidCallback onNext;

  _SummaryStep({required this.service, this.selectedDate, this.selectedTime, this.selectedStyle, this.selectedLength, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final dateStr = selectedDate != null
        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
        : 'A definir';
    final timeStr = selectedTime ?? 'A definir';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space2, vertical: SLSpacing.space4),
            child: Text('Resumo do agendamento', style: SLTypography.h2.copyWith(color: SLColors.textPrimary)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: SLSpacing.space8),
              children: [
                SLCard(
                  child: Column(
                    children: [
                      _SummaryRow(icon: Icons.spa_outlined, label: 'Serviço', value: service.name),
                      const Divider(height: 1, color: SLColors.divider),
                      _SummaryRow(icon: Icons.person_outline, label: 'Profissional', value: 'Letícia'),
                      const Divider(height: 1, color: SLColors.divider),
                      if (selectedStyle != null)
                        ...[_SummaryRow(icon: Icons.style_outlined, label: 'Estilo', value: selectedStyle!), const Divider(height: 1, color: SLColors.divider)],
                      if (selectedLength != null)
                        ...[_SummaryRow(icon: Icons.straighten_outlined, label: 'Comprimento', value: selectedLength!), const Divider(height: 1, color: SLColors.divider)],
                      _SummaryRow(icon: Icons.calendar_today_outlined, label: 'Data', value: dateStr),
                      const Divider(height: 1, color: SLColors.divider),
                      _SummaryRow(icon: Icons.schedule_outlined, label: 'Horário', value: timeStr),
                      const Divider(height: 1, color: SLColors.divider),
                      _SummaryRow(icon: Icons.timer_outlined, label: 'Duração', value: '${service.duration} min'),
                    ],
                  ),
                ),
                const SizedBox(height: SLSpacing.space6),
                // Payment preview
                SLCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Serviço', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
                          Text(service.formattedPrice, style: SLTypography.body.copyWith(color: SLColors.textPrimary)),
                        ],
                      ),
                      const SizedBox(height: SLSpacing.space2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sinal (30%)', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
                          Text('R\$ ${(service.price * 0.3).toStringAsFixed(0)}', style: SLTypography.body.copyWith(color: SLColors.textPrimary)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: SLSpacing.space3),
                        child: Divider(height: 1, color: SLColors.divider),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: SLTypography.h3.copyWith(color: SLColors.textPrimary)),
                          Text(service.formattedPrice, style: SLTypography.price.copyWith(color: SLColors.accentGold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SLSpacing.space8),
                SLButton(label: 'CONTINUAR PARA PAGAMENTO', onPressed: onNext, icon: Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  _SummaryRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SLSpacing.space4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: SLColors.accentGold),
          const SizedBox(width: SLSpacing.space3),
          Text(label, style: SLTypography.overline.copyWith(color: SLColors.textSecondary, letterSpacing: 1.5)),
          const Spacer(),
          Text(value, style: SLTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, color: SLColors.textPrimary)),
        ],
      ),
    );
  }
}

// ── Step 6: Payment ────────────────────────────────────
class _PaymentStep extends StatelessWidget {
  final bool isBooking;
  final VoidCallback onConfirm;
  final VoidCallback onBack;
  _PaymentStep({required this.isBooking, required this.onConfirm, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SLSpacing.space8),
          Text('Forma de pagamento', style: SLTypography.h2.copyWith(color: SLColors.textPrimary)),
          const SizedBox(height: SLSpacing.space6),
          _PaymentOption(icon: Icons.pix_outlined, title: 'PIX', description: 'Pagamento instantâneo', isSelected: true),
          const SizedBox(height: SLSpacing.space3),
          _PaymentOption(icon: Icons.credit_card_outlined, title: 'Cartão', description: 'Crédito ou débito'),
          const SizedBox(height: SLSpacing.space3),
          _PaymentOption(icon: Icons.money_outlined, title: 'Dinheiro', description: 'Pagamento no local'),
          const Spacer(),
          SLButton(label: 'CONFIRMAR AGENDAMENTO', isLoading: isBooking, onPressed: isBooking ? null : onConfirm),
          const SizedBox(height: SLSpacing.space3),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 14, color: SLColors.textDisabled),
                const SizedBox(width: 4),
                Text('Ambiente 100% Seguro', style: SLTypography.caption.copyWith(color: SLColors.textDisabled)),
              ],
            ),
          ),
          const SizedBox(height: SLSpacing.space6),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  _PaymentOption({required this.icon, required this.title, required this.description, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SLSpacing.space4),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: isSelected ? SLColors.accentGold : SLColors.border, width: isSelected ? 1.5 : 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: SLColors.accentGold),
          const SizedBox(width: SLSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: SLTypography.h3.copyWith(color: SLColors.textPrimary)),
                Text(description, style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
              ],
            ),
          ),
          Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
               size: 22, color: isSelected ? SLColors.accentGold : SLColors.textDisabled),
        ],
      ),
    );
  }
}

// ── Step 7: Confirmation ───────────────────────────────
class _ConfirmationStep extends StatelessWidget {
  final String serviceName;
  final VoidCallback onHome;
  _ConfirmationStep({required this.serviceName, required this.onHome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SLColors.stateSuccess.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.check_circle, size: 44, color: SLColors.stateSuccess),
          ),
          const SizedBox(height: SLSpacing.space6),
          Text('Sua experiência está\nconfirmada!',
            textAlign: TextAlign.center,
            style: SLTypography.display.copyWith(fontSize: 28, fontWeight: FontWeight.w300, color: SLColors.textPrimary, height: 1.2),
          ),
          const SizedBox(height: SLSpacing.space3),
          Text('Estamos ansiosos para receber você.',
            style: SLTypography.body.copyWith(color: SLColors.textSecondary),
          ),
          const SizedBox(height: SLSpacing.space8),
          SLCard(
            child: Column(
              children: [
                _TimelineRow(icon: Icons.event_outlined, label: serviceName),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: SLSpacing.space8),
                  child: Divider(height: 1, color: SLColors.divider),
                ),
                _TimelineRow(icon: Icons.schedule_outlined, label: '14:00'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: SLSpacing.space8),
                  child: Divider(height: 1, color: SLColors.divider),
                ),
                _TimelineRow(icon: Icons.location_on_outlined, label: 'Studio Letícia'),
              ],
            ),
          ),
          const SizedBox(height: SLSpacing.space4),
          SLButton(label: 'Adicionar ao calendário', variant: SLButtonVariant.outline, isExpanded: true),
          const Spacer(flex: 2),
          SLButton(label: 'VOLTAR PARA HOME', onPressed: onHome, icon: Icons.home_outlined),
          const SizedBox(height: SLSpacing.space6),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final IconData icon;
  final String label;
  _TimelineRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SLSpacing.space4, horizontal: SLSpacing.space4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: SLColors.accentGold),
          const SizedBox(width: SLSpacing.space3),
          Text(label, style: SLTypography.body.copyWith(color: SLColors.textPrimary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
