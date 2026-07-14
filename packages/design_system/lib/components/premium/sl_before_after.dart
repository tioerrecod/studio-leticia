import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';
import '../utils/sl_network_image.dart';

class SLBeforeAfter extends StatelessWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final String beforeLabel;
  final String afterLabel;

  const SLBeforeAfter({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.beforeLabel = 'ANTES',
    this.afterLabel = 'DEPOIS',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          // Before image
          Stack(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: SLNetworkImage(
                  url: beforeImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
              ),
              Positioned(
                top: SLSpacing.sm,
                left: SLSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SLSpacing.sm,
                    vertical: SLSpacing.mini,
                  ),
                  decoration: BoxDecoration(
                    color: SLColors.carbon.withValues(alpha: 0.7),
                    borderRadius: SLRadius.chip,
                  ),
                  child: Text(
                    beforeLabel,
                    style: SLTypography.overline.copyWith(
                      color: SLColors.ivory,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Divider
          Container(
            height: 1,
            color: SLColors.border,
          ),
          // After image
          Stack(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: SLNetworkImage(
                  url: afterImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
              ),
              Positioned(
                top: SLSpacing.sm,
                right: SLSpacing.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SLSpacing.sm,
                    vertical: SLSpacing.mini,
                  ),
                  decoration: BoxDecoration(
                    color: SLColors.champagne.withValues(alpha: 0.9),
                    borderRadius: SLRadius.chip,
                  ),
                  child: Text(
                    afterLabel,
                    style: SLTypography.overline.copyWith(
                      color: SLColors.ivory,
                      letterSpacing: 1.5,
                    ),
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
