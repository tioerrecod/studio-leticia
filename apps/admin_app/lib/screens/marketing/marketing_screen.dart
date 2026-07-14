import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Marketing',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
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
    return Container(
      margin: const EdgeInsets.only(bottom: SLSpacing.sm),
      padding: const EdgeInsets.all(SLSpacing.lg),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
      ),
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
                  color: SLColors.carbon,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SLSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: status == 'Ativo'
                      ? SLColors.success.withValues(alpha: 0.1)
                      : status == 'Programado'
                          ? SLColors.info.withValues(alpha: 0.1)
                          : SLColors.divider.withValues(alpha: 0.3),
                  borderRadius: SLRadius.chip,
                ),
                child: Text(
                  status,
                  style: SLTypography.caption.copyWith(
                    color: status == 'Ativo'
                        ? SLColors.success
                        : status == 'Programado'
                            ? SLColors.info
                            : SLColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
          style: SLTypography.h3.copyWith(color: SLColors.carbon),
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
