import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../utils/sl_network_image.dart';
import 'sl_card.dart';

class SLCategoryCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final VoidCallback? onTap;

  const SLCategoryCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SLCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 70,
              child: Padding(
                padding: const EdgeInsets.all(SLSpacing.space6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: SLTypography.h3,
                    ),
                    const SizedBox(height: SLSpacing.space1),
                    Text(
                      description,
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: SLColors.accentGold,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: SLRadius.card.topRight,
                  bottomRight: SLRadius.card.bottomRight,
                ),
                child: imageUrl.isNotEmpty
                    ? SLNetworkImage(
                        url: imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: SLColors.border,
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 32,
                            color: SLColors.textDisabled,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
