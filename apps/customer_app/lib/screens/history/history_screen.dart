import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Minha Jornada',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
            SLSpacing.md, SLSpacing.lg, SLSpacing.md, SLSpacing.xxl),
        itemCount: _mockHistory.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: SLSpacing.xs, bottom: SLSpacing.lg),
              child: Text(
                '2026',
                style: SLTypography.h2.copyWith(
                  color: SLColors.carbon,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }

          final entry = _mockHistory[i - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: SLSpacing.sm),
            child: Container(
              padding: const EdgeInsets.all(SLSpacing.md),
              decoration: BoxDecoration(
                color: SLColors.surface,
                borderRadius: SLRadius.card,
                border:
                    Border.all(color: SLColors.border, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: SLColors.carbon.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 44,
                    child: Column(
                      children: [
                        Text(
                          entry.day,
                          style: SLTypography.h2.copyWith(
                            color: SLColors.carbon,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          entry.month.toUpperCase(),
                          style: SLTypography.overline.copyWith(
                            color: SLColors.champagne,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: SLSpacing.sm),
                  Container(
                    width: 2,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [SLColors.champagne, SLColors.gold],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(width: SLSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.serviceName,
                          style: SLTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: SLColors.carbon,
                          ),
                        ),
                        const SizedBox(height: SLSpacing.mini),
                        Text(
                          entry.professionalName,
                          style: SLTypography.caption
                              .copyWith(color: SLColors.textSecondary),
                        ),
                        const SizedBox(height: SLSpacing.xs),
                        Row(
                          children: [
                            Text(
                              entry.price,
                              style: SLTypography.bodySmall.copyWith(
                                color: SLColors.champagne,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (entry.rating != null) ...[
                              const SizedBox(width: SLSpacing.sm),
                              const Icon(Icons.star,
                                  size: 14, color: SLColors.gold),
                              const SizedBox(width: 2),
                              Text(
                                entry.rating!.toStringAsFixed(1),
                                style: SLTypography.caption
                                    .copyWith(color: SLColors.gold),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HistoryEntry {
  final String day;
  final String month;
  final String year;
  final String serviceName;
  final String professionalName;
  final String price;
  final double? rating;

  const _HistoryEntry({
    required this.day,
    required this.month,
    required this.year,
    required this.serviceName,
    required this.professionalName,
    required this.price,
    this.rating,
  });
}

final List<_HistoryEntry> _mockHistory = [
  _HistoryEntry(
      day: '15',
      month: 'jun',
      year: '2026',
      serviceName: 'Corte Personalizado',
      professionalName: 'Let\u00edcia',
      price: 'R\$ 180',
      rating: 5.0),
  _HistoryEntry(
      day: '02',
      month: 'mai',
      year: '2026',
      serviceName: 'Hidrata\u00e7\u00e3o Premium',
      professionalName: 'Camila',
      price: 'R\$ 250',
      rating: 4.5),
  _HistoryEntry(
      day: '18',
      month: 'abr',
      year: '2026',
      serviceName: 'Escova Modeladora',
      professionalName: 'Camila',
      price: 'R\$ 120',
      rating: 4.0),
  _HistoryEntry(
      day: '05',
      month: 'abr',
      year: '2026',
      serviceName: 'Spa Capilar Experi\u00eancia',
      professionalName: 'Let\u00edcia',
      price: 'R\$ 350',
      rating: 5.0),
  _HistoryEntry(
      day: '12',
      month: 'mar',
      year: '2026',
      serviceName: 'Colora\u00e7\u00e3o + Corte',
      professionalName: 'Let\u00edcia',
      price: 'R\$ 420',
      rating: 4.5),
];
