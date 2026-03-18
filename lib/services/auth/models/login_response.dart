import 'auth_user.dart';

class LoginResponse {
  LoginResponse({
    required this.accessToken,
    required this.user,
  });

  final String accessToken;
  final AuthUser user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final token = (json['access_token'] ?? json['accessToken'] ?? json['token']) as String?;
    final userJson = json['user'];

    if (token == null || token.isEmpty) {
      throw FormatException('access_token inválido: $json');
    }
    if (userJson is! Map<String, dynamic>) {
      throw FormatException('user inválido: $json');
    }

    return LoginResponse(
      accessToken: token,
      user: AuthUser.fromJson(userJson),
    );
  }
}

