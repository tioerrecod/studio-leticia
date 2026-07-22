import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/supabase_providers.dart';

final _serviceDetailProvider = FutureProvider.family<ServiceItem, String>((ref, id) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getServiceById(id);
});

final _serviceMediaProvider = StreamProvider.family<List<ServiceMedia>, String>((ref, serviceId) {
  final repository = ref.watch(serviceMediaRepositoryProvider);
  return repository.watchServiceMedia(serviceId);
});

class ServiceDetailScreen extends ConsumerWidget {
  final String serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(_serviceDetailProvider(serviceId));
    final mediaAsync = ref.watch(_serviceMediaProvider(serviceId));

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: SLColors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SLColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: serviceAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: SLColors.accentGold),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
              const SizedBox(height: SLSpacing.space4),
              Text('Erro ao carregar serviço', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
              const SizedBox(height: SLSpacing.space3),
              TextButton(
                onPressed: () => ref.invalidate(_serviceDetailProvider(serviceId)),
                child: Text('Tentar novamente', style: SLTypography.button.copyWith(color: SLColors.accentGold)),
              ),
            ],
          ),
        ),
        data: (service) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Gallery ────────────────────────────────
            mediaAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator(color: SLColors.accentGold)),
                ),
              ),
              error: (_, __) => _HeroImage(service: service),
              data: (media) {
                if (media.isEmpty) return _HeroImage(service: service);
                return _MediaGallery(media: media);
              },
            ),

            // ── Service Info ────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(SLSpacing.space6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: SLTypography.h2.copyWith(color: SLColors.textPrimary),
                          ),
                        ),
                        if (service.isSignature)
                          Padding(
                            padding: const EdgeInsets.only(left: SLSpacing.space2, top: 4),
                            child:                             SLBadge(
                              label: 'EXCLUSIVO',
                              variant: SLBadgeVariant.gold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: SLSpacing.space3),

                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: SLColors.accentGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service.category,
                        style: SLTypography.caption.copyWith(color: SLColors.accentGold, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: SLSpacing.space5),

                    // Description
                    Text(
                      service.description,
                      style: SLTypography.body.copyWith(color: SLColors.textSecondary, height: 1.6),
                    ),
                    const SizedBox(height: SLSpacing.space6),

                    // Info row
                    Row(
                      children: [
                        _InfoChip(icon: Icons.timer_outlined, label: service.duration),
                        const SizedBox(width: SLSpacing.space3),
                        _InfoChip(icon: Icons.monetization_on_outlined, label: service.formattedPrice),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom padding ───────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space24)),
          ],
        ),
      ),
      bottomNavigationBar: serviceAsync.when(
        data: (service) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              SLSpacing.space6,
              SLSpacing.space3,
              SLSpacing.space6,
              SLSpacing.space4,
            ),
            child: SLButton(
              label: 'Agendar ${service.formattedPrice}',
              variant: SLButtonVariant.primary,
              onPressed: () {
                final authService = ref.read(authServiceProvider);
                if (!authService.isAuthenticated) {
                  context.go('/auth-choice');
                } else {
                  context.go('/services/book?service=${service.id}');
                }
              },
            ),
          ),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final ServiceItem service;
  const _HeroImage({required this.service});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 280,
        width: double.infinity,
        color: SLColors.bgSecondary,
        child: service.imageUrl != null && service.imageUrl!.isNotEmpty
            ? Image.network(service.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder)
            : _placeholder,
      ),
    );
  }

  Widget get _placeholder => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, size: 48, color: SLColors.textDisabled),
        const SizedBox(height: SLSpacing.space2),
        Text(service.name, style: SLTypography.caption.copyWith(color: SLColors.textDisabled)),
      ],
    ),
  );
}

class _MediaGallery extends StatelessWidget {
  final List<ServiceMedia> media;
  const _MediaGallery({required this.media});

  @override
  Widget build(BuildContext context) {
    final cover = media.where((m) => m.isCover).firstOrNull ?? media.first;
    final others = media.where((m) => m.id != cover.id).toList();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 320,
        child: Column(
          children: [
            // Cover image
            Expanded(
              flex: 3,
              child: _MediaItem(media: cover),
            ),
            // Thumbnails row
            if (others.isNotEmpty)
              Expanded(
                flex: 1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
                  itemCount: others.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      width: 100,
                      child: _MediaItem(media: others[i]),
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

class _MediaItem extends StatelessWidget {
  final ServiceMedia media;
  const _MediaItem({required this.media});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(media.url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: SLColors.bgSecondary)),
          if (media.isVideo)
            const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40)),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: SLColors.bgSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: SLColors.accentGold),
          const SizedBox(width: SLSpacing.space1),
          Text(label, style: SLTypography.caption.copyWith(color: SLColors.textPrimary)),
        ],
      ),
    );
  }
}
