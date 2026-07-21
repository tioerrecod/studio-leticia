import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  int _selectedTab = 0;

  static const _tabs = ['Todos', 'Online', 'Presencial', 'Mentorias', 'Masterclass'];

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
                  SLSpacing.space6,
                  SLSpacing.space10,
                  SLSpacing.space6,
                  SLSpacing.space2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cursos', style: SLTypography.display.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: SLColors.textPrimary,
                    )),
                    const SizedBox(height: SLSpacing.space1),
                    Text('Aprenda com profissionais',
                        style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
                  ],
                ),
              ),
            ),

            // ── Tabs ────────────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
                  itemCount: _tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: SLSpacing.space2),
                  itemBuilder: (_, i) {
                    final isSelected = i == _selectedTab;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: AnimatedContainer(
                        duration: SLAnimations.fast,
                        padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space5, vertical: SLSpacing.space2),
                        decoration: BoxDecoration(
                          color: isSelected ? SLColors.accentGold : SLColors.surface,
                          borderRadius: SLRadius.lg,
                          border: Border.all(color: isSelected ? SLColors.accentGold : SLColors.border, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            _tabs[i],
                            style: SLTypography.label.copyWith(
                              color: isSelected ? SLColors.textOnDark : SLColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space6)),

            // ── Course Cards ────────────────────────────
            ...List.generate(_sampleCourses.length, (i) {
              final course = _sampleCourses[i];
              return SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    SLSpacing.space4, 0, SLSpacing.space4,
                    i == _sampleCourses.length - 1 ? SLSpacing.space24 : SLSpacing.space4,
                  ),
                  child: SLCard(
                    variant: SLCardVariant.elevated,
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Image ──────────────────────────
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: SLColors.bgSecondary,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Center(
                            child: Icon(
                              _categoryIcon(course.category),
                              size: 48,
                              color: SLColors.accentGold.withValues(alpha: 0.3),
                            ),
                          ),
                        ),

                        // ── Info ───────────────────────────
                        Padding(
                          padding: const EdgeInsets.all(SLSpacing.space4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (course.isOnline)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: SLColors.stateInfo.withValues(alpha: 0.1),
                                        borderRadius: SLRadius.chip,
                                      ),
                                      child: Text('ONLINE', style: SLTypography.badge.copyWith(color: SLColors.stateInfo)),
                                    ),
                                  if (course.isExclusive) ...[
                                    const SizedBox(width: SLSpacing.space2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: SLColors.accentGold.withValues(alpha: 0.1),
                                        borderRadius: SLRadius.chip,
                                      ),
                                      child: Text('EXCLUSIVO', style: SLTypography.badge.copyWith(color: SLColors.accentGoldLight)),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: SLSpacing.space3),
                              Text(course.name, style: SLTypography.h3.copyWith(color: SLColors.textPrimary)),
                              const SizedBox(height: SLSpacing.space1),
                              Text('com ${course.instructor}', style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
                              const SizedBox(height: SLSpacing.space3),
                              Row(
                                children: [
                                  Icon(Icons.schedule_outlined, size: 14, color: SLColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(course.duration, style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
                                  const SizedBox(width: SLSpacing.space4),
                                  Icon(Icons.star_outlined, size: 14, color: SLColors.accentGold),
                                  const SizedBox(width: 4),
                                  Text('${course.rating}', style: SLTypography.caption.copyWith(color: SLColors.textSecondary)),
                                ],
                              ),
                              const SizedBox(height: SLSpacing.space4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(course.formattedPrice, style: SLTypography.price.copyWith(color: SLColors.accentGold)),
                                  SLButton(
                                    label: 'VER CURSO',
                                    onPressed: () {},
                                    isExpanded: false,
                                    height: 40,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Tranças': return Icons.spa_outlined;
      case 'Mega Hair': return Icons.auto_fix_high_outlined;
      case 'Masterclass': return Icons.stars_outlined;
      default: return Icons.school_outlined;
    }
  }
}

// ── Sample Data ──────────────────────────────────────────
class _CourseItem {
  final String name;
  final String instructor;
  final String duration;
  final double price;
  final double rating;
  final String category;
  final bool isOnline;
  final bool isExclusive;

  const _CourseItem({
    required this.name,
    required this.instructor,
    required this.duration,
    required this.price,
    this.rating = 4.8,
    this.category = 'Tranças',
    this.isOnline = false,
    this.isExclusive = false,
  });

  String get formattedPrice => 'R\$ ${price.toStringAsFixed(0)}';
}

const _sampleCourses = [
  _CourseItem(
    name: 'Tranças do Zero ao Avançado',
    instructor: 'Letícia Silva',
    duration: '24h · 8 módulos',
    price: 597,
    rating: 4.9,
    isOnline: true,
  ),
  _CourseItem(
    name: 'Mega Hair Premium',
    instructor: 'Camila Oliveira',
    duration: '16h · 6 módulos',
    price: 897,
    rating: 4.8,
    isExclusive: true,
  ),
  _CourseItem(
    name: 'Masterclass Penteados',
    instructor: 'Ana Costa',
    duration: '8h · 4 módulos',
    price: 347,
    rating: 4.7,
    isOnline: true,
  ),
  _CourseItem(
    name: 'Tranças Iniciantes',
    instructor: 'Letícia Silva',
    duration: '12h · 5 módulos',
    price: 397,
    rating: 4.6,
  ),
  _CourseItem(
    name: 'Mentoria Studio',
    instructor: 'Letícia Silva',
    duration: '30 dias',
    price: 1497,
    rating: 5.0,
    category: 'Masterclass',
    isExclusive: true,
  ),
];
