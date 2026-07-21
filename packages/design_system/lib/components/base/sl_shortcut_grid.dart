import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/shadows.dart';

class ShortcutItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const ShortcutItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class SLShortcutGrid extends StatelessWidget {
  final List<ShortcutItem> items;

  const SLShortcutGrid({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: isLast ? 0 : SLSpacing.space3,
            ),
            child: GestureDetector(
              onTap: item.onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: SLSpacing.space4,
                ),
                decoration: BoxDecoration(
                  color: SLColors.surface,
                  borderRadius: SLRadius.card,
                  boxShadow: SLShadows.elevation1,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 24,
                      color: SLColors.textPrimary,
                    ),
                    const SizedBox(height: SLSpacing.space2),
                    Text(
                      item.label,
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
