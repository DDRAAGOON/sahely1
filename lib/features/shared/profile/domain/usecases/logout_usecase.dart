import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/security/storage/secure_storage_service.dart';
import 'package:sahely/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;
  final SecureStorageService secureStorage;

  LogoutUseCase(this.repository, this.secureStorage);

  Future<Either<Failure, void>> execute() async {
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
