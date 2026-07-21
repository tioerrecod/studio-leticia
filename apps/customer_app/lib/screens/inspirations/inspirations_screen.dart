import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';

class InspirationsScreen extends ConsumerStatefulWidget {
  const InspirationsScreen({super.key});

  @override
  ConsumerState<InspirationsScreen> createState() => _InspirationsScreenState();
}

class _InspirationsScreenState extends ConsumerState<InspirationsScreen> {
  int _selectedFilter = 0;

  static const _filters = [
    'Todos',
    'Tranças',
    'Mega Hair',
    'Noivas',
    'Penteados',
    'Infantil',
    'Eventos',
    'Favoritos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SLSpacing.space4,
                  SLSpacing.space10,
                  SLSpacing.space4,
                  SLSpacing.space4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Inspirações',
                            style: SLTypography.h1.copyWith(
                              color: SLColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: SLSpacing.space1),
                          Text(
                            'Descubra seu próximo visual',
                            style: SLTypography.body.copyWith(
                              color: SLColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _HeaderIconButton(
                      icon: Icons.search_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(width: SLSpacing.space2),
                    _HeaderIconButton(
                      icon: Icons.tune_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Filter Chips ────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: SLSpacing.space2),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilter == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: SLSpacing.space5,
                          vertical: SLSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? SLColors.accentGold : SLColors.surface,
                          borderRadius: SLRadius.chip,
                          border: Border.all(
                            color: isSelected
                                ? SLColors.accentGold
                                : SLColors.border,
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _filters[index],
                            style: SLTypography.label.copyWith(
                              color: isSelected
                                  ? SLColors.textOnDark
                                  : SLColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space4)),

            // ── Grid ────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: SLSpacing.space3,
                  crossAxisSpacing: SLSpacing.space3,
                  childAspectRatio: 0.62,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _InspirationCard(
                    item: _sampleInspirations[index],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Detalhes em breve!'),
                          backgroundColor: SLColors.accentGold,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  childCount: _sampleInspirations.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space24)),
          ],
        ),
      ),
    );
  }
}

// ── Header Icon Button ───────────────────────────────────
class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: SLColors.surface,
          borderRadius: SLRadius.md,
          border: Border.all(color: SLColors.border, width: 0.5),
        ),
        child: Icon(icon, color: SLColors.textPrimary, size: 22),
      ),
    );
  }
}

// ── Inspiration Card ─────────────────────────────────────
class _InspirationCard extends StatelessWidget {
  final _InspirationItem item;
  final VoidCallback onTap;

  const _InspirationCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: SLColors.surface,
          borderRadius: SLRadius.card,
          border: Border.all(color: SLColors.border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: SLColors.bgInverse.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Photo (85% of card height) ──────────────
            Expanded(
              flex: 85,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: SLColors.bgSecondary,
                    child: item.imageUrl.isNotEmpty
                        ? Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _Placeholder(
                              icon: _categoryIcon(item.category),
                            ),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const _Placeholder(
                                icon: Icons.image_outlined,
                              );
                            },
                          )
                        : _Placeholder(
                            icon: _categoryIcon(item.category),
                          ),
                  ),
                  // ── Heart icon ──────────────────────────
                  Positioned(
                    top: SLSpacing.space2,
                    right: SLSpacing.space2,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: SLColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: SLColors.bgInverse.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        item.isFavorited
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: item.isFavorited
                            ? SLColors.stateError
                            : SLColors.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                  // ── Category badge ──────────────────────
                  Positioned(
                    bottom: SLSpacing.space2,
                    left: SLSpacing.space2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SLSpacing.space2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: SLColors.surface.withValues(alpha: 0.9),
                        borderRadius: SLRadius.sm,
                      ),
                      child: Text(
                        item.category,
                        style: SLTypography.badge.copyWith(
                          color: SLColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Info (15% of card height) ─────────────
            Expanded(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SLSpacing.space3,
                  SLSpacing.space2,
                  SLSpacing.space3,
                  SLSpacing.space2,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: SLTypography.body.copyWith(
                          color: SLColors.textPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: SLSpacing.space1),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          size: 12,
                          color: SLColors.textDisabled,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _formatSaves(item.saves),
                          style: SLTypography.caption.copyWith(
                            color: SLColors.textDisabled,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSaves(int saves) {
    if (saves >= 1000) {
      return '${(saves / 1000).toStringAsFixed(1)}k';
    }
    return saves.toString();
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Tranças':
        return Icons.auto_awesome;
      case 'Mega Hair':
        return Icons.auto_fix_high;
      case 'Noivas':
        return Icons.favorite;
      case 'Penteados':
        return Icons.star;
      case 'Infantil':
        return Icons.child_care;
      case 'Eventos':
        return Icons.event;
      default:
        return Icons.photo_outlined;
    }
  }
}

// ── Placeholder ──────────────────────────────────────────
class _Placeholder extends StatelessWidget {
  final IconData icon;

  const _Placeholder({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SLColors.bgSecondary,
      child: Center(
        child: Icon(icon, size: 32, color: SLColors.textDisabled),
      ),
    );
  }
}

// ── Sample Data ──────────────────────────────────────────
class _InspirationItem {
  final String name;
  final String category;
  final int saves;
  final String imageUrl;
  final bool isFavorited;

  const _InspirationItem({
    required this.name,
    required this.category,
    this.saves = 0,
    this.imageUrl = '',
    this.isFavorited = false,
  });
}

const _sampleInspirations = [
  _InspirationItem(
    name: 'Box Braids Longas',
    category: 'Tranças',
    saves: 1234,
    imageUrl: '',
    isFavorited: true,
  ),
  _InspirationItem(
    name: 'Mega Hair Liso Glossy',
    category: 'Mega Hair',
    saves: 892,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Coque Clássico Noiva',
    category: 'Noivas',
    saves: 2456,
    imageUrl: '',
    isFavorited: true,
  ),
  _InspirationItem(
    name: 'Trança Nagô Lateral',
    category: 'Tranças',
    saves: 567,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Cabelo Afro Natural',
    category: 'Eventos',
    saves: 3412,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Mega Hair Ondulado',
    category: 'Mega Hair',
    saves: 789,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Penteado Infantil Festa',
    category: 'Infantil',
    saves: 234,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Trança Box Braids Curta',
    category: 'Tranças',
    saves: 1023,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Maquiagem Noiva Premium',
    category: 'Noivas',
    saves: 1890,
    imageUrl: '',
    isFavorited: true,
  ),
  _InspirationItem(
    name: 'Mega Hair Cacheada',
    category: 'Mega Hair',
    saves: 456,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Penteados Africanos',
    category: 'Eventos',
    saves: 2100,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Tranças Twists',
    category: 'Tranças',
    saves: 678,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Penteado 15 Anos',
    category: 'Eventos',
    saves: 1567,
    imageUrl: '',
  ),
  _InspirationItem(
    name: 'Infantil Trança Box Braids',
    category: 'Infantil',
    saves: 345,
    imageUrl: '',
  ),
];
