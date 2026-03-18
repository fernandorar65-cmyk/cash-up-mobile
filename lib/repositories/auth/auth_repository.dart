import '../../services/auth/auth_service.dart';
import '../../models/login_response.dart';

class AuthRepository {
  AuthRepository({required AuthService authService}) : _authService = authService;

  final AuthService _authService;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) {
    return _authService.login(email: email, password: password);
  }

  Future<String> refreshSession() {
    return _authService.refreshSession();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) {
    return _authService.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }

  Future<void> logout() {
    return _authService.logout();
  }
}

