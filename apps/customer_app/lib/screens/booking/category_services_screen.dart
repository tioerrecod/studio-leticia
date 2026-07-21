import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/supabase_providers.dart';

final _categoryServicesProvider = FutureProvider.family<List<ServiceItem>, String>((ref, category) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getServicesByCategory(category);
});

class CategoryServicesScreen extends ConsumerWidget {
  final String categoryName;

  const CategoryServicesScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(_categoryServicesProvider(categoryName));

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: SLColors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SLColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          categoryName,
          style: SLTypography.h3.copyWith(color: SLColors.textPrimary, fontWeight: FontWeight.w400),
        ),
      ),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: SLColors.accentGold)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
              const SizedBox(height: SLSpacing.space4),
              Text('Erro ao carregar serviços', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
              const SizedBox(height: SLSpacing.space3),
              TextButton(
                onPressed: () => ref.invalidate(_categoryServicesProvider(categoryName)),
                child: Text('Tentar novamente', style: SLTypography.button.copyWith(color: SLColors.accentGold)),
              ),
            ],
          ),
        ),
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: SLColors.textDisabled),
                  const SizedBox(height: SLSpacing.space4),
                  Text('Nenhum serviço encontrado', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(SLSpacing.space4),
            itemCount: services.length,
            itemBuilder: (_, i) {
              final service = services[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: SLSpacing.space3),
                child: SLServiceExperience(
                  imageUrl: service.imageUrl ?? '',
                  title: service.name,
                  tagline: service.isSignature ? 'Experiência exclusiva' : categoryName,
                  resultDescription: service.description,
                  duration: service.duration,
                  price: service.formattedPrice,
                  isSignature: service.isSignature,
                  onSelect: () => context.go('/services/detail/${service.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
