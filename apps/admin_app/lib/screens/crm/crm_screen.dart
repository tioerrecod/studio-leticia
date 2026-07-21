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

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: Column(
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
                  borderSide: const BorderSide(color: SLColors.accentGold),
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
                child: CircularProgressIndicator(color: SLColors.accentGold),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: SLColors.textSecondary),
                    const SizedBox(height: SLSpacing.md),
                    Text('Erro ao carregar clientes', style: SLTypography.body.copyWith(color: SLColors.textSecondary)),
                    const SizedBox(height: SLSpacing.sm),
                    SLButton(
                      label: 'Tentar novamente',
                      variant: SLButtonVariant.text,
                      onPressed: () => ref.invalidate(customersProvider),
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
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;

  const _CustomerCard({required this.customer});

  SLBadgeVariant _getTierBadgeVariant(String tier) {
    switch (tier) {
      case 'PLATINA':
        return SLBadgeVariant.success;
      case 'OURO':
        return SLBadgeVariant.warning;
      case 'PRATA':
        return SLBadgeVariant.info;
      default:
        return SLBadgeVariant.gold;
    }
  }

  String _getTier(double totalSpent) {
    if (totalSpent >= 5000) return 'PLATINA';
    if (totalSpent >= 2000) return 'OURO';
    if (totalSpent >= 1000) return 'PRATA';
    return 'BRONZE';
  }

  @override
  Widget build(BuildContext context) {
    final tier = _getTier(customer.totalSpent);

    return SLCard(
      variant: SLCardVariant.outlined,
      onTap: () {},
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: SLColors.bgSecondary,
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
                            color: SLColors.accentGold,
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
                        color: SLColors.accentGold,
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
                          color: SLColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SLBadge(
                      variant: _getTierBadgeVariant(tier),
                      label: tier,
                    ),
                  ],
                ),
                const SizedBox(height: SLSpacing.xs),
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
                    spacing: SLSpacing.xs,
                    runSpacing: SLSpacing.xs,
                    children: customer.tags.map((tag) => SLBadge(
                      variant: SLBadgeVariant.info,
                      label: tag,
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
        const SizedBox(width: SLSpacing.xs),
        Text(
          label,
          style: SLTypography.caption.copyWith(
            color: SLColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
