import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = ref.read(authServiceProvider);
    final result = await authService.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.isSuccess) {
      final user = result.user;
      if (user?.role == 'admin' || user?.role == 'owner') {
        context.go('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acesso restrito a administradores'),
            backgroundColor: SLColors.error,
          ),
        );
        await authService.signOut();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Erro ao fazer login'),
          backgroundColor: SLColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SLSpacing.xl),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [SLColors.accentGold, SLColors.accentGoldLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.shield_outlined, size: 32, color: SLColors.bgPrimary),
                    ),
                  ),
                  const SizedBox(height: SLSpacing.xl),
                  Text(
                    'Beauty Command',
                    style: SLTypography.display.copyWith(
                      color: SLColors.textPrimary,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SLSpacing.sm),
                  Text(
                    'Acesso administrativo',
                    style: SLTypography.body.copyWith(color: SLColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SLSpacing.xxl),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'admin@studioleticia.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: SLRadius.input),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                        borderSide: const BorderSide(color: SLColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                        borderSide: const BorderSide(color: SLColors.accentGold),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Informe seu email';
                      if (!value.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: SLSpacing.md),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: SLRadius.input),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                        borderSide: const BorderSide(color: SLColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                        borderSide: const BorderSide(color: SLColors.accentGold),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Informe sua senha';
                      if (value.length < 6) return 'Senha deve ter pelo menos 6 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: SLSpacing.xl),
                  SLButton(
                    label: 'Entrar',
                    variant: SLButtonVariant.primary,
                    isExpanded: true,
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
