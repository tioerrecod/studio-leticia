import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';

class EmotionalStage {
  final String title;
  final String emoji;
  final bool isCompleted;
  final bool isActive;
  final String? description;

  const EmotionalStage({
    required this.title,
    required this.emoji,
    this.isCompleted = false,
    this.isActive = false,
    this.description,
  });
}

class SLEmotionalTimeline extends StatelessWidget {
  final List<EmotionalStage> stages;

  const SLEmotionalTimeline({
    super.key,
    required this.stages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: stages.asMap().entries.map((entry) {
        final index = entry.key;
        final stage = entry.value;
        final isLast = index == stages.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: stage.isCompleted
                        ? SLColors.accentGold
                        : stage.isActive
                            ? SLColors.accentGold.withValues(alpha: 0.2)
                            : SLColors.surface,
                    border: Border.all(
                      color: stage.isCompleted
                          ? SLColors.accentGold
                          : stage.isActive
                              ? SLColors.accentGold
                              : SLColors.border,
                      width: stage.isActive ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      stage.emoji,
                      style: TextStyle(
                        fontSize: stage.isCompleted ? 14 : 12,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 1,
                    height: 32,
                    color: SLColors.border,
                  ),
              ],
            ),
            const SizedBox(width: SLSpacing.sm),
            // Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  bottom: SLSpacing.md,
                  top: SLSpacing.mini,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage.title,
                      style: SLTypography.body.copyWith(
                        fontWeight: stage.isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: SLColors.textPrimary,
                      ),
                    ),
                    if (stage.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        stage.description!,
                        style: SLTypography.caption.copyWith(
                          color: SLColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
