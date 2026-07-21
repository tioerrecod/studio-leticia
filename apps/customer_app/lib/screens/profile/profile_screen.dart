import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/supabase_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _selectedTab = 0;

  static const _tabs = ['Perfil', 'Histórico', 'Fotos', 'Produtos', 'Favoritos'];

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final loyaltyAsync = ref.watch(loyaltyProvider);
    final appointmentsAsync = ref.watch(completedAppointmentsProvider);

    final profile = profileAsync.valueOrNull ?? {};
    final name = profile['name'] as String? ?? 'Cliente';
    final email = profile['email'] as String? ?? '';
    final phone = profile['phone'] as String? ?? '';
    final birthDate = profile['birth_date'] as String? ?? '';
    final favoriteColor = profile['favorite_color'] as String? ?? '';
    final favoriteStyle = profile['favorite_style'] as String? ?? '';
    final favoriteProfessional = profile['favorite_professional'] as String? ?? '';

    final loyalty = loyaltyAsync.valueOrNull ?? {};
    final currentPoints = loyalty['current_points'] ?? 0;

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SLSpacing.space6,
                  SLSpacing.space10,
                  SLSpacing.space6,
                  SLSpacing.space6,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: SLColors.surface,
                            child: Icon(
                              Icons.person,
                              size: 48,
                              color: SLColors.accentGold,
                            ),
                          ),
                          const SizedBox(height: SLSpacing.space3),
                          Text(
                            name,
                            style: SLTypography.display.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: SLColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: SLSpacing.space2),
                          SLBadge(label: 'OURO'),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit_outlined,
                        color: SLColors.accentGold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: SLSpacing.space5,
                          vertical: SLSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? SLColors.accentGold : SLColors.surface,
                          borderRadius: SLRadius.lg,
                          border: Border.all(
                            color: isSelected ? SLColors.accentGold : SLColors.border,
                            width: 0.5,
                          ),
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
            if (_selectedTab == 0)
              _PerfilTab(
                name: name,
                phone: phone,
                email: email,
                birthDate: birthDate,
                favoriteColor: favoriteColor,
                favoriteStyle: favoriteStyle,
                favoriteProfessional: favoriteProfessional,
                currentPoints: currentPoints,
              ),
            if (_selectedTab == 1)
              ..._buildHistoricoTab(appointmentsAsync),
            if (_selectedTab == 2)
              _FotosTab(),
            if (_selectedTab == 3)
              _ProdutosTab(),
            if (_selectedTab == 4)
              _FavoritosTab(),
            const SliverToBoxAdapter(child: SizedBox(height: SLSpacing.space24)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHistoricoTab(AsyncValue<List<Appointment>> appointmentsAsync) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
          child: appointmentsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(SLSpacing.space12),
                child: CircularProgressIndicator(color: SLColors.accentGold),
              ),
            ),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(SLSpacing.space12),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
                    const SizedBox(height: SLSpacing.space3),
                    Text(
                      'Erro ao carregar hist\u00f3rico',
                      style: SLTypography.body.copyWith(color: SLColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            data: (appointments) {
              if (appointments.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(SLSpacing.space12),
                    child: Column(
                      children: [
                        Icon(Icons.history, size: 64, color: SLColors.textDisabled),
                        const SizedBox(height: SLSpacing.space4),
                        Text(
                          'Nenhum agendamento encontrado',
                          style: SLTypography.h3.copyWith(color: SLColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: List.generate(appointments.length, (i) {
                  final a = appointments[i];
                  final day = (a.dateTime ?? a.startAt).day.toString().padLeft(2, '0');
                  final month = _monthAbbr((a.dateTime ?? a.startAt).month);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: SLSpacing.space2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 52,
                              child: Column(
                                children: [
                                  Text(
                                    day,
                                    style: SLTypography.h2.copyWith(
                                      color: SLColors.accentGold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    month,
                                    style: SLTypography.caption.copyWith(
                                      color: SLColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SLCard(
                                variant: SLCardVariant.outlined,
                                padding: const EdgeInsets.all(SLSpacing.space4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a.serviceName ?? a.service?.name ?? 'Servi\u00e7o',
                                      style: SLTypography.body.copyWith(
                                        color: SLColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: SLSpacing.space1),
                                    Text(
                                      'com ${a.professional?.name ?? 'Profissional'}',
                                      style: SLTypography.caption.copyWith(
                                        color: SLColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: SLSpacing.space2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'R\$ ${(a.servicePrice ?? a.service?.price ?? 0).toStringAsFixed(2)}',
                                          style: SLTypography.body.copyWith(
                                            color: SLColors.accentGold,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          a.formattedDate,
                                          style: SLTypography.caption.copyWith(
                                            color: SLColors.textSecondary,
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
                      if (i < appointments.length - 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 52),
                          child: Divider(
                            color: SLColors.border,
                            height: 1,
                            thickness: 0.5,
                          ),
                        ),
                    ],
                  );
                }),
              );
            },
          ),
        ),
      ),
    ];
  }

  String _monthAbbr(int? month) {
    switch (month) {
      case 1: return 'JAN';
      case 2: return 'FEV';
      case 3: return 'MAR';
      case 4: return 'ABR';
      case 5: return 'MAI';
      case 6: return 'JUN';
      case 7: return 'JUL';
      case 8: return 'AGO';
      case 9: return 'SET';
      case 10: return 'OUT';
      case 11: return 'NOV';
      case 12: return 'DEZ';
      default: return '';
    }
  }
}

class _PerfilTab extends SliverToBoxAdapter {
  _PerfilTab({
    required String name,
    required String phone,
    required String email,
    required String birthDate,
    required String favoriteColor,
    required String favoriteStyle,
    required String favoriteProfessional,
    required dynamic currentPoints,
  }) : super(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoSection(title: 'Dados Pessoais', items: [
                  _InfoRow(label: 'Nome', value: name),
                  _InfoRow(label: 'Telefone', value: phone),
                  _InfoRow(label: 'Email', value: email),
                  _InfoRow(label: 'Nascimento', value: birthDate),
                ]),
                const SizedBox(height: SLSpacing.space6),
                _InfoSection(title: 'Prefer\u00eancias', items: [
                  _InfoRow(label: 'Cor favorita', value: favoriteColor),
                  _InfoRow(label: 'Estilo favorito', value: favoriteStyle),
                  _InfoRow(label: 'Profissional favorita', value: favoriteProfessional),
                ]),
                const SizedBox(height: SLSpacing.space6),
                SLCard(
                  variant: SLCardVariant.outlined,
                  padding: const EdgeInsets.all(SLSpacing.space4),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: SLColors.accentGold, size: 28),
                      const SizedBox(width: SLSpacing.space3),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$currentPoints',
                            style: SLTypography.h2.copyWith(
                              color: SLColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Pontos de fidelidade',
                            style: SLTypography.caption.copyWith(
                              color: SLColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoRow> items;

  const _InfoSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: SLSpacing.space3),
          child: Text(
            title,
            style: SLTypography.overline.copyWith(
              color: SLColors.accentGold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SLCard(
          variant: SLCardVariant.outlined,
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SLSpacing.space4,
                      vertical: SLSpacing.space3,
                    ),
                    child: items[i],
                  ),
                  if (i < items.length - 1)
                    Divider(
                      color: SLColors.border,
                      height: 1,
                      thickness: 0.5,
                      indent: SLSpacing.space4,
                      endIndent: SLSpacing.space4,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: SLTypography.body.copyWith(
            color: SLColors.textSecondary,
          ),
        ),
        Text(
          value.isNotEmpty ? value : '-',
          style: SLTypography.body.copyWith(
            color: SLColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _FotosTab extends SliverToBoxAdapter {
  _FotosTab() : super(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: SLSpacing.space3,
        crossAxisSpacing: SLSpacing.space3,
        childAspectRatio: 1,
        children: List.generate(9, (i) {
          final colors = [
            SLColors.accentGoldLight,
            SLColors.surfaceVariant,
            SLColors.divider,
            SLColors.bgSecondary,
            SLColors.accentGoldLight,
            SLColors.surfaceVariant,
            SLColors.divider,
            SLColors.bgSecondary,
            SLColors.accentGoldLight,
          ];
          return Container(
            decoration: BoxDecoration(
              color: colors[i % colors.length].withValues(alpha: 0.3),
              borderRadius: SLRadius.card,
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              color: SLColors.textSecondary.withValues(alpha: 0.5),
              size: 28,
            ),
          );
        }),
      ),
    ),
  );
}

class _ProdutosTab extends SliverToBoxAdapter {
  _ProdutosTab() : super(
    child: SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
        itemCount: _sampleProducts.length,
        separatorBuilder: (_, __) => const SizedBox(width: SLSpacing.space3),
        itemBuilder: (_, i) {
          final product = _sampleProducts[i];
          return SizedBox(
            width: 180,
            child: SLCard(
              variant: SLCardVariant.outlined,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: SLColors.bgSecondary,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 40,
                        color: SLColors.accentGold.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(SLSpacing.space3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: SLTypography.bodySmall.copyWith(
                              color: SLColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.formattedPrice,
                                style: SLTypography.label.copyWith(
                                  color: SLColors.accentGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: SLSpacing.space1),
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: SLSpacing.space1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: SLColors.accentGold,
                                    borderRadius: SLRadius.button,
                                  ),
                                  child: Text(
                                    'COMPRAR',
                                    textAlign: TextAlign.center,
                                    style: SLTypography.buttonSmall.copyWith(
                                      color: SLColors.textOnDark,
                                    ),
                                  ),
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
        },
      ),
    ),
  );
}

class _FavoritosTab extends SliverToBoxAdapter {
  _FavoritosTab() : super(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: SLSpacing.space4),
      child: SLCard(
        variant: SLCardVariant.outlined,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _FavoritoItem(
              icon: Icons.spa_outlined,
              label: 'Servi\u00e7os favoritos',
            ),
            Divider(color: SLColors.border, height: 1, thickness: 0.5, indent: SLSpacing.space4),
            _FavoritoItem(
              icon: Icons.auto_awesome_outlined,
              label: 'Inspira\u00e7\u00f5es favoritas',
            ),
            Divider(color: SLColors.border, height: 1, thickness: 0.5, indent: SLSpacing.space4),
            _FavoritoItem(
              icon: Icons.menu_book_outlined,
              label: 'Cursos favoritos',
            ),
          ],
        ),
      ),
    ),
  );
}

class _FavoritoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FavoritoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SLSpacing.space4,
          vertical: SLSpacing.space4,
        ),
        child: Row(
          children: [
            Icon(icon, color: SLColors.accentGold, size: 22),
            const SizedBox(width: SLSpacing.space3),
            Expanded(
              child: Text(
                label,
                style: SLTypography.body.copyWith(
                  color: SLColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: SLColors.textDisabled, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ProdutoItem {
  final String name;
  final double price;

  const _ProdutoItem({required this.name, required this.price});

  String get formattedPrice => 'R\$ ${price.toStringAsFixed(2)}';
}

const _sampleProducts = [
  _ProdutoItem(name: 'Shampoo Profissional', price: 89.90),
  _ProdutoItem(name: 'Condicionador Reconstrutor', price: 97.90),
  _ProdutoItem(name: 'M\u00e1scara Capilar', price: 129.90),
  _ProdutoItem(name: '\u00d3leo Reparador', price: 69.90),
  _ProdutoItem(name: 'Kit Finalizador', price: 199.90),
];
