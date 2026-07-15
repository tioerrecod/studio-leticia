import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

  Future<void> _handleEmailLogin() async {
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
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Erro ao fazer login'),
          backgroundColor: SLColors.error,
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    final authService = ref.read(authServiceProvider);
    final result = await authService.signInWithGoogle();

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.isSuccess) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Erro ao fazer login com Google'),
          backgroundColor: SLColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
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
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [SLColors.champagne, SLColors.gold],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'SL',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: SLColors.background,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SLSpacing.xl),

                  // Title
                  Text(
                    'Bem-vinda',
                    style: SLTypography.display.copyWith(
                      color: SLColors.carbon,
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SLSpacing.sm),
                  Text(
                    'Entre para continuar sua experiência',
                    style: SLTypography.body.copyWith(
                      color: SLColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SLSpacing.xxl),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'seu@email.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                        borderSide: const BorderSide(color: SLColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                        borderSide: const BorderSide(color: SLColors.champagne),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe seu email';
                      }
                      if (!value.contains('@')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SLSpacing.md),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                        borderSide: const BorderSide(color: SLColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: SLRadius.input,
                        borderSide: const BorderSide(color: SLColors.champagne),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe sua senha';
                      }
                      if (value.length < 6) {
                        return 'Senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SLSpacing.sm),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.go('/auth/forgot-password');
                      },
                      child: Text(
                        'Esqueceu a senha?',
                        style: SLTypography.caption.copyWith(
                          color: SLColors.champagne,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SLSpacing.lg),

                  // Login button
                  SizedBox(
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: SLRadius.button,
                        gradient: const LinearGradient(
                          colors: [SLColors.champagne, SLColors.gold],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleEmailLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: SLColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: SLRadius.button,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    SLColors.background,
                                  ),
                                ),
                              )
                            : Text(
                                'Entrar',
                                style: SLTypography.buttonLarge.copyWith(
                                  letterSpacing: 1,
                                  color: SLColors.background,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SLSpacing.lg),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: SLColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: SLSpacing.md),
                        child: Text(
                          'ou',
                          style: SLTypography.caption.copyWith(
                            color: SLColors.textSecondary,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: SLColors.border)),
                    ],
                  ),
                  const SizedBox(height: SLSpacing.lg),

                  // Google login button
                  SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _handleGoogleLogin,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: SLColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: SLRadius.button,
                        ),
                      ),
                      icon: const Icon(Icons.g_mobiledata, size: 24),
                      label: Text(
                        'Continuar com Google',
                        style: SLTypography.buttonMedium.copyWith(
                          color: SLColors.carbon,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SLSpacing.xxl),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem conta? ',
                        style: SLTypography.body.copyWith(
                          color: SLColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/auth/signup'),
                        child: Text(
                          'Cadastre-se',
                          style: SLTypography.body.copyWith(
                            color: SLColors.champagne,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
