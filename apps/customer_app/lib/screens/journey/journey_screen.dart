import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/supabase_providers.dart';

class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends ConsumerState<JourneyScreen> {
  int _selectedRating = 0;
  bool _isSubmitting = false;

  final _emojis = const ['😞', '😐', '🙂', '😊', '🤩'];

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(completedAppointmentsProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      appBar: AppBar(
        title: Text(
          'Minha Experiência',
          style: SLTypography.h3.copyWith(
            color: SLColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(SLSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SLBeforeAfter(
              beforeImageUrl:
                  'https://images.unsplash.com/photo-1560869713-7d0a29430803?w=400',
              afterImageUrl:
                  'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400',
              beforeLabel: 'ANTES',
              afterLabel: 'DEPOIS',
            ),

            const SizedBox(height: SLSpacing.xxl),

            appointmentsAsync.when(
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(color: SLColors.accentGold)),
              ),
              error: (_, __) => const SizedBox.shrink(),
              data: (appointments) {
                if (appointments.isEmpty) return const SizedBox.shrink();

                final lastAppointment = appointments.first;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: SLSpacing.xs, bottom: SLSpacing.md),
                      child: Row(
                        children: [
                          const Text('📋', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: SLSpacing.sm),
                          Text(
                            'Última experiência',
                            style: SLTypography.h2.copyWith(
                              color: SLColors.textPrimary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SLEmotionalTimeline(stages: [
                      EmotionalStage(
                          title: 'Confirmação',
                          emoji: '✅',
                          isCompleted: true),
                      EmotionalStage(
                          title: 'Inspirações',
                          emoji: '📸',
                          isCompleted: true),
                      EmotionalStage(
                          title: 'Lembrete',
                          emoji: '🔔',
                          isCompleted: true),
                      EmotionalStage(
                          title: 'Recepção',
                          emoji: '👋',
                          isCompleted: true),
                      EmotionalStage(
                          title: 'Diagnóstico',
                          emoji: '🧑‍🏫',
                          isCompleted: true),
                      EmotionalStage(
                          title: 'Procedimento',
                          emoji: '✨',
                          isCompleted: true),
                      EmotionalStage(
                          title: 'Finalização',
                          emoji: '💇‍♀️',
                          isCompleted: true),
                    ]),

                    const SizedBox(height: SLSpacing.xxl),

                    SLCard(
                      variant: SLCardVariant.outlined,
                      padding: const EdgeInsets.all(SLSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: SLColors.bgSecondary,
                            ),
                            child: const Icon(Icons.spa_outlined,
                                color: SLColors.accentGold, size: 20),
                          ),
                          const SizedBox(width: SLSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lastAppointment.service?.name ?? 'Serviço',
                                  style: SLTypography.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: SLColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'com ${lastAppointment.professional?.name ?? 'Profissional'}',
                                  style: SLTypography.caption.copyWith(
                                    color: SLColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'R\$ ${(lastAppointment.service?.price ?? 0).toInt()}',
                            style: SLTypography.bodySmall.copyWith(
                              color: SLColors.accentGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: SLSpacing.xxl),

            Padding(
              padding: const EdgeInsets.only(
                  left: SLSpacing.xs, bottom: SLSpacing.md),
              child: Row(
                children: [
                  const Text('💝', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: SLSpacing.sm),
                  Text(
                    'Depois',
                    style: SLTypography.h2.copyWith(
                      color: SLColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SLCard(
              variant: SLCardVariant.elevated,
              padding: const EdgeInsets.all(SLSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Como foi sua experiência?',
                    style: SLTypography.h3.copyWith(
                      color: SLColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: SLSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _emojis.asMap().entries.map((entry) {
                      final i = entry.key;
                      final emoji = entry.value;
                      final isSelected = _selectedRating == i + 1;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedRating = i + 1),
                        child: AnimatedContainer(
                          duration: SLAnimations.normal,
                          padding: const EdgeInsets.all(SLSpacing.sm),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? SLColors.accentGold.withValues(alpha: 0.12)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? SLColors.accentGold
                                  : Colors.transparent,
                              width: isSelected ? 2 : 0,
                            ),
                          ),
                          child: Text(emoji,
                              style: const TextStyle(fontSize: 28)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: SLSpacing.lg),
                  SLButton(
                    label: 'Registrar avaliação',
                    onPressed: _selectedRating > 0 && !_isSubmitting
                        ? _submitRating
                        : null,
                    variant: SLButtonVariant.primary,
                    isExpanded: true,
                    isLoading: _isSubmitting,
                  ),
                ],
              ),
            ),
            const SizedBox(height: SLSpacing.xxl),
          ],
        ),
      ),
      ),
    );
  }

  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);

    try {
      final appointmentsAsync = ref.read(completedAppointmentsProvider);
      final appointments = appointmentsAsync.valueOrNull ?? [];

      if (appointments.isNotEmpty) {
        final lastAppointment = appointments.first;

        await Supabase.instance.client
            .from('appointments')
            .update({'rating': _selectedRating.toDouble()})
            .eq('id', lastAppointment.id);

        await Supabase.instance.client.from('customer_memories').insert({
          'customer_id': Supabase.instance.client.auth.currentUser!.id,
          'emoji': _emojis[_selectedRating - 1],
          'message': 'Avaliação: ${_emojis[_selectedRating - 1]} (${_selectedRating}/5)',
          'source': 'Auto-avaliação',
          'type': 'rating',
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avaliação registrada! Obrigada! 💛'),
              backgroundColor: SLColors.success,
            ),
          );
          setState(() => _selectedRating = 0);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao registrar: $e'),
            backgroundColor: SLColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}
