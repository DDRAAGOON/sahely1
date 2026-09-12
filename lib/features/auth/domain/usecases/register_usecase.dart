import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/validation/common_validators.dart';
import 'package:sahely/core/validation/validator.dart';
import 'package:sahely/data/models.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/register_request_model.dart';

/// Use case for registration step 1 - role selection
class RegisterStep1UseCase {
  final AuthRepository repository;

  RegisterStep1UseCase(this.repository);

  Future<Either<Failure, String>> call(Role role) async {
    return await repository.registerStep1(role);
  }
}

/// Use case for registration step 2 - account details
class RegisterStep2UseCase {
  final AuthRepository repository;

  RegisterStep2UseCase(this.repository);

  Future<Either<Failure, void>> call(RegisterStep2RequestModel request) async {
    // Input Validation
    final nameResult = RequiredValidator<String>()
        .validate(request.fullName, fieldName: 'Name');
    if (!nameResult.isValid) {
      return Left(ValidationFailure(
          nameResult.firstErrorMessage ?? 'Name is required'));
    }

    final emailResult = CompositeValidator<String>([
      RequiredValidator<String>(),
      EmailValidator(),
    ]).validate(request.email, fieldName: 'Email');
    if (!emailResult.isValid) {
      return Left(
          ValidationFailure(emailResult.firstErrorMessage ?? 'Invalid email'));
    }

    final phoneResult =
        PhoneValidator().validate(request.phone, fieldName: 'Phone');
    if (!phoneResult.isValid) {
      return Left(ValidationFailure(
          phoneResult.firstErrorMessage ?? 'Invalid phone number'));
    }

    final passwordResult = PasswordValidator(minLength: 8)
        .validate(request.password, fieldName: 'Password');
    if (!passwordResult.isValid) {
      return Left(ValidationFailure(
          passwordResult.firstErrorMessage ?? 'Invalid password'));
    }

    if (request.password != request.confirmPassword) {
      return const Left(ValidationFailure('Passwords do not match'));
    }

    return await repository.registerStep2(request);
  }
}

/// Use case for email OTP verification
class VerifyEmailOtpUseCase {
  final AuthRepository repository;

  VerifyEmailOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(String sessionId, String otp) async {
    return await repository.verifyEmailOtp(sessionId, otp);
  }
}

/// Use case for sending phone OTP
class SendPhoneOtpUseCase {
  final AuthRepository repository;

  SendPhoneOtpUseCase(this.repository);

  Future<Either<Failure, String>> call(String sessionId) async {
    return await repository.sendPhoneOtp(sessionId);
  }
}

/// Use case for phone OTP verification
class VerifyPhoneOtpUseCase {
  final AuthRepository repository;

  VerifyPhoneOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(String sessionId, String otp) async {
    return await repository.verifyPhoneOtp(sessionId, otp);
  }
}
