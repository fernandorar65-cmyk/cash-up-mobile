import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

import '../ui/auth/sign-in/screens/login_screen.dart';
import '../ui/auth/sign-up/screens/register_screen.dart';
import '../ui/credit-management/screens/credit_request_screen.dart';
import '../ui/home/screens/home_screen.dart';
import '../ui/splash/screens/splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: SplashScreen.routePath,
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: SplashScreen()),
      ),
      GoRoute(
        path: LoginScreen.routePath,
        name: LoginScreen.routeName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: RegisterScreen.routePath,
        name: RegisterScreen.routeName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: RegisterScreen()),
      ),
      GoRoute(
        path: HomeScreen.routePath,
        name: HomeScreen.routeName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: HomeScreen()),
      ),
      GoRoute(
        path: CreditRequestScreen.routePath,
        name: CreditRequestScreen.routeName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: CreditRequestScreen()),
      ),
    ],
  );
});

