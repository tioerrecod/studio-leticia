import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.all(SLSpacing.md),
        children: [
          _CampaignCard(
            title: 'Aniversariantes do m\u00eas',
            status: 'Ativo',
            sentCount: 12,
            openRate: '85%',
            conversionRate: '33%',
          ),
          _CampaignCard(
            title: 'Reativa\u00e7\u00e3o de clientes',
            status: 'Programado',
            sentCount: 0,
            openRate: '-',
            conversionRate: '-',
          ),
          _CampaignCard(
            title: 'Promo\u00e7\u00e3o Hidrata\u00e7\u00e3o',
            status: 'Rascunho',
            sentCount: 0,
            openRate: '-',
            conversionRate: '-',
          ),
        ],
      ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final String title;
  final String status;
  final int sentCount;
  final String openRate;
  final String conversionRate;

  const _CampaignCard({
    required this.title,
    required this.status,
    required this.sentCount,
    required this.openRate,
    required this.conversionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SLSpacing.sm),
      child: SLCard(
        variant: SLCardVariant.outlined,
        padding: const EdgeInsets.all(SLSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: SLTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SLColors.textPrimary,
                ),
              ),
              SLBadge(
                variant: status == 'Ativo'
                    ? SLBadgeVariant.success
                    : status == 'Programado'
                        ? SLBadgeVariant.info
                        : SLBadgeVariant.warning,
                label: status,
              ),
            ],
          ),
          const SizedBox(height: SLSpacing.md),
          Row(
            children: [
              _CampStat(
                label: 'Enviados',
                value: sentCount > 0 ? '$sentCount' : '-',
              ),
              const SizedBox(width: SLSpacing.xl),
              _CampStat(label: 'Abertura', value: openRate),
              const SizedBox(width: SLSpacing.xl),
              _CampStat(label: 'Convers\u00e3o', value: conversionRate),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

class _CampStat extends StatelessWidget {
  final String label;
  final String value;

  const _CampStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: SLTypography.h3.copyWith(color: SLColors.textPrimary),
        ),
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
