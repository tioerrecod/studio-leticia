import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import '../../providers/providers.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Experi\u00eancias',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: SLSpacing.sm, bottom: SLSpacing.xxl),
        itemCount: services.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                SLSpacing.xl, SLSpacing.sm, SLSpacing.xl, SLSpacing.lg,
              ),
              child: Text(
                'Descubra o cuidado perfeito para voc\u00ea',
                style: SLTypography.body.copyWith(
                  color: SLColors.textSecondary,
                  height: 1.6,
                ),
              ),
            );
          }
          final service = services[i - 1];
          return SLServiceExperience(
            imageUrl: service.imageUrl ?? '',
            title: service.name,
            tagline: service.isSignature
                ? 'Experi\u00eancia exclusiva'
                : service.category,
            resultDescription: service.description,
            duration: service.duration,
            price: service.formattedPrice,
            isSignature: service.isSignature,
            onSelect: () =>
                context.go('/services/book?service=${service.id}'),
          );
        },
      ),
    );
  }
}
