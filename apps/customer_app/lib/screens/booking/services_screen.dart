import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import '../../providers/supabase_providers.dart';

final _groupedServicesProvider = FutureProvider<Map<String, List<dynamic>>>((ref) async {
  final services = await ref.watch(servicesFromSupabaseProvider.future);
  final grouped = <String, List<dynamic>>{};
  for (final s in services) {
    grouped.putIfAbsent(s.category, () => []).add(s);
  }
  return grouped;
});

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(_groupedServicesProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      appBar: AppBar(
        title: Text(
          'Experi\u00eancias',
          style: SLTypography.h3.copyWith(
            color: SLColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: groupedAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: SLColors.accentGold),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
                const SizedBox(height: SLSpacing.md),
                Text('Erro ao carregar servi\u00e7os', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
                const SizedBox(height: SLSpacing.sm),
                TextButton(
                  onPressed: () => ref.invalidate(_groupedServicesProvider),
                  child: Text('Tentar novamente', style: SLTypography.button.copyWith(color: SLColors.accentGold)),
                ),
              ],
            ),
          ),
          data: (grouped) {
            final categories = grouped.keys.toList();
            return ListView.builder(
              padding: const EdgeInsets.only(top: SLSpacing.sm, bottom: SLSpacing.xxl),
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final category = categories[i];
                final services = grouped[category]!;
                return _CategorySection(
                  category: category,
                  services: services,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List services;

  const _CategorySection({required this.category, required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(SLSpacing.xl, SLSpacing.lg, SLSpacing.xl, SLSpacing.sm),
          child: Text(
            category,
            style: SLTypography.h3.copyWith(color: SLColors.textPrimary),
          ),
        ),
        ...services.map((service) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: SLSpacing.sm),
          child: SLServiceExperience(
            imageUrl: service.imageUrl ?? '',
            title: service.name,
            tagline: service.isSignature ? 'Experi\u00eancia exclusiva' : category,
            resultDescription: service.description,
            duration: service.duration,
            price: service.formattedPrice,
            isSignature: service.isSignature,
            onSelect: () => context.go('/services/detail/${service.id}'),
          ),
        )),
      ],
    );
  }
}
