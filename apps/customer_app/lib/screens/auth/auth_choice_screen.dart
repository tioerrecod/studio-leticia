import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SLSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [SLColors.accentGold, SLColors.accentGoldLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: SLColors.accentGold.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.spa_outlined, size: 36, color: SLColors.surface),
                ),
              ),
              const SizedBox(height: SLSpacing.xxl),
              Text(
                'Sua experiência\ncomeça aqui',
                textAlign: TextAlign.center,
                style: SLTypography.display.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: SLColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: SLSpacing.md),
              Text(
                'Crie sua conta para garantir\nbenefícios exclusivos e agilizar seus agendamentos.',
                textAlign: TextAlign.center,
                style: SLTypography.body.copyWith(
                  color: SLColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: SLSpacing.space12),
              SLButton(
                label: 'Criar Conta',
                variant: SLButtonVariant.primary,
                isExpanded: true,
                onPressed: () => context.go('/auth/signup'),
              ),
              const SizedBox(height: SLSpacing.md),
              SLButton(
                label: 'Continuar sem conta',
                variant: SLButtonVariant.text,
                isExpanded: true,
                onPressed: () => context.go('/services'),
              ),
              const Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Já tem conta? ',
                    style: SLTypography.body.copyWith(color: SLColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/auth/login'),
                    child: Text(
                      'Entrar',
                      style: SLTypography.body.copyWith(
                        color: SLColors.accentGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SLSpacing.space8),
            ],
          ),
        ),
      ),
    );
  }
}
