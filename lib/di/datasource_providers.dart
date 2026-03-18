import 'package:riverpod/riverpod.dart';

import '../core/prefs/user_prefs.dart';
import '../di/app_providers.dart';
import '../services/api/api_client.dart';
import '../services/auth/auth_service.dart';
import '../services/credit_requests/credit_requests_service.dart';
import '../services/loans/loans_service.dart';
import '../ui/auth/sign-in/screens/login_screen.dart';

final userPrefsProvider = Provider<UserPrefs>((ref) {
  return UserPrefs();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final userPrefs = ref.watch(userPrefsProvider);
  final router = ref.watch(routerProvider);

  return ApiClient(
    userPrefs: userPrefs,
    onUnauthorized: () async {
      router.go(LoginScreen.routePath);
    },
  );
});

final authServiceProvider = Provider<AuthService>((ref) {
  final api = ref.watch(apiClientProvider);
  final userPrefs = ref.watch(userPrefsProvider);
  return AuthService(api: api, userPrefs: userPrefs);
});

final creditRequestsServiceProvider = Provider<CreditRequestsService>((ref) {
  final api = ref.watch(apiClientProvider);
  return CreditRequestsService(api: api);
});

final loansServiceProvider = Provider<LoansService>((ref) {
  final api = ref.watch(apiClientProvider);
  return LoansService(api: api);
});

