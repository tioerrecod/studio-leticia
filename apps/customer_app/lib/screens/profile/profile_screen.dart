import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import '../../providers/supabase_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final loyaltyAsync = ref.watch(loyaltyProvider);

    return Scaffold(
      backgroundColor: SLColors.background,
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverToBoxAdapter(
            child: profileAsync.when(
              loading: () => const _LoadingHeader(),
              error: (e, _) => const _ErrorHeader(),
              data: (profile) => _ProfileHeader(profile: profile),
            ),
          ),

          // Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(SLSpacing.lg),
              child: loyaltyAsync.when(
                loading: () => const _LoadingStats(),
                error: (e, _) => const _ErrorStats(),
                data: (loyalty) => _StatsRow(loyalty: loyalty),
              ),
            ),
          ),

          // Menu Items
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SLSpacing.lg),
              child: _MenuSection(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Map<String, dynamic>? profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final name = profile?['name'] ?? 'Cliente';
    final email = profile?['email'] ?? '';
    final initials = name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();

    return Container(
      padding: const EdgeInsets.fromLTRB(
        SLSpacing.xl, SLSpacing.xxxl, SLSpacing.xl, SLSpacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [SLColors.surface, SLColors.background],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: SLColors.champagne.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: SLColors.champagne,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                initials,
                style: SLTypography.h1.copyWith(
                  color: SLColors.champagne,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(height: SLSpacing.md),
          Text(
            name,
            style: SLTypography.h2.copyWith(
              color: SLColors.ivory,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: SLSpacing.xs),
          if (email.isNotEmpty)
            Text(
              email,
              style: SLTypography.body.copyWith(
                color: SLColors.textOnDark.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    );
  }
}

class _LoadingHeader extends StatelessWidget {
  const _LoadingHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: SLColors.surface,
      child: const Center(
        child: CircularProgressIndicator(color: SLColors.champagne),
      ),
    );
  }
}

class _ErrorHeader extends StatelessWidget {
  const _ErrorHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: SLColors.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: SLColors.textSecondary),
            const SizedBox(height: SLSpacing.sm),
            Text(
              'Erro ao carregar perfil',
              style: SLTypography.body.copyWith(color: SLColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Map<String, dynamic>? loyalty;

  const _StatsRow({required this.loyalty});

  @override
  Widget build(BuildContext context) {
    final points = loyalty?['current_points'] ?? 0;
    final tier = loyalty?['tier'] ?? 'BRONZE';

    return Row(
      children: [
        _StatCard(
          icon: Icons.star,
          value: '$points',
          label: 'Pontos',
        ),
        const SizedBox(width: SLSpacing.md),
        _StatCard(
          icon: Icons.workspace_premium,
          value: '$tier',
          label: 'Tier',
        ),
        const SizedBox(width: SLSpacing.md),
        _StatCard(
          icon: Icons.calendar_today,
          value: '12',
          label: 'Visitas',
        ),
      ],
    );
  }
}

class _LoadingStats extends StatelessWidget {
  const _LoadingStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (_) => Expanded(
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: SLColors.surface,
            borderRadius: SLRadius.card,
          ),
          child: const Center(
            child: CircularProgressIndicator(color: SLColors.champagne),
          ),
        ),
      )),
    );
  }
}

class _ErrorStats extends StatelessWidget {
  const _ErrorStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (_) => Expanded(
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: SLColors.error.withValues(alpha: 0.1),
            borderRadius: SLRadius.card,
          ),
          child: const Center(
            child: Icon(Icons.error_outline, color: SLColors.error, size: 20),
          ),
        ),
      )),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(SLSpacing.md),
        decoration: BoxDecoration(
          color: SLColors.surface,
          borderRadius: SLRadius.card,
          border: Border.all(color: SLColors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: SLColors.champagne, size: 20),
            const SizedBox(height: SLSpacing.xs),
            Text(
              value,
              style: SLTypography.h3.copyWith(
                color: SLColors.carbon,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: SLTypography.overline.copyWith(
                color: SLColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MINHA CONTA',
          style: SLTypography.overline.copyWith(
            color: SLColors.champagne,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: SLSpacing.sm),
        _MenuItem(
          icon: Icons.person_outline,
          title: 'Editar Perfil',
          onTap: () {},
        ),
        _MenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notificações',
          trailing: '2 novas',
          onTap: () {},
        ),
        _MenuItem(
          icon: Icons.payment,
          title: 'Formas de Pagamento',
          onTap: () {},
        ),
        const SizedBox(height: SLSpacing.lg),

        Text(
          'PREFERÊNCIAS',
          style: SLTypography.overline.copyWith(
            color: SLColors.champagne,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: SLSpacing.sm),
        _MenuItem(
          icon: Icons.star_outline,
          title: 'Serviços Favoritos',
          onTap: () {},
        ),
        _MenuItem(
          icon: Icons.calendar_month_outlined,
          title: 'Horários Preferidos',
          onTap: () {},
        ),
        _MenuItem(
          icon: Icons.chat_outlined,
          title: 'Canal de Comunicação',
          trailing: 'WhatsApp',
          onTap: () {},
        ),
        const SizedBox(height: SLSpacing.lg),

        Text(
          'SUPORTE',
          style: SLTypography.overline.copyWith(
            color: SLColors.champagne,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: SLSpacing.sm),
        _MenuItem(
          icon: Icons.help_outline,
          title: 'Central de Ajuda',
          onTap: () {},
        ),
        _MenuItem(
          icon: Icons.chat_bubble_outline,
          title: 'Falar com Suporte',
          onTap: () {},
        ),
        _MenuItem(
          icon: Icons.star_outline,
          title: 'Avaliar o App',
          onTap: () {},
        ),
        const SizedBox(height: SLSpacing.lg),

        // Logout
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Implement logout
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: SLColors.error,
              side: const BorderSide(color: SLColors.error),
              shape: RoundedRectangleBorder(
                borderRadius: SLRadius.card,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: SLSpacing.md,
              ),
            ),
            child: Text(
              'Sair da Conta',
              style: SLTypography.body.copyWith(
                color: SLColors.error,
              ),
            ),
          ),
        ),
        const SizedBox(height: SLSpacing.xl),

        // Version
        Center(
          child: Text(
            'Studio Letícia v2.0.0',
            style: SLTypography.caption.copyWith(
              color: SLColors.textDisabled,
            ),
          ),
        ),
        const SizedBox(height: SLSpacing.xxl),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SLSpacing.md,
          vertical: SLSpacing.md,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: SLColors.border.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: SLColors.champagne, size: 20),
            const SizedBox(width: SLSpacing.md),
            Expanded(
              child: Text(
                title,
                style: SLTypography.body.copyWith(
                  color: SLColors.carbon,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: SLTypography.caption.copyWith(
                  color: SLColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            const SizedBox(width: SLSpacing.xs),
            Icon(Icons.chevron_right, color: SLColors.textDisabled, size: 18),
          ],
        ),
      ),
    );
  }
}