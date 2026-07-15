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
  String? _selectedProfessionalId;
  String? _selectedTime;
  final _notesController = TextEditingController();
  bool _isBooking = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleBooking(List<ServiceItem> services) async {
    if (_selectedProfessionalId == null || _selectedTime == null) return;

    final bookingState = ref.read(bookingServiceProvider);
    final service = bookingState.service;
    if (service == null) return;

    final professionalsAsync = ref.read(professionalsFromSupabaseProvider);
    final professionals = professionalsAsync.valueOrNull ?? [];
    final professional = professionals.firstWhere(
      (p) => p.id == _selectedProfessionalId,
      orElse: () => professionals.first,
    );

    setState(() => _isBooking = true);

    try {
      final parts = _selectedTime!.split(':');
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day + 1,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

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
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      final repository = ref.read(appointmentRepositoryProvider);
      await repository.createAppointment(appointment);

      ref.read(bookingServiceProvider.notifier).clear();

      if (mounted) {
        context.go('/services/confirm');
      }
    } catch (e) {
      setState(() => _isBooking = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao agendar: $e'),
            backgroundColor: SLColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesFromSupabaseProvider);
    final professionalsAsync = ref.watch(professionalsFromSupabaseProvider);
    final bookingState = ref.watch(bookingServiceProvider);

    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Agendar',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: servicesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: SLColors.champagne),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
              const SizedBox(height: SLSpacing.md),
              Text('Erro ao carregar dados', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
            ],
          ),
        ),
        data: (services) {
          final service = widget.serviceId != null
              ? services.firstWhere(
                  (s) => s.id == widget.serviceId,
                  orElse: () => services.isNotEmpty ? services.first : ServiceItem.empty(),
                )
              : services.isNotEmpty ? services.first : ServiceItem.empty();

          if (service.id.isNotEmpty && bookingState.service?.id != service.id) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(bookingServiceProvider.notifier).setService(service);
            });
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      SLSpacing.md, SLSpacing.sm, SLSpacing.md, 0),
                  child: Container(
                    padding: const EdgeInsets.all(SLSpacing.lg),
                    decoration: BoxDecoration(
                      color: SLColors.surface,
                      borderRadius: SLRadius.card,
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
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: SLColors.cream,
                            borderRadius: SLRadius.input,
                          ),
                          child: const Icon(Icons.spa_outlined,
                              color: SLColors.champagne, size: 22),
                        ),
                        const SizedBox(width: SLSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(service.name,
                                  style: SLTypography.h3
                                      .copyWith(color: SLColors.carbon)),
                              const SizedBox(height: SLSpacing.mini),
                              Text(
                                '${service.duration} \u00b7 ${service.formattedPrice}',
                                style: SLTypography.caption
                                    .copyWith(color: SLColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    SLSpacing.md, SLSpacing.xl, SLSpacing.md, SLSpacing.sm,
                  ),
                  child: Text(
                    'ESCOLHA SEU PROFISSIONAL',
                    style: SLTypography.overline.copyWith(
                      color: SLColors.champagne,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: professionalsAsync.when(
                  loading: () => const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator(color: SLColors.champagne)),
                  ),
                  error: (_, __) => const SizedBox(height: 100),
                  data: (professionals) => SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: SLSpacing.md),
                      itemCount: professionals.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: SLSpacing.sm),
                      itemBuilder: (_, i) {
                        final pro = professionals[i];
                        final isSelected = pro.id == _selectedProfessionalId;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedProfessionalId = pro.id);
                            ref.read(bookingServiceProvider.notifier).setProfessional(pro);
                          },
                          child: AnimatedContainer(
                            duration: SLAnimations.normal,
                            width: 90,
                            padding: const EdgeInsets.symmetric(
                                vertical: SLSpacing.md),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? SLColors.champagne
                                  : SLColors.surface,
                              borderRadius: SLRadius.card,
                              border: Border.all(
                                color: isSelected
                                    ? SLColors.champagne
                                    : SLColors.border,
                                width: isSelected ? 1 : 0.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                          color: SLColors.champagne.withValues(alpha: 0.25),
                                          blurRadius: 8)
                                    ]
                                  : null,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? SLColors.champagne.withValues(alpha: 0.2)
                                        : SLColors.cream,
                                    border: Border.all(
                                      color: isSelected
                                          ? SLColors.champagne
                                          : SLColors.border,
                                      width: isSelected ? 2 : 0,
                                    ),
                                  ),
                                  child: Center(
                                    child: pro.avatarUrl != null
                                        ? SLNetworkImage(
                                            url: pro.avatarUrl!,
                                            width: 44,
                                            height: 44,
                                            fit: BoxFit.cover,
                                            borderRadius: BorderRadius.circular(22),
                                          )
                                        : Icon(Icons.person,
                                            color: isSelected
                                                ? SLColors.champagne
                                                : SLColors.textSecondary,
                                            size: 20),
                                  ),
                                ),
                                const SizedBox(height: SLSpacing.xs),
                                Text(
                                  pro.name,
                                  style: SLTypography.caption.copyWith(
                                    color: isSelected
                                        ? SLColors.ivory
                                        : SLColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    SLSpacing.md, SLSpacing.xl, SLSpacing.md, SLSpacing.sm,
                  ),
                  child: Text(
                    'HOR\u00c1RIOS DISPON\u00cdVEIS',
                    style: SLTypography.overline.copyWith(
                      color: SLColors.champagne,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: SLSpacing.md),
                  child: Wrap(
                    spacing: SLSpacing.sm,
                    runSpacing: SLSpacing.sm,
                    children: [
                      '09:00', '09:30', '10:00', '10:30',
                      '11:00', '11:30', '13:00', '13:30',
                      '14:00', '14:30', '15:00', '15:30',
                      '16:00', '16:30', '17:00',
                    ].map((time) {
                      final isSelected = time == _selectedTime;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedTime = time);
                          ref.read(bookingServiceProvider.notifier).setTime(time);
                        },
                        child: AnimatedContainer(
                          duration: SLAnimations.normal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: SLSpacing.lg,
                            vertical: SLSpacing.sm,
                          ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? SLColors.champagne
                                  : SLColors.surface,
                              borderRadius: SLRadius.input,
                              border: Border.all(
                                color: isSelected
                                    ? SLColors.champagne
                                    : SLColors.border,
                                width: isSelected ? 1 : 0.5,
                              ),
                            ),
                            child: Text(
                              time,
                              style: SLTypography.bodySmall.copyWith(
                                color: isSelected
                                    ? SLColors.background
                                    : SLColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      SLSpacing.md, SLSpacing.xl, SLSpacing.md, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OBSERVA\u00c7\u00d5ES',
                        style: SLTypography.overline.copyWith(
                          color: SLColors.champagne,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: SLSpacing.sm),
                      TextField(
                        controller: _notesController,
                        maxLines: 2,
                        onChanged: (value) {
                          ref.read(bookingServiceProvider.notifier).setNotes(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Algo que devemos saber?',
                          filled: true,
                          fillColor: SLColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: SLRadius.input,
                            borderSide: BorderSide(
                                color: SLColors.border, width: 0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: SLRadius.input,
                            borderSide: BorderSide(
                                color: SLColors.border, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: SLRadius.input,
                            borderSide: const BorderSide(
                                color: SLColors.champagne, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      SLSpacing.md, SLSpacing.xxl, SLSpacing.md, SLSpacing.xxxl),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
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
                            color: SLColors.champagne.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: (_selectedProfessionalId != null &&
                                _selectedTime != null)
                            ? () => _handleBooking(services)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: SLColors.textOnDark,
                          disabledBackgroundColor: SLColors.disabled,
                          shape: RoundedRectangleBorder(
                              borderRadius: SLRadius.button),
                        ),
                        child: _isBooking
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(SLColors.textOnDark),
                                ),
                              )
                            : Text(
                                'Confirmar agendamento',
                                style: SLTypography.buttonSmall
                                    .copyWith(letterSpacing: 1),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
