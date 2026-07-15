import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';
import '../../providers/providers.dart';

class CrmScreen extends ConsumerWidget {
  const CrmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersProvider);
    final searchQuery = ref.watch(customerSearchProvider);

    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Clientes',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined, color: SLColors.champagne),
            onPressed: () {
              // TODO: Navigate to create customer
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              SLSpacing.lg, SLSpacing.md, SLSpacing.lg, SLSpacing.sm,
            ),
            child: TextField(
              onChanged: (value) => ref.read(customerSearchProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Buscar cliente...',
                hintStyle: SLTypography.body.copyWith(color: SLColors.textDisabled),
                prefixIcon: const Icon(Icons.search, color: SLColors.textSecondary),
                filled: true,
                fillColor: SLColors.surface,
                border: OutlineInputBorder(
                  borderRadius: SLRadius.card,
                  borderSide: BorderSide(color: SLColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: SLRadius.card,
                  borderSide: BorderSide(color: SLColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: SLRadius.card,
                  borderSide: const BorderSide(color: SLColors.champagne),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: SLSpacing.md,
                  vertical: SLSpacing.sm,
                ),
              ),
            ),
          ),

          // Customer List
          Expanded(
            child: customersAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: SLColors.champagne),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
                    const SizedBox(height: SLSpacing.md),
                    Text('Erro ao carregar clientes', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
                    const SizedBox(height: SLSpacing.sm),
                    TextButton(
                      onPressed: () => ref.invalidate(customersProvider),
                      child: Text('Tentar novamente', style: SLTypography.button.copyWith(color: SLColors.champagne)),
                    ),
                  ],
                ),
              ),
              data: (customers) {
                if (customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_outline, size: 64, color: SLColors.textDisabled),
                        const SizedBox(height: SLSpacing.md),
                        Text(
                          'Nenhum cliente encontrado',
                          style: SLTypography.h3.copyWith(color: SLColors.textSecondary),
                        ),
                        const SizedBox(height: SLSpacing.sm),
                        Text(
                          'Cadastre o primeiro cliente',
                          style: SLTypography.body.copyWith(color: SLColors.textDisabled),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SLSpacing.lg,
                    vertical: SLSpacing.sm,
                  ),
                  itemCount: customers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: SLSpacing.sm),
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return _CustomerCard(customer: customer);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;

  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    final tier = _getTier(customer.totalSpent);

    return Container(
      padding: const EdgeInsets.all(SLSpacing.md),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: SLColors.carbon.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: SLColors.cream,
              shape: BoxShape.circle,
            ),
            child: customer.avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      customer.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          customer.initials,
                          style: SLTypography.body.copyWith(
                            color: SLColors.champagne,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      customer.initials,
                      style: SLTypography.body.copyWith(
                        color: SLColors.champagne,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: SLSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        customer.name,
                        style: SLTypography.body.copyWith(
                          color: SLColors.carbon,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SLSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getTierColor(tier).withValues(alpha: 0.1),
                        borderRadius: SLRadius.chip,
                      ),
                      child: Text(
                        tier,
                        style: SLTypography.overline.copyWith(
                          color: _getTierColor(tier),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                if (customer.phone != null)
                  Text(
                    customer.phone!,
                    style: SLTypography.caption.copyWith(
                      color: SLColors.textSecondary,
                    ),
                  ),
                const SizedBox(height: SLSpacing.xs),
                Row(
                  children: [
                    _InfoBadge(
                      icon: Icons.calendar_today,
                      label: '${customer.totalVisits} visitas',
                    ),
                    const SizedBox(width: SLSpacing.sm),
                    _InfoBadge(
                      icon: Icons.attach_money,
                      label: customer.formattedTotalSpent,
                    ),
                  ],
                ),
                if (customer.tags.isNotEmpty) ...[
                  const SizedBox(height: SLSpacing.xs),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: customer.tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: SLColors.cream,
                        borderRadius: SLRadius.chip,
                      ),
                      child: Text(
                        tag,
                        style: SLTypography.overline.copyWith(
                          color: SLColors.champagne,
                          fontSize: 9,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: SLSpacing.sm),
          Icon(
            Icons.chevron_right,
            color: SLColors.textDisabled,
            size: 20,
          ),
        ],
      ),
    );
  }

  String _getTier(double totalSpent) {
    if (totalSpent >= 5000) return 'PLATINA';
    if (totalSpent >= 2000) return 'OURO';
    if (totalSpent >= 1000) return 'PRATA';
    return 'BRONZE';
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case 'PLATINA':
        return SLColors.sage;
      case 'OURO':
        return SLColors.gold;
      case 'PRATA':
        return SLColors.textSecondary;
      default:
        return SLColors.champagne;
    }
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: SLColors.textDisabled),
        const SizedBox(width: 4),
        Text(
          label,
          style: SLTypography.overline.copyWith(
            color: SLColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}