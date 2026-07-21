import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../utils/sl_network_image.dart';
import 'sl_button.dart';

class SLHeroImage extends StatelessWidget {
  final String imageUrl;
  final String tagline;
  final String heading;
  final String? subtitle;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final double height;

  const SLHeroImage({
    super.key,
    required this.imageUrl,
    required this.tagline,
    required this.heading,
    this.subtitle,
    this.ctaLabel,
    this.onCta,
    this.height = 520,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: SLNetworkImage(
              url: imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    SLColors.bgPrimary.withValues(alpha: 0.3),
                    SLColors.bgPrimary.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: SLSpacing.space8,
            right: SLSpacing.space8,
            bottom: SLSpacing.space12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tagline.toUpperCase(),
                  style: SLTypography.overline.copyWith(
                    color: SLColors.accentGold,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SLSpacing.space3),
                Text(
                  heading,
                  style: SLTypography.display.copyWith(
                    color: SLColors.textOnDark,
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    height: 1.15,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: SLSpacing.space3),
                  Text(
                    subtitle!,
                    style: SLTypography.bodyLarge.copyWith(
                      color: SLColors.textOnDark.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
                if (ctaLabel != null && onCta != null) ...[
                  const SizedBox(height: SLSpacing.space8),
                  _buildCtaButton(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCtaButton() {
    return SLButton(
      label: ctaLabel!,
      onPressed: onCta,
      isExpanded: false,
      icon: Icons.arrow_forward,
    );
  }
}
