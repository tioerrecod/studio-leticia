import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/providers.dart';

final _serviceMediaListProvider = FutureProvider.family<List<ServiceMedia>, String>((ref, serviceId) async {
  final repository = ref.watch(serviceMediaRepositoryProvider);
  return repository.getServiceMedia(serviceId);
});

final _allServicesProvider = FutureProvider<List<ServiceItem>>((ref) async {
  final repository = ref.watch(serviceRepositoryProvider);
  return repository.getServices();
});

final _currentUserProvider = Provider<AppUser?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.currentUser;
});

class ServiceMediaScreen extends ConsumerWidget {
  const ServiceMediaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(_allServicesProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      appBar: AppBar(
        title: Text('Mídia dos Serviços', style: SLTypography.h3.copyWith(color: SLColors.textPrimary, fontWeight: FontWeight.w400)),
        backgroundColor: SLColors.bgPrimary,
        elevation: 0,
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
                onPressed: () => ref.invalidate(_allServicesProvider),
                child: Text('Tentar novamente', style: SLTypography.button.copyWith(color: SLColors.accentGold)),
              ),
            ],
          ),
        ),
        data: (services) => ListView.builder(
          padding: const EdgeInsets.all(SLSpacing.space4),
          itemCount: services.length,
          itemBuilder: (_, i) {
            final service = services[i];
            return _ServiceMediaTile(
              service: service,
              onTap: () => _ServiceMediaDetailSheet.show(context, ref, service),
            );
          },
        ),
      ),
    );
  }
}

class _ServiceMediaTile extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onTap;

  const _ServiceMediaTile({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SLSpacing.space3),
      child: SLCard(
        variant: SLCardVariant.outlined,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(SLSpacing.space4),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: SLColors.bgSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(Icons.image_outlined, size: 24, color: SLColors.textDisabled),
                ),
              ),
              const SizedBox(width: SLSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name, style: SLTypography.body.copyWith(color: SLColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(service.category, style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: SLColors.textDisabled),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceMediaDetailSheet extends ConsumerWidget {
  final ServiceItem service;

  const _ServiceMediaDetailSheet({required this.service});

  static void show(BuildContext context, WidgetRef ref, ServiceItem service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SLColors.bgPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ServiceMediaDetailSheet(service: service),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(_serviceMediaListProvider(service.id));

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => _ServiceMediaContent(
        service: service,
        scrollController: scrollController,
        mediaAsync: mediaAsync,
        ref: ref,
      ),
    );
  }
}

class _ServiceMediaContent extends StatefulWidget {
  final ServiceItem service;
  final ScrollController scrollController;
  final AsyncValue<List<ServiceMedia>> mediaAsync;
  final WidgetRef ref;

  const _ServiceMediaContent({
    required this.service,
    required this.scrollController,
    required this.mediaAsync,
    required this.ref,
  });

  @override
  _ServiceMediaContentState createState() => _ServiceMediaContentState();
}

class _ServiceMediaContentState extends State<_ServiceMediaContent> {
  final _captionController = TextEditingController();
  bool _isUploading = false;
  double _uploadProgress = 0;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  String? get _tenantId {
    final user = widget.ref.read(_currentUserProvider);
    return user?.tenantId ?? '00000000-0000-0000-0000-000000000001';
  }

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final filePath = file.path;
    if (filePath == null) return;

        final isVideo = ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains((file.extension ?? '').toLowerCase());
        final contentType = isVideo ? 'video/${file.extension ?? 'mp4'}' : 'image/${file.extension ?? 'jpeg'}';

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    try {
      final repository = widget.ref.read(serviceMediaRepositoryProvider);

      if (filePath.startsWith('http://') || filePath.startsWith('https://')) {
        // URL was pasted — add directly
        await repository.addServiceMedia(
          ServiceMedia(
            id: '',
            tenantId: _tenantId!,
            serviceId: widget.service.id,
            url: filePath,
            type: isVideo ? 'video' : 'image',
            caption: _captionController.text.trim().isEmpty ? null : _captionController.text.trim(),
            isCover: false,
            sortOrder: 0,
            createdAt: DateTime.now(),
          ),
        );
      } else {
        // File picked from device — upload to Supabase Storage
        final fileName = '${widget.service.id}/${DateTime.now().millisecondsSinceEpoch}.${file.extension ?? 'jpg'}';

        final storage = Supabase.instance.client.storage;
        await storage.from('service-media').uploadBinary(
          fileName,
          file.bytes!,
          fileOptions: FileOptions(contentType: contentType),
        );

        final url = storage.from('service-media').getPublicUrl(fileName);

        await repository.addServiceMedia(
          ServiceMedia(
            id: '',
            tenantId: _tenantId!,
            serviceId: widget.service.id,
            url: url,
            type: isVideo ? 'video' : 'image',
            caption: _captionController.text.trim().isEmpty ? null : _captionController.text.trim(),
            isCover: false,
            sortOrder: 0,
            createdAt: DateTime.now(),
          ),
        );
      }

      _captionController.clear();
      widget.ref.invalidate(_serviceMediaListProvider(widget.service.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer upload: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() {
        _isUploading = false;
        _uploadProgress = 0;
      });
    }
  }

  void _setAsCover(String mediaId) {
    widget.ref.read(serviceMediaRepositoryProvider).setCover(mediaId, widget.service.id);
    widget.ref.invalidate(_serviceMediaListProvider(widget.service.id));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Capa definida!'), backgroundColor: SLColors.accentGold, behavior: SnackBarBehavior.floating),
      );
    }
  }

  void _confirmDelete(String mediaId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover mídia'),
        content: const Text('Tem certeza que deseja remover esta mídia?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.ref.read(serviceMediaRepositoryProvider).deleteServiceMedia(mediaId);
              widget.ref.invalidate(_serviceMediaListProvider(widget.service.id));
            },
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _reorder(int oldIndex, int newIndex, List<ServiceMedia> media) async {
    final item = media.removeAt(oldIndex);
    media.insert(newIndex, item);

    final repository = widget.ref.read(serviceMediaRepositoryProvider);
    for (var i = 0; i < media.length; i++) {
      if (media[i].sortOrder != i) {
        await repository.updateServiceMedia(media[i].id, {'sort_order': i});
      }
    }
    widget.ref.invalidate(_serviceMediaListProvider(widget.service.id));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SLSpacing.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: SLColors.textDisabled,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: SLSpacing.space6),

          Text(widget.service.name, style: SLTypography.h3.copyWith(color: SLColors.textPrimary)),
          const SizedBox(height: SLSpacing.space2),
          Text(widget.service.category, style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
          const SizedBox(height: SLSpacing.space6),

          // Upload button + caption
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: _captionController,
                    decoration: InputDecoration(
                      hintText: 'Legenda (opcional)',
                      hintStyle: SLTypography.caption.copyWith(color: SLColors.textDisabled),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    style: SLTypography.caption.copyWith(color: SLColors.textPrimary),
                  ),
                ),
              ),
              const SizedBox(width: SLSpacing.space2),
              SLButton(
                label: _isUploading ? 'Enviando...' : 'Adicionar',
                variant: SLButtonVariant.primary,
                onPressed: _isUploading ? null : _pickAndUpload,
              ),
            ],
          ),

          if (_isUploading) ...[
            const SizedBox(height: SLSpacing.space3),
            LinearProgressIndicator(
              value: _uploadProgress > 0 ? _uploadProgress : null,
              backgroundColor: SLColors.bgSecondary,
              valueColor: const AlwaysStoppedAnimation<Color>(SLColors.accentGold),
            ),
            const SizedBox(height: SLSpacing.space1),
            Text('Fazendo upload...', style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
          ],

          const SizedBox(height: SLSpacing.space6),

          // Media grid
          Expanded(
            child: widget.mediaAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: SLColors.accentGold)),
              error: (e, _) => Center(
                child: Text('Erro ao carregar mídias', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
              ),
              data: (media) {
                if (media.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, size: 48, color: SLColors.textDisabled),
                        const SizedBox(height: SLSpacing.space4),
                        Text('Nenhuma mídia cadastrada', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
                        Text('Toque em "Adicionar" para enviar fotos ou vídeos', style: SLTypography.caption.copyWith(color: SLColors.textDisabled)),
                      ],
                    ),
                  );
                }

                return ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  padding: EdgeInsets.zero,
                  itemCount: media.length,
                  onReorderItem: (old, new_) => _reorder(old, new_, media),
                  itemBuilder: (_, i) {
                    final item = media[i];
                    return _MediaGridItem(
                      key: ValueKey(item.id),
                      item: item,
                      onTap: () => _showMediaOptions(item),
                      onLongPress: () => _confirmDelete(item.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaOptions(ServiceMedia item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: SLColors.bgPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SLSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!item.isCover)
                ListTile(
                  leading: const Icon(Icons.star, color: SLColors.accentGold),
                  title: const Text('Definir como capa'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _setAsCover(item.id);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remover', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(item.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaGridItem extends StatelessWidget {
  final ServiceMedia item;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _MediaGridItem({
    super.key,
    required this.item,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: 0,
            child: const Icon(Icons.drag_handle, color: SLColors.textDisabled),
          ),
          const SizedBox(width: SLSpacing.space2),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: item.isCover ? Border.all(color: SLColors.accentGold, width: 2) : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.network(item.url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: SLColors.bgSecondary)),
                      ),
                      const SizedBox(width: SLSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (item.caption != null)
                              Text(item.caption!, style: SLTypography.caption.copyWith(color: SLColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                if (item.isVideo)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Icon(Icons.videocam, size: 12, color: SLColors.textDisabled),
                                  ),
                                if (item.isCover)
                                  SLBadge(label: 'CAPA', variant: SLBadgeVariant.gold),
                                if (!item.isCover && !item.isVideo)
                                  Text('Imagem', style: SLTypography.caption.copyWith(color: SLColors.textDisabled)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.info_outline, size: 18, color: SLColors.textDisabled),
                      const SizedBox(width: SLSpacing.space2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
