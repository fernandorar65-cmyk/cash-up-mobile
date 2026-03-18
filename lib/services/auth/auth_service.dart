import '../../core/prefs/user_prefs.dart';
import '../api/api_client.dart';
import '../api/api_exception.dart';
import 'models/login_response.dart';

class AuthService {
  AuthService({
    required ApiClient api,
    required UserPrefs userPrefs,
  })  : _api = api,
        _userPrefs = userPrefs;

  final ApiClient _api;
  final UserPrefs _userPrefs;

  static const String _loginPath = '/auth/login';
  static const String _registerPath = '/auth/register';
  static const String _refreshPath = '/auth/refresh';

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post<Map<String, dynamic>>(
      _loginPath,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = res.data;
    if (data == null) {
      throw ApiException(message: 'Respuesta vacía del servidor', statusCode: res.statusCode);
    }

    final login = LoginResponse.fromJson(data);
    await _userPrefs.saveAccessToken(login.accessToken);
    return login;
  }

  Future<String> refreshSession() async {
    final oldToken = await _userPrefs.getAccessToken();
    if (oldToken == null || oldToken.isEmpty) {
      throw ApiException(message: 'No hay sesión activa');
    }

    final res = await _api.post<Map<String, dynamic>>(
      _refreshPath,
      data: {'access_token': oldToken},
    );

    final data = res.data;
    if (data == null) {
      throw ApiException(message: 'Respuesta vacía del servidor', statusCode: res.statusCode);
    }

    final newToken = (data['access_token'] ?? data['accessToken'] ?? data['token']) as String?;
    if (newToken == null || newToken.isEmpty) {
      throw ApiException(message: 'Respuesta de refresh inválida');
    }

    await _userPrefs.saveAccessToken(newToken);
    return newToken;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    await _api.post<Object>(
      _registerPath,
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
    );
  }

  Future<void> logout() async {
    await _userPrefs.clearSession();
  }
}

