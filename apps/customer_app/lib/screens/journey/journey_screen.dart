import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  int _selectedRating = 0;

  final _beforeStages = const [
    EmotionalStage(
        title: 'Confirma\u00e7\u00e3o',
        emoji: '\u2705',
        isCompleted: true),
    EmotionalStage(
        title: 'Inspira\u00e7\u00f5es',
        emoji: '\u{1F4F7}',
        isCompleted: true),
    EmotionalStage(
        title: 'Lembrete', emoji: '\u{1F514}', isActive: true),
  ];

  final _duringStages = const [
    EmotionalStage(
        title: 'Recep\u00e7\u00e3o',
        emoji: '\u{1F44B}',
        isCompleted: true,
        description: 'Chegada e boas-vindas'),
    EmotionalStage(
        title: 'Diagn\u00f3stico',
        emoji: '\u{1F9D1}\u200D\u{1F3EB}',
        isCompleted: true,
        description: 'An\u00e1lise capilar'),
    EmotionalStage(
        title: 'Procedimento',
        emoji: '\u2728',
        isActive: true,
        description: 'Hidrata\u00e7\u00e3o Premium'),
    EmotionalStage(
        title: 'Finaliza\u00e7\u00e3o',
        emoji: '\u{1F487}\u200D\u2640\uFE0F',
        description: 'Finaliza\u00e7\u00e3o e styling'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Minha Experi\u00eancia',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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

            Padding(
              padding: const EdgeInsets.only(
                  left: SLSpacing.xs, bottom: SLSpacing.md),
              child: Row(
                children: [
                  Text('\u{1F4CB}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: SLSpacing.sm),
                  Text(
                    'Antes',
                    style: SLTypography.h2.copyWith(
                      color: SLColors.carbon,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SLEmotionalTimeline(stages: _beforeStages),

            const SizedBox(height: SLSpacing.xxl),

            Padding(
              padding: const EdgeInsets.only(
                  left: SLSpacing.xs, bottom: SLSpacing.md),
              child: Row(
                children: [
                  Text('\u2728',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: SLSpacing.sm),
                  Text(
                    'Durante',
                    style: SLTypography.h2.copyWith(
                      color: SLColors.carbon,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SLEmotionalTimeline(stages: _duringStages),

            const SizedBox(height: SLSpacing.xxl),

            Padding(
              padding: const EdgeInsets.only(
                  left: SLSpacing.xs, bottom: SLSpacing.md),
              child: Row(
                children: [
                  Text('\u{1F49D}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: SLSpacing.sm),
                  Text(
                    'Depois',
                    style: SLTypography.h2.copyWith(
                      color: SLColors.carbon,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(SLSpacing.lg),
              decoration: BoxDecoration(
                color: SLColors.surface,
                borderRadius: SLRadius.card,
                border:
                    Border.all(color: SLColors.border, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: SLColors.carbon.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Como foi sua experi\u00eancia?',
                    style: SLTypography.h3.copyWith(
                      color: SLColors.carbon,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: SLSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      '\u{1F61E}', '\u{1F610}', '\u{1F642}',
                      '\u{1F60A}', '\u{1F929}'
                    ].asMap().entries.map((entry) {
                      final i = entry.key;
                      final emoji = entry.value;
                      final isSelected = _selectedRating == i + 1;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedRating = i + 1),
                        child: AnimatedContainer(
                          duration: SLAnimations.normal,
                          padding:
                              const EdgeInsets.all(SLSpacing.sm),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? SLColors.champagne.withValues(alpha: 0.12)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? SLColors.champagne
                                  : Colors.transparent,
                              width: isSelected ? 2 : 0,
                            ),
                          ),
                          child: Text(emoji,
                              style:
                                  const TextStyle(fontSize: 28)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: SLSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: SLRadius.button,
                        gradient: const LinearGradient(
                          colors: [SLColors.champagne, SLColors.gold],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed:
                            _selectedRating > 0 ? () {} : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: SLColors.textOnDark,
                          disabledBackgroundColor: SLColors.disabled,
                          shape: RoundedRectangleBorder(
                              borderRadius: SLRadius.button),
                        ),
                        child:
                            const Text('Registrar avalia\u00e7\u00e3o'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SLSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
