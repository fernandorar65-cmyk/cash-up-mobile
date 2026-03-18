import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/sign-in/screens/login_screen.dart';
import '../../../di/datasource_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = 'profile';
  static const routePath = '/profile';

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _apellidoController = TextEditingController(text: 'Doe');
  final _dniController = TextEditingController(text: '12345678');
  final _ingresosController = TextEditingController(text: 'S/ 3,500.00');
  final _telefonoController = TextEditingController(text: '+51 999 999 999');
  final _emailController = TextEditingController(text: 'usuario@cashup.com');

  @override
  void dispose() {
    _apellidoController.dispose();
    _dniController.dispose();
    _ingresosController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  static const _bg = Color(0xFFF6F7F8);
  static const _primary = Color(0xFF0A202E);
  static const _primaryRing = Color(0xFF22C55E);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bg,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                _ProfileTopBar(
                  title: 'Editar perfil',
                  onBack: () {
                    // Dentro del tab, por ahora solo intentamos hacer pop.
                    // Si en el futuro se maneja routing para tabs, se ajusta.
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  onLogout: () async {
                    await ref.read(authServiceProvider).logout();
                    if (!mounted) return;
                    context.go(LoginScreen.routePath);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _ProfileAvatar(),
                          const SizedBox(height: 16),
                          _FieldLabel(text: 'Apellido'),
                          const SizedBox(height: 8),
                          _IconTextField(
                            controller: _apellidoController,
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 14),
                          _FieldLabel(text: 'DNI'),
                          const SizedBox(height: 8),
                          _IconTextField(
                            controller: _dniController,
                            icon: Icons.badge_outlined,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 14),
                          _FieldLabel(text: 'Ingresos mensuales'),
                          const SizedBox(height: 8),
                          _IconTextField(
                            controller: _ingresosController,
                            icon: Icons.account_balance_wallet_outlined,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 14),
                          _FieldLabel(text: 'Teléfono'),
                          const SizedBox(height: 8),
                          _IconTextField(
                            controller: _telefonoController,
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 14),
                          _FieldLabel(text: 'Correo electrónico'),
                          const SizedBox(height: 8),
                          _LockedEmailField(controller: _emailController),
                          const SizedBox(height: 6),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              'El correo no puede ser modificado. Contacta a soporte para actualizarlo.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                _SaveBar(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Guardado (demo)')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar({
    required this.title,
    required this.onBack,
    required this.onLogout,
  });

  final String title;
  final VoidCallback onBack;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      color: _ProfileScreenState._primary,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
            onPressed: onBack,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            color: Colors.white,
            onPressed: () {
              onLogout();
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 118,
          height: 118,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _ProfileScreenState._primaryRing, width: 3),
            color: const Color(0xFFF3F4F6),
          ),
          child: const CircleAvatar(
            radius: 56,
            backgroundColor: Color(0xFFE2E8F0),
            child: Icon(Icons.person, size: 60, color: Color(0xFF334155)),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }
}

class _IconTextField extends StatelessWidget {
  const _IconTextField({
    required this.controller,
    required this.icon,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        prefixIcon: Icon(icon, color: _ProfileScreenState._primaryRing),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _ProfileScreenState._border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _ProfileScreenState._border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _ProfileScreenState._primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _LockedEmailField extends StatelessWidget {
  const _LockedEmailField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF94A3B8)),
          suffixIcon: const Icon(Icons.lock_outline, color: Color(0xFF94A3B8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _ProfileScreenState._border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _ProfileScreenState._border),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _ProfileScreenState._border),
          ),
        ),
        style: const TextStyle(color: Color(0xFF94A3B8)),
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Guardar cambios'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _ProfileScreenState._primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}

