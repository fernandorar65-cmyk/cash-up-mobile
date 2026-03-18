class AuthUser {
  AuthUser({
    required this.id,
    required this.email,
    required this.name,
  });

  final String id;
  final String email;
  final String name;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final email = json['email'];
    final name = json['name'];

    if (email is! String || name is! String) {
      throw FormatException('User inválido: $json');
    }

    return AuthUser(
      id: id?.toString() ?? '',
      email: email,
      name: name,
    );
  }
}

