import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = ref.read(authServiceProvider);
    await authService.resetPassword(_emailController.text.trim());

    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: SLColors.textPrimary),
          onPressed: () => context.go('/auth/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SLSpacing.xl),
            child: _emailSent ? _buildSuccessState() : _buildFormState(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: SLColors.bgSecondary,
            ),
            child: const Icon(Icons.lock_reset, size: 28, color: SLColors.accentGold),
          ),
          const SizedBox(height: SLSpacing.xl),
          Text(
            'Esqueceu a senha?',
            style: SLTypography.display.copyWith(
              color: SLColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SLSpacing.sm),
          Text(
            'Informe seu email e enviaremos um link para redefinir sua senha.',
            style: SLTypography.body.copyWith(color: SLColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SLSpacing.xxl),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'seu@email.com',
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
          const SizedBox(height: SLSpacing.xl),
          SizedBox(
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: SLRadius.button,
                gradient: const LinearGradient(
                  colors: [SLColors.accentGold, SLColors.accentGoldLight],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: SLColors.bgPrimary,
                  shape: RoundedRectangleBorder(borderRadius: SLRadius.button),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(SLColors.bgPrimary),
                        ),
                      )
                    : Text(
                        'Enviar link de redefinição',
                        style: SLTypography.buttonLarge.copyWith(letterSpacing: 0.5),
                      ),
              ),
            ),
          ),
          const SizedBox(height: SLSpacing.lg),
          TextButton(
            onPressed: () => context.go('/auth/login'),
            child: Text(
              'Voltar para o login',
              style: SLTypography.body.copyWith(color: SLColors.accentGold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: SLColors.bgSecondary,
          ),
          child: const Icon(Icons.mark_email_read, size: 36, color: SLColors.accentGold),
        ),
        const SizedBox(height: SLSpacing.xl),
        Text(
          'Email enviado!',
          style: SLTypography.display.copyWith(
            color: SLColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: SLSpacing.sm),
        Text(
          'Verifique sua caixa de entrada e siga as instruções para redefinir sua senha.',
          style: SLTypography.body.copyWith(color: SLColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: SLSpacing.sm),
        Text(
          _emailController.text,
          style: SLTypography.body.copyWith(
            color: SLColors.accentGold,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: SLSpacing.xxl),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: SLRadius.button,
              gradient: const LinearGradient(
                colors: [SLColors.accentGold, SLColors.accentGoldLight],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: ElevatedButton(
              onPressed: () => context.go('/auth/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: SLColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: SLRadius.button),
              ),
              child: Text(
                'Voltar ao login',
                style: SLTypography.buttonLarge.copyWith(letterSpacing: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
