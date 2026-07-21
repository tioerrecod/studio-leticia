import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import '../../providers/providers.dart';

class ConfirmationScreen extends ConsumerWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingServiceProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SLSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),

              SLSuccessAnimation(
                title: 'Experi\u00eancia confirmada!',
                subtitle:
                    'Preparamos tudo com cuidado para receber voc\u00ea.',
                onComplete: () {},
              ),

              const SizedBox(height: SLSpacing.xxl),

              Container(
                padding: const EdgeInsets.all(SLSpacing.xl),
                decoration: BoxDecoration(
                  color: SLColors.surface,
                  borderRadius: SLRadius.card,
                  border:
                      Border.all(color: SLColors.border, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: SLColors.textPrimary.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _ConfirmationRow(
                        icon: Icons.event_outlined,
                        label: 'DATA',
                        value: _formatDate(_getNextBusinessDay())),
                    const SizedBox(height: SLSpacing.md),
                    Divider(color: SLColors.divider, height: 1),
                    const SizedBox(height: SLSpacing.md),
                    _ConfirmationRow(
                        icon: Icons.schedule_outlined,
                        label: 'HOR\u00c1RIO',
                        value: bookingState.time ?? '14:00'),
                    const SizedBox(height: SLSpacing.md),
                    Divider(color: SLColors.divider, height: 1),
                    const SizedBox(height: SLSpacing.md),
                    _ConfirmationRow(
                        icon: Icons.spa_outlined,
                        label: 'SERVI\u00c7O',
                        value: bookingState.service?.name ?? 'Serviço'),
                    const SizedBox(height: SLSpacing.md),
                    Divider(color: SLColors.divider, height: 1),
                    const SizedBox(height: SLSpacing.md),
                    _ConfirmationRow(
                        icon: Icons.person_outline,
                        label: 'PROFISSIONAL',
                        value: bookingState.professional?.name ?? 'Profissional'),
                    const SizedBox(height: SLSpacing.md),
                    Divider(color: SLColors.divider, height: 1),
                    const SizedBox(height: SLSpacing.md),
                    _ConfirmationRow(
                        icon: Icons.star_outline,
                        label: 'PONTOS',
                        value: '+${(bookingState.service?.price ?? 0).toInt()} pts'),
                  ],
                ),
              ),

              const SizedBox(height: SLSpacing.lg),

              Container(
                padding: const EdgeInsets.all(SLSpacing.md),
                decoration: BoxDecoration(
                  color: SLColors.bgSecondary,
                  borderRadius: SLRadius.input,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 16, color: SLColors.stateSuccess),
                    const SizedBox(width: SLSpacing.sm),
                    Expanded(
                      child: Text(
                        'Enviaremos um lembrete 24h antes pelo WhatsApp',
                        style: SLTypography.caption
                            .copyWith(color: SLColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: SLRadius.button,
                    gradient: const LinearGradient(
                      colors: [SLColors.accentGold, SLColors.accentGoldLight],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: SLColors.accentGold.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(bookingServiceProvider.notifier).clear();
                      context.go('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: SLColors.textOnDark,
                      shape: RoundedRectangleBorder(
                          borderRadius: SLRadius.button),
                    ),
                    child: Text(
                      'Voltar ao in\u00edcio',
                      style: SLTypography.buttonSmall
                          .copyWith(letterSpacing: 1),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: SLSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  DateTime _getNextBusinessDay() {
    var date = DateTime.now();
    while (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  String _formatDate(DateTime date) {
    final months = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
    ];
    return '${date.day} de ${months[date.month - 1]}, ${date.year}';
  }
}

class _ConfirmationRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ConfirmationRow(
      {required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: SLColors.accentGold),
        const SizedBox(width: SLSpacing.sm),
        Text(
          label,
          style: SLTypography.overline.copyWith(
              color: SLColors.textSecondary, letterSpacing: 1.5),
        ),
        const Spacer(),
        Text(
          value,
          style: SLTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600, color: SLColors.textPrimary),
        ),
      ],
    );
  }
}
