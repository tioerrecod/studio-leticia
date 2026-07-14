import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Meu Beauty Passport',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: SLSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SLSpacing.sm),
            SLBeautyPassport(
              name: 'Rafaela',
              tierName: 'OURO',
              points: 340,
              pointsToNext: 160,
              visits: 12,
              memberSince: 'JUN 2025',
            ),

            const SizedBox(height: SLSpacing.xxl),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SLSpacing.md + SLSpacing.xs),
              child: Row(
                children: [
                  const Icon(Icons.style,
                      size: 18, color: SLColors.champagne),
                  const SizedBox(width: SLSpacing.sm),
                  Text(
                    'Meu Estilo',
                    style: SLTypography.h2.copyWith(
                      color: SLColors.carbon,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SLSpacing.md),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: SLSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(SLSpacing.lg),
                decoration: BoxDecoration(
                  color: SLColors.surface,
                  borderRadius: SLRadius.card,
                  border:
                      Border.all(color: SLColors.border, width: 0.5),
                ),
                child: Column(
                  children: [
                    _StyleRow(
                        label: 'TIPO DE CABELO',
                        value: 'Ondulado (3A)'),
                    _StyleRow(
                        label: 'COLORA\u00c7\u00c3O',
                        value: 'Loiro mel'),
                    _StyleRow(
                        label: 'EVITAR',
                        value: 'Produtos com sulfato'),
                    _StyleRow(
                        label: 'FAVORITO',
                        value: 'M\u00e1scara Hidratante'),
                    _StyleRow(
                        label: 'FREQU\u00caNCIA',
                        value: 'Quinzenal'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: SLSpacing.xxl),

            SLClientMemoryTimeline(
              title: 'Minha Mem\u00f3ria',
              memories: [
                const SLMemoryEntry(
                  emoji: '\u{1F487}\u200D\u2640\uFE0F',
                  message:
                      'Prefere conversar pouco durante qu\u00edmica.',
                  date: '15 jun 2026',
                  context: 'Let\u00edcia observou',
                  isActive: true,
                ),
                const SLMemoryEntry(
                  emoji: '\u{1F48D}',
                  message: 'Planejando casamento para setembro.',
                  date: '12 mar 2026',
                  context: 'Rafaela compartilhou',
                  isActive: true,
                ),
                const SLMemoryEntry(
                  emoji: '\u{1F338}',
                  message:
                      'Al\u00e9rgica a ess\u00eancias florais fortes.',
                  date: '02 jan 2026',
                  context: 'Cadastro',
                  isActive: true,
                ),
              ],
            ),

            const SizedBox(height: SLSpacing.xxl),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SLSpacing.md + SLSpacing.xs),
              child: Row(
                children: [
                  const Icon(Icons.photo_library_outlined,
                      size: 18, color: SLColors.champagne),
                  const SizedBox(width: SLSpacing.sm),
                  Text(
                    'Minhas Fotos',
                    style: SLTypography.h2.copyWith(
                      color: SLColors.carbon,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SLSpacing.md),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: SLSpacing.md),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: SLSpacing.sm,
                crossAxisSpacing: SLSpacing.sm,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(6, (i) {
                  return Container(
                    decoration: BoxDecoration(
                      color: SLColors.cream,
                      borderRadius: SLRadius.input,
                      border: Border.all(
                          color: SLColors.border, width: 0.5),
                    ),
                    child: const Center(
                      child: Icon(Icons.spa_outlined,
                          color: SLColors.champagne, size: 24),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyleRow extends StatelessWidget {
  final String label;
  final String value;

  const _StyleRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SLSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: SLTypography.overline.copyWith(
                color: SLColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: SLTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: SLColors.carbon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
