import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(SLSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Studio Info
            _StudioInfoCard(),
            const SizedBox(height: SLSpacing.lg),

            // Business Hours
            _SettingsSection(
              title: 'Horário de Funcionamento',
              children: [
                _SettingsTile(
                  icon: Icons.access_time,
                  title: 'Segunda a Sexta',
                  subtitle: '09:00 - 19:00',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.access_time,
                  title: 'Sábado',
                  subtitle: '09:00 - 17:00',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.access_time,
                  title: 'Domingo',
                  subtitle: 'Fechado',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: SLSpacing.lg),

            // Services Management
            _SettingsSection(
              title: 'Gestão',
              children: [
                _SettingsTile(
                  icon: Icons.content_cut,
                  title: 'Serviços',
                  subtitle: '24 serviços cadastrados',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Mídia dos Serviços',
                  subtitle: 'Fotos e vídeos por serviço',
                  onTap: () => context.push('/servicos'),
                ),
                _SettingsTile(
                  icon: Icons.people,
                  title: 'Profissionais',
                  subtitle: '6 profissionais ativos',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.category,
                  title: 'Categorias',
                  subtitle: '8 categorias',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: SLSpacing.lg),

            // Integrations
            _SettingsSection(
              title: 'Integrações',
              children: [
                _SettingsTile(
                  icon: Icons.qr_code,
                  title: 'Mercado Pago',
                  subtitle: 'Conectado',
                  trailing: SLBadge(
                    variant: SLBadgeVariant.success,
                    label: 'ATIVO',
                  ),
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.g_mobiledata,
                  title: 'Google Calendar',
                  subtitle: 'Não conectado',
                  trailing: SLBadge(
                    variant: SLBadgeVariant.info,
                    label: 'INATIVO',
                  ),
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notificações Push',
                  subtitle: 'Configurado',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: SLSpacing.lg),

            // Feature Flags
            _SettingsSection(
              title: 'Funcionalidades',
              children: [
                _SettingsSwitch(
                  icon: Icons.link,
                  title: 'Agendamento Online',
                  subtitle: 'Link público ativo',
                  value: true,
                  onChanged: (v) {},
                ),
                _SettingsSwitch(
                  icon: Icons.payment,
                  title: 'Pagamento Online',
                  subtitle: 'PIX e cartão no app',
                  value: false,
                  onChanged: (v) {},
                ),
                _SettingsSwitch(
                  icon: Icons.card_giftcard,
                  title: 'Programa de Fidelidade',
                  subtitle: 'Sistema de pontos',
                  value: false,
                  onChanged: (v) {},
                ),
                _SettingsSwitch(
                  icon: Icons.chat,
                  title: 'Lembrete WhatsApp',
                  subtitle: 'Envio automático',
                  value: false,
                  onChanged: (v) {},
                ),
              ],
            ),
            const SizedBox(height: SLSpacing.lg),

            // Support
            _SettingsSection(
              title: 'Suporte',
              children: [
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Central de Ajuda',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.description,
                  title: 'Termos de Uso',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de Privacidade',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: SLSpacing.lg),

            // Version
            Center(
              child: Text(
                'Studio Letícia v2.0.0',
                style: SLTypography.caption.copyWith(
                  color: SLColors.textDisabled,
                ),
              ),
            ),
            const SizedBox(height: SLSpacing.xl),
          ],
        ),
      ),
      ),
    );
  }
}

class _StudioInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SLCard(
      variant: SLCardVariant.outlined,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: SLColors.bgSecondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'SL',
                style: SLTypography.h2.copyWith(
                  color: SLColors.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: SLSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Studio Letícia',
                  style: SLTypography.h3.copyWith(
                    color: SLColors.textPrimary,
                  ),
                ),
                const SizedBox(height: SLSpacing.xs),
                Text(
                  'Salão de Beleza Premium',
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                  ),
                ),
                const SizedBox(height: SLSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12, color: SLColors.textDisabled),
                    const SizedBox(width: SLSpacing.xs),
                    Text(
                      'São Paulo, SP',
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: SLColors.textDisabled),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: SLTypography.overline.copyWith(
            color: SLColors.accentGold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: SLSpacing.sm),
        SLCard(
          variant: SLCardVariant.outlined,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: SLRadius.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SLSpacing.md,
          vertical: SLSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: SLColors.accentGold, size: 20),
            const SizedBox(width: SLSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: SLTypography.body.copyWith(
                      color: SLColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: SLSpacing.xs),
                    Text(
                      subtitle!,
                      style: SLTypography.caption.copyWith(
                        color: SLColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null)
              Icon(Icons.chevron_right, color: SLColors.textDisabled, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SLSpacing.md,
        vertical: SLSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, color: SLColors.accentGold, size: 20),
          const SizedBox(width: SLSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SLTypography.body.copyWith(
                    color: SLColors.textPrimary,
                  ),
                ),
                const SizedBox(height: SLSpacing.xs),
                Text(
                  subtitle,
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: SLColors.accentGold,
          ),
        ],
      ),
    );
  }
}
