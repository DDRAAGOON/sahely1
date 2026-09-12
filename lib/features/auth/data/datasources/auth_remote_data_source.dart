import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/auth/data/models/auth_response_model.dart';
import 'package:sahely/features/auth/data/models/login_request_model.dart';
import 'package:sahely/features/auth/data/models/register_request_model.dart';

import '../auth_api.dart';

/// Remote data source for authentication.
///
/// Thin adapter over [AuthApiService]: it turns thrown [AuthApiException]s into
/// typed [Failure]s so the repository layer stays exception-free.
class AuthRemoteDataSource {
  final AuthApiService _apiService;

  AuthRemoteDataSource(this._apiService);

  Future<Either<Failure, AuthResponseModel>> login(
    LoginRequestModel request,
  ) =>
      _guard(() async {
        // loginDetailed returns the full session payload (tokens + user), so
        // the refresh token and the user's real id/name are not lost.
        final session = await _apiService.loginDetailed(
          request.email,
          request.password,
        );
        return AuthResponseModel.fromJson(session);
      });

  Future<Either<Failure, RegisterStep1ResponseModel>> registerStep1(
    Role role,
  ) =>
      _guard(() async {
        final sessionId = await _apiService.registerStep1(role);
        return RegisterStep1ResponseModel(sessionId: sessionId);
      });

  Future<Either<Failure, void>> registerStep2(
    RegisterStep2RequestModel request,
  ) =>
      _guard(
        () => _apiService.registerStep2(
          sessionId: request.sessionId,
          fullName: request.fullName,
          email: request.email,
          phone: request.phone,
          dateOfBirth: request.dateOfBirth,
          password: request.password,
          confirmPassword: request.confirmPassword,
          termsAccepted: request.termsAccepted,
          referralCode: request.referralCode,
        ),
      );

  Future<Either<Failure, void>> verifyEmailOtp(String sessionId, String otp) =>
      _guard(() => _apiService.verifyEmailOtp(sessionId, otp));

  Future<Either<Failure, RegisterStep4ResponseModel>> sendPhoneOtp(
    String sessionId,
  ) =>
      _guard(() async {
        final testHint = await _apiService.sendPhoneOtp(sessionId);
        return RegisterStep4ResponseModel(testHint: testHint);
      });

  Future<Either<Failure, void>> verifyPhoneOtp(String sessionId, String otp) =>
      _guard(() => _apiService.verifyPhoneOtp(sessionId, otp));

  Future<Either<Failure, void>> logout(String refreshToken) =>
      _guard(() => _apiService.logout(refreshToken));

  Future<Either<Failure, void>> logoutAll() => _guard(_apiService.logoutAll);

  /// Step 1 of a password reset - emails a code to the address.
  Future<Either<Failure, void>> requestPasswordReset(String email) =>
      _guard(() => _apiService.requestPasswordReset(email));

  /// Step 2 of a password reset - confirms the emailed code.
  Future<Either<Failure, void>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) =>
      _guard(
        () => _apiService.resetPassword(
          email: email,
          code: code,
          newPassword: newPassword,
        ),
      );

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _guard(
        () => _apiService.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on AuthApiException catch (e) {
      return Left(_toFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _toFailure(AuthApiException e) {
    return switch (e.code) {
      'ERR_NETWORK' => NetworkFailure(e.message, code: e.code),
      'ERR_TIMEOUT' => TimeoutFailure(e.message, code: e.code),
      'ERR_AUTH_INVALID_CREDENTIALS' ||
      'ERR_AUTH_TOKEN_EXPIRED' =>
        UnauthorizedFailure(e.message, code: e.code, field: e.field),
      'ERR_VALIDATION_FIELD' => ValidationFailure(
          e.message,
          errors: e.data,
          code: e.code,
          field: e.field,
        ),
      _
          when e.statusCode == 400 ||
              e.statusCode == 409 ||
              e.statusCode == 422 =>
        ValidationFailure(
          e.message,
          errors: e.data,
          code: e.code,
          field: e.field,
        ),
      _ => ServerFailure(
          e.message,
          statusCode: e.statusCode,
          code: e.code,
          field: e.field,
        ),
    };
  }
}
