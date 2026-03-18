import '../../core/prefs/user_prefs.dart';
import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../../models/login_response.dart';

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
    final login = data == null
        ? throw ApiException(
            message: 'Respuesta vacía del servidor',
            statusCode: res.statusCode,
          )
        : LoginResponse.fromJson(data);
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
    final newToken = data == null
        ? throw ApiException(
            message: 'Respuesta vacía del servidor',
            statusCode: res.statusCode,
          )
        : (data['access_token'] ??
                data['accessToken'] ??
                data['token']) as String?;
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
    final payload = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
    if (phone != null) {
      payload['phone'] = phone;
    }
    await _api.post<Object>(
      _registerPath,
      data: {
        ...payload,
      },
    );
  }

  Future<void> logout() async {
    await _userPrefs.clearSession();
  }
}

