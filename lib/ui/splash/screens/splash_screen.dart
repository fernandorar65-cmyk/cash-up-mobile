import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/prefs/user_prefs.dart';
import '../../auth/sign-in/screens/login_screen.dart';
import '../../home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = 'splash';
  static const routePath = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _prefs = UserPrefs();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final token = await _prefs.getAccessToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      context.go(HomeScreen.routePath);
    } else {
      context.go(LoginScreen.routePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

