import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/data/models.dart';
import '../entities/auth_entity.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';

abstract class AuthRepository {
  /// Login user with email and password
  Future<Either<Failure, AuthEntity>> login(LoginRequestModel request);

  /// Register step 1 - select role and get session ID
  Future<Either<Failure, String>> registerStep1(Role role);

  /// Register step 2 - submit account details
  Future<Either<Failure, void>> registerStep2(
      RegisterStep2RequestModel request);

  /// Register step 3 - verify email OTP
  Future<Either<Failure, void>> verifyEmailOtp(String sessionId, String otp);

  /// Register step 4a - send phone OTP
  Future<Either<Failure, String>> sendPhoneOtp(String sessionId);

  /// Register step 4b - verify phone OTP
  Future<Either<Failure, void>> verifyPhoneOtp(String sessionId, String otp);

  /// Logout user
  Future<Either<Failure, void>> logout(String refreshToken);

  /// Sign out of every device.
  Future<Either<Failure, void>> logoutAll();

  /// Step 1 of a password reset: email a reset code to [email].
  Future<Either<Failure, void>> resetPassword(String email);

  /// Step 2 of a password reset: confirm the emailed code and set a new
  /// password.
  Future<Either<Failure, void>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  });

  /// Change the password of the signed-in user. Signs other sessions out.
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
