import 'package:cash_up/ui/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../di/datasource_providers.dart';
import '../../sign-up/screens/register_screen.dart';
import '../../widgets/auth_brand_header.dart';
import '../../widgets/auth_labeled_text_field.dart';
import '../../widgets/auth_primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routeName = 'login';
  static const routePath = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa correo y contraseña')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(authServiceProvider).login(
            email: email,
            password: password,
          );

      if (!mounted) return;
      context.go(HomeScreen.routePath);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                      AuthBrandHeader(
                        rightText: 'Registrarse',
                        onRightPressed: () => context.go(RegisterScreen.routePath),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Bienvenido de vuelta',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0A202E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ingresa tus credenciales para continuar.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),

                      AuthLabeledTextField(
                        label: 'Correo electrónico',
                        controller: _emailController,
                        hintText: 'tucorreo@cashup.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    const SizedBox(height: 16),
                      AuthLabeledTextField(
                        label: 'Contraseña',
                        controller: _passwordController,
                        hintText: 'Ingresa tu contraseña',
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        suffixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Recuperar contraseña
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                        child: AuthPrimaryButton(
                          text: 'Iniciar sesión',
                          isLoading: _isSubmitting,
                          onPressed: _submit,
                        ),
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'o',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Register footer
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 0,
                        children: [
                          Text(
                            '¿Aún no tienes cuenta?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go(RegisterScreen.routePath);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0A202E),
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
