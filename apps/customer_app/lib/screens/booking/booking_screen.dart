import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import '../../providers/providers.dart';



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

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider);
    final professionals = ref.watch(professionalsProvider);
    final bookingState = ref.watch(bookingServiceProvider);

    final service = widget.serviceId != null
        ? services.firstWhere(
            (s) => s.id == widget.serviceId,
            orElse: () => services.isNotEmpty ? services.first : ServiceItem.empty(),
          )
        : services.isNotEmpty ? services.first : ServiceItem.empty();

    // Update booking state with selected service
    if (service.id.isNotEmpty && bookingState.service?.id != service.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bookingServiceProvider.notifier).setService(service);
      });
    }

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
      body: CustomScrollView(
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
            child: SizedBox(
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
                            ? SLColors.carbon
                            : SLColors.surface,
                        borderRadius: SLRadius.card,
                        border: Border.all(
                          color: isSelected
                              ? SLColors.carbon
                              : SLColors.border,
                          width: isSelected ? 1 : 0.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: SLColors.carbon.withValues(alpha: 0.1),
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
                            ? SLColors.carbon
                            : SLColors.surface,
                        borderRadius: SLRadius.input,
                        border: Border.all(
                          color: isSelected
                              ? SLColors.carbon
                              : SLColors.border,
                          width: isSelected ? 1 : 0.5,
                        ),
                      ),
                      child: Text(
                        time,
                        style: SLTypography.bodySmall.copyWith(
                          color: isSelected
                              ? SLColors.ivory
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
                SLSpacing.md, SLSpacing.xxl, SLSpacing.md, SLSpacing.xxxl,
              ),
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
                        ? () => context.go('/services/confirm')
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: SLColors.textOnDark,
                      disabledBackgroundColor: SLColors.disabled,
                      shape: RoundedRectangleBorder(
                          borderRadius: SLRadius.button),
                    ),
                    child: Text(
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
      ),
    );
  }
}
