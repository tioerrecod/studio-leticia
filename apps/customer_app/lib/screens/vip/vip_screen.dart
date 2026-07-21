import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';

class BenefitItem {
  final IconData icon;
  final String title;
  final String description;
  final int pointsCost;

  const BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.pointsCost,
  });
}

final _benefitsProvider = Provider<List<BenefitItem>>((ref) {
  return const [
    BenefitItem(
      icon: Icons.auto_fix_high_outlined,
      title: 'Escova Premium',
      description: 'Escova de modelagem com finalização profissional',
      pointsCost: 500,
    ),
    BenefitItem(
      icon: Icons.face_outlined,
      title: 'Consultoria',
      description: 'Consultoria de imagem completa com nossa equipe',
      pointsCost: 800,
    ),
    BenefitItem(
      icon: Icons.discount_outlined,
      title: 'Desconto 15%',
      description: '15%OFF em qualquer serviço do catálogo',
      pointsCost: 400,
    ),
    BenefitItem(
      icon: Icons.school_outlined,
      title: 'Curso Exclusivo',
      description: 'Acesso ao workshop mensal para membros VIP',
      pointsCost: 1200,
    ),
    BenefitItem(
      icon: Icons.card_giftcard_outlined,
      title: 'Brinde Aniversário',
      description: 'Kit presente exclusivo no mês do seu aniversário',
      pointsCost: 0,
    ),
  ];
});

class VipScreen extends ConsumerStatefulWidget {
  const VipScreen({super.key});

  @override
  ConsumerState<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends ConsumerState<VipScreen> {
  @override
  Widget build(BuildContext context) {
    final benefits = ref.watch(_benefitsProvider);

    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SLSpacing.space6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Área VIP',
                style: SLTypography.h1.copyWith(
                  color: SLColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sua Jornada',
                style: SLTypography.body.copyWith(
                  color: SLColors.textSecondary,
                ),
              ),
              const SizedBox(height: SLSpacing.space8),
              _HeroCard(),
              const SizedBox(height: SLSpacing.space8),
              Text(
                'Benefícios Exclusivos',
                style: SLTypography.h2.copyWith(
                  color: SLColors.textPrimary,
                ),
              ),
              const SizedBox(height: SLSpacing.space6),
              ...benefits.map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: SLSpacing.space4),
                child: _BenefitCard(item: benefit),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const currentPoints = 2450;
    const nextLevelPoints = 3000;
    final progress = currentPoints / nextLevelPoints;

    return SLCard(
      variant: SLCardVariant.elevated,
      padding: const EdgeInsets.all(SLSpacing.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SLBadge(label: 'OURO', variant: SLBadgeVariant.gold),
              Icon(Icons.auto_awesome, color: SLColors.accentGold, size: 20),
            ],
          ),
          const SizedBox(height: SLSpacing.space6),
          Text(
            '$currentPoints',
            style: SLTypography.display.copyWith(
              color: SLColors.textPrimary,
              fontSize: 40,
            ),
          ),
          Text(
            'pontos acumulados',
            style: SLTypography.caption.copyWith(
              color: SLColors.textSecondary,
            ),
          ),
          const SizedBox(height: SLSpacing.space6),
          ClipRRect(
            borderRadius: SLRadius.full,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: SLColors.bgSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(SLColors.accentGold),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: SLSpacing.space3),
          Text(
            'Próximo nível: PLATINA ($nextLevelPoints pts)',
            style: SLTypography.caption.copyWith(
              color: SLColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final BenefitItem item;

  const _BenefitCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SLCard(
      variant: SLCardVariant.outlined,
      padding: const EdgeInsets.all(SLSpacing.space5),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SLColors.accentGold.withValues(alpha: 0.1),
            ),
            child: Icon(item.icon, color: SLColors.accentGold, size: 20),
          ),
          const SizedBox(width: SLSpacing.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: SLTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: SLColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: SLSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (item.pointsCost > 0)
                Text(
                  '${item.pointsCost} pts',
                  style: SLTypography.caption.copyWith(
                    color: SLColors.accentGold,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                Text(
                  'GRÁTIS',
                  style: SLTypography.caption.copyWith(
                    color: SLColors.stateSuccess,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: SLSpacing.space2),
              SLButton(
                label: 'RESGATAR',
                variant: SLButtonVariant.outline,
                isExpanded: false,
                height: 32,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
