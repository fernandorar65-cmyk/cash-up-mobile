import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../di/datasource_providers.dart';
import '../../sign-in/screens/login_screen.dart';
import '../../widgets/auth_brand_header.dart';
import '../../widgets/auth_labeled_text_field.dart';
import '../../widgets/auth_primary_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = 'register';
  static const routePath = '/register';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa nombre, correo y contraseña')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(authServiceProvider).register(
            name: name,
            email: email,
            password: password,
            phone: phone.isEmpty ? null : phone,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada. Ahora inicia sesión.')),
      );
      context.go(LoginScreen.routePath);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  static const _bg = Color(0xFFF6F7F8);
  static const _primary = Color(0xFF0A202E);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthBrandHeader(
                      rightText: 'Registrarse',
                      onRightPressed: () => context.go(LoginScreen.routePath),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Crea tu cuenta',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: _primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Completa tus datos para continuar.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 22),
                    AuthLabeledTextField(
                      label: 'Nombre completo',
                      controller: _nameController,
                      hintText: 'John Doe',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    AuthLabeledTextField(
                      label: 'Correo electrónico',
                      controller: _emailController,
                      hintText: 'tucorreo@cashup.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    AuthLabeledTextField(
                      label: 'Número de teléfono (opcional)',
                      controller: _phoneController,
                      hintText: '+51 999 999 999',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 16),
                    AuthLabeledTextField(
                      label: 'Contraseña',
                      controller: _passwordController,
                      hintText: 'Crea una contraseña segura',
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      suffixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: AuthPrimaryButton(
                        text: 'Crear cuenta',
                        isLoading: _isSubmitting,
                        onPressed: _submit,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Text(
                            '¿Ya tienes una cuenta?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go(LoginScreen.routePath),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Inicia sesión',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: _primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
