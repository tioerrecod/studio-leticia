import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';

class SLNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData fallbackIcon;

  const SLNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackIcon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _buildFallback();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: SLColors.surface,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  SLColors.champagne,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: SLColors.surface,
      child: Center(
        child: Icon(
          fallbackIcon,
          color: SLColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}
