import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/validation/common_validators.dart';
import 'package:sahely/core/validation/validator.dart';
import '../repositories/auth_repository.dart';

/// Use case for password reset
/// Handles the business logic for initiating password reset
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  /// Execute password reset use case
  ///
  /// Returns [Either] containing [Failure] on error or void on success
  Future<Either<Failure, void>> call(String email) async {
    // Input Validation
    final emailResult = CompositeValidator<String>([
      RequiredValidator<String>(),
      EmailValidator(),
    ]).validate(email, fieldName: 'Email');

    if (!emailResult.isValid) {
      return Left(
          ValidationFailure(emailResult.firstErrorMessage ?? 'Invalid email'));
    }

    return await repository.resetPassword(email);
  }
}
