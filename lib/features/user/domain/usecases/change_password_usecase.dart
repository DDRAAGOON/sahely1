import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/user_repository.dart';

/// Use case for changing user password
class ChangePasswordUseCase {
  final UserRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
