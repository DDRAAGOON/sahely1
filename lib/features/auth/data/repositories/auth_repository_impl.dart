import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/data/models.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      // Simulate network latency
      await Future.delayed(const Duration(milliseconds: 250));

      // The repository no longer decides the role based on email hints.
      // It simply returns a mock token. The interpretation of the user identity
      // belongs to the Domain layer or the Server response mapping (Data Source).
      return AuthResponse(
        token: 'mock-auth-token-${DateTime.now().millisecondsSinceEpoch}',
        role: Role.renter, // Default fallback, will be overwritten by UseCase/Logic
      );
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String role,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.delayed(const Duration(milliseconds: 250));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
