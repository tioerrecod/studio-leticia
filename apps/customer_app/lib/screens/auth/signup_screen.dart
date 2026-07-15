import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = ref.read(authServiceProvider);
    final result = await authService.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada! Verifique seu email para confirmar.'),
          backgroundColor: SLColors.success,
        ),
      );
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Erro ao criar conta'),
          backgroundColor: SLColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: SLColors.carbon),
          onPressed: () => context.go('/auth/login'),
        ),
      ),
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
                  // Title
                  Text(
                    'Criar Conta',
                    style: SLTypography.display.copyWith(
                      color: SLColors.carbon,
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SLSpacing.sm),
                  Text(
                    'Comece sua experiência personalizada',
                    style: SLTypography.body.copyWith(
                      color: SLColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SLSpacing.xxl),

                  // Name field
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: const Icon(Icons.person_outlined),
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
                        return 'Informe seu nome';
                      }
                      if (value.split(' ').length < 2) {
                        return 'Informe nome e sobrenome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SLSpacing.md),

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
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SLSpacing.md),

                  // Phone field (optional)
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Telefone (opcional)',
                      hintText: '(11) 99999-9999',
                      prefixIcon: const Icon(Icons.phone_outlined),
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
                        return 'Informe uma senha';
                      }
                      if (value.length < 6) {
                        return 'Senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SLSpacing.md),

                  // Confirm password field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirmar senha',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
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
                        return 'Confirme sua senha';
                      }
                      if (value != _passwordController.text) {
                        return 'As senhas não conferem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SLSpacing.xl),

                  // Signup button
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
                        onPressed: _isLoading ? null : _handleSignup,
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
                                'Criar conta',
                                style: SLTypography.buttonLarge.copyWith(
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SLSpacing.xxl),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já tem conta? ',
                        style: SLTypography.body.copyWith(
                          color: SLColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/auth/login'),
                        child: Text(
                          'Entrar',
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
