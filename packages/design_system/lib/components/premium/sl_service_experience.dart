import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';
import '../utils/sl_network_image.dart';

class SLServiceExperience extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String tagline;
  final String resultDescription;
  final String duration;
  final String price;
  final bool isSignature;
  final VoidCallback? onSelect;

  const SLServiceExperience({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.tagline,
    required this.resultDescription,
    required this.duration,
    required this.price,
    this.isSignature = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: SLSpacing.md,
          vertical: SLSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: SLColors.surface,
          borderRadius: SLRadius.card,
          border: Border.all(color: SLColors.border, width: 0.5),
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
            // Image
            if (imageUrl.isNotEmpty)
              SizedBox(
                height: 160,
                width: double.infinity,
                child: SLNetworkImage(
                  url: imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(SLSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: SLTypography.h3.copyWith(
                                color: SLColors.carbon,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tagline,
                              style: SLTypography.caption.copyWith(
                                color: isSignature
                                    ? SLColors.champagne
                                    : SLColors.textSecondary,
                                fontWeight: isSignature
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSignature)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SLSpacing.sm,
                            vertical: SLSpacing.mini,
                          ),
                          decoration: BoxDecoration(
                            color: SLColors.champagne.withValues(alpha: 0.1),
                            borderRadius: SLRadius.chip,
                          ),
                          child: Text(
                            'EXCLUSIVO',
                            style: SLTypography.overline.copyWith(
                              color: SLColors.champagne,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: SLSpacing.sm),
                  Text(
                    resultDescription,
                    style: SLTypography.bodySmall.copyWith(
                      color: SLColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: SLSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 14, color: SLColors.textSecondary),
                          const SizedBox(width: SLSpacing.mini),
                          Text(
                            duration,
                            style: SLTypography.caption.copyWith(
                              color: SLColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        price,
                        style: SLTypography.h3.copyWith(
                          color: SLColors.champagne,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
