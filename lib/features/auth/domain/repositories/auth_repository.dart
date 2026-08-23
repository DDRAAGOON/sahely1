import 'package:sahely/data/models.dart';

abstract class AuthRepository {
  Future<AuthResponse> signIn(String email, String password);
  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String role,
  });
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class AuthResponse {
  final String token;
  final Role role;

  AuthResponse({required this.token, required this.role});
}
