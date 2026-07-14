import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Configura\u00e7\u00f5es',
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
          _SettingsItem(
            icon: Icons.store_outlined,
            title: 'Meu Est\u00fadio',
            subtitle: 'Nome, endere\u00e7o, contato',
          ),
          _SettingsItem(
            icon: Icons.people_outline,
            title: 'Equipe',
            subtitle: 'Profissionais e permiss\u00f5es',
          ),
          _SettingsItem(
            icon: Icons.auto_awesome_outlined,
            title: 'IA e Automa\u00e7\u00e3o',
            subtitle: 'Configurar assistente e recomenda\u00e7\u00f5es',
          ),
          _SettingsItem(
            icon: Icons.payments_outlined,
            title: 'Planos e Faturamento',
            subtitle: 'Plano Professional \u00b7 R\$ 97/m\u00eas',
          ),
          _SettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifica\u00e7\u00f5es',
            subtitle: 'WhatsApp, push, e-mail',
          ),
          _SettingsItem(
            icon: Icons.palette_outlined,
            title: 'Personaliza\u00e7\u00e3o',
            subtitle: 'Cores, logo, identidade visual',
          ),
          _SettingsItem(
            icon: Icons.integration_instructions_outlined,
            title: 'Integra\u00e7\u00f5es',
            subtitle: 'Instagram, WhatsApp, Mercado Pago',
          ),
          _SettingsItem(
            icon: Icons.security_outlined,
            title: 'Seguran\u00e7a',
            subtitle: 'Privacidade LGPD, controle de acesso',
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: SLSpacing.sm),
      padding: const EdgeInsets.all(SLSpacing.md),
      decoration: BoxDecoration(
        color: SLColors.surface,
        borderRadius: SLRadius.card,
        border: Border.all(color: SLColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SLColors.cream,
              borderRadius: SLRadius.input,
            ),
            child: Icon(icon, color: SLColors.champagne, size: 20),
          ),
          const SizedBox(width: SLSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SLTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: SLColors.carbon,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: SLColors.textDisabled,
            size: 18,
          ),
        ],
      ),
    );
  }
}
