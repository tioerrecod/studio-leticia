import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/shadows.dart';
import '../utils/sl_network_image.dart';

class SLAppointmentHeroCard extends StatelessWidget {
  final String serviceName;
  final String dateLabel;
  final String statusLabel;
  final String? imageUrl;
  final Color statusColor;
  final VoidCallback? onTap;
  final VoidCallback? onDetailsTap;

  const SLAppointmentHeroCard({
    super.key,
    required this.serviceName,
    required this.dateLabel,
    required this.statusLabel,
    this.imageUrl,
    this.statusColor = SLColors.stateSuccess,
    this.onTap,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: SLColors.surface,
          borderRadius: SLRadius.card,
          boxShadow: SLShadows.elevation2,
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 65,
                child: Padding(
                  padding: const EdgeInsets.all(SLSpacing.space6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateLabel,
                        style: SLTypography.label.copyWith(
                          color: SLColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: SLSpacing.space2),
                      Text(
                        serviceName,
                        style: SLTypography.h2,
                      ),
                      const SizedBox(height: SLSpacing.space3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SLSpacing.space3,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: SLRadius.lg,
                        ),
                        child: Text(
                          statusLabel,
                          style: SLTypography.overline.copyWith(
                            color: statusColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (onDetailsTap != null)
                        GestureDetector(
                          onTap: onDetailsTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SLSpacing.space4,
                              vertical: SLSpacing.space2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: SLRadius.button,
                              border: Border.all(
                                color: SLColors.accentGold,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'VER DETALHES',
                              style: SLTypography.buttonSmall.copyWith(
                                color: SLColors.accentGold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 35,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: SLRadius.card.topRight,
                    bottomRight: SLRadius.card.bottomRight,
                  ),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? SLNetworkImage(
                          url: imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: SLColors.border,
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: SLColors.textDisabled,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
