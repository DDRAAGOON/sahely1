import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/security/storage/secure_storage_service.dart';
import '../repositories/auth_repository.dart';

/// Use case for user logout
/// Handles the business logic for logging out a user and clearing tokens
class LogoutUseCase {
  final AuthRepository repository;
  final SecureStorageService secureStorage;

  LogoutUseCase(this.repository, this.secureStorage);

  /// Execute logout use case
  ///
  /// Returns [Either] containing [Failure] on error or void on success
  Future<Either<Failure, void>> call() async {
    // Get refresh token from storage
    final refreshToken = await secureStorage.read(key: 'refresh_token');

    // Call repository logout
    final result = await repository.logout(refreshToken ?? '');

    return result.fold(
      (failure) => Left(failure),
      (_) async {
        // Additional cleanup if needed
        await secureStorage.delete(key: 'auth_token');
        await secureStorage.delete(key: 'refresh_token');
        return const Right(null);
      },
    );
  }
}
