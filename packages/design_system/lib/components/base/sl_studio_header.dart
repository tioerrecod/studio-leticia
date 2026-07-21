import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';

class SLStudioHeader extends StatelessWidget {
  final int? notificationCount;
  final VoidCallback? onNotificationTap;

  const SLStudioHeader({
    super.key,
    this.notificationCount,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SLSpacing.space6,
        right: SLSpacing.space6,
        top: SLSpacing.space12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Studio Letícia',
                  style: SLTypography.display.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'EXPERIENCE',
                  style: SLTypography.label.copyWith(
                    color: SLColors.accentGold,
                    letterSpacing: 8,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: onNotificationTap,
                icon: Icon(
                  Icons.notifications_outlined,
                  size: 22,
                  color: SLColors.textSecondary,
                ),
              ),
              if (notificationCount != null && notificationCount! > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: SLColors.accentGold,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
