import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/animations.dart';

class SLStepper extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final List<String> labels;

  const SLStepper({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.labels = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space6),
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            final isCompleted = stepIndex < currentStep;
            return Expanded(
              child: Container(
                height: 1,
                color: isCompleted
                    ? SLColors.stateSuccess
                    : SLColors.border,
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isCompleted = stepIndex < currentStep;
          final isActive = stepIndex == currentStep;
          return AnimatedContainer(
            duration: SLAnimations.medium,
            width: isActive ? 10 : 8,
            height: isActive ? 10 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? SLColors.stateSuccess
                  : isActive
                      ? SLColors.accentGold
                      : SLColors.border,
            ),
          );
        }),
      ),
    );
  }
}
