import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/user_repository.dart';

/// Use case for verifying email change with OTP
class VerifyEmailChangeUseCase {
  final UserRepository repository;

  VerifyEmailChangeUseCase(this.repository);

  Future<Either<Failure, void>> call(String otp) async {
    return await repository.verifyEmailChange(otp);
  }
}
