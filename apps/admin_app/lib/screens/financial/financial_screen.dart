import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class FinancialScreen extends StatelessWidget {
  const FinancialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Financeiro',
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
          Row(
            children: [
              Expanded(
                child: _FinancialCard(
                  label: 'Faturamento',
                  value: 'R\$ 28.450',
                  change: '+12,5%',
                ),
              ),
              const SizedBox(width: SLSpacing.sm),
              Expanded(
                child: _FinancialCard(
                  label: 'Ticket M\u00e9dio',
                  value: 'R\$ 185',
                  change: '+5,2%',
                ),
              ),
            ],
          ),
          const SizedBox(height: SLSpacing.sm),
          Row(
            children: [
              const Expanded(
                child: _FinancialCard(
                  label: 'Comiss\u00f5es',
                  value: 'R\$ 5.690',
                ),
              ),
              const SizedBox(width: SLSpacing.sm),
              const Expanded(
                child: _FinancialCard(
                  label: 'Inadimpl\u00eancia',
                  value: '3,2%',
                  isPositive: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: SLSpacing.xxl),

          Text(
            'TRANSA\u00c7\u00d5ES RECENTES',
            style: SLTypography.overline.copyWith(
              color: SLColors.champagne,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: SLSpacing.md),

          _TransactionRow(
            client: 'Rafaela',
            service: 'Hidrata\u00e7\u00e3o Premium',
            value: 'R\$ 250',
            date: '15 jun',
          ),
          _TransactionRow(
            client: 'Mariana',
            service: 'Corte Personalizado',
            value: 'R\$ 180',
            date: '15 jun',
          ),
          _TransactionRow(
            client: 'Ana Beatriz',
            service: 'Colora\u00e7\u00e3o + Corte',
            value: 'R\$ 420',
            date: '14 jun',
          ),
          _TransactionRow(
            client: 'Camila',
            service: 'Escova Modeladora',
            value: 'R\$ 120',
            date: '14 jun',
          ),
          _TransactionRow(
            client: 'Juliana',
            service: 'Spa Capilar',
            value: 'R\$ 350',
            date: '13 jun',
          ),
        ],
      ),
    );
  }
}

class _FinancialCard extends StatelessWidget {
  final String label;
  final String value;
  final String? change;
  final bool isPositive;

  const _FinancialCard({
    required this.label,
    required this.value,
    this.change,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SLSpacing.md),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: SLTypography.caption.copyWith(
              color: SLColors.textSecondary,
            ),
          ),
          const SizedBox(height: SLSpacing.sm),
          Text(
            value,
            style: SLTypography.h3.copyWith(color: SLColors.carbon),
          ),
          if (change != null) ...[
            const SizedBox(height: SLSpacing.xs),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: isPositive ? SLColors.success : SLColors.error,
                ),
                const SizedBox(width: 2),
                Text(
                  change!,
                  style: SLTypography.caption.copyWith(
                    color: isPositive ? SLColors.success : SLColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final String client;
  final String service;
  final String value;
  final String date;

  const _TransactionRow({
    required this.client,
    required this.service,
    required this.value,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SLSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client,
                  style: SLTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: SLColors.carbon,
                  ),
                ),
                Text(
                  service,
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: SLTypography.body.copyWith(
              fontWeight: FontWeight.w600,
              color: SLColors.carbon,
            ),
          ),
          const SizedBox(width: SLSpacing.md),
          Text(
            date,
            style: SLTypography.caption.copyWith(
              color: SLColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
