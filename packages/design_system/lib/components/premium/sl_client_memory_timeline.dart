import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';

class SLMemoryEntry {
  final String emoji;
  final String message;
  final String date;
  final String context;
  final bool isActive;

  const SLMemoryEntry({
    required this.emoji,
    required this.message,
    required this.date,
    required this.context,
    this.isActive = true,
  });
}

class SLClientMemoryTimeline extends StatelessWidget {
  final String title;
  final List<SLMemoryEntry> memories;

  const SLClientMemoryTimeline({
    super.key,
    required this.title,
    required this.memories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SLSpacing.md + SLSpacing.xs,
          ),
          child: Row(
            children: [
              const Icon(Icons.psychology_outlined,
                  size: 18, color: SLColors.champagne),
              const SizedBox(width: SLSpacing.sm),
              Text(
                title,
                style: SLTypography.h2.copyWith(
                  color: SLColors.carbon,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SLSpacing.md),
        ...memories.map((memory) => _MemoryItem(memory: memory)),
      ],
    );
  }
}

class _MemoryItem extends StatelessWidget {
  final SLMemoryEntry memory;

  const _MemoryItem({required this.memory});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: SLSpacing.md,
        vertical: SLSpacing.xs,
      ),
      padding: const EdgeInsets.all(SLSpacing.md),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(memory.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: SLSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory.message,
                  style: SLTypography.body.copyWith(
                    color: SLColors.carbon,
                  ),
                ),
                const SizedBox(height: SLSpacing.mini),
                Row(
                  children: [
                    Text(
                      memory.context,
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: SLSpacing.sm),
                    Text(
                      memory.date,
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
