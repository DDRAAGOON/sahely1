import 'package:dartz/dartz.dart';

import 'package:sahely/core/auth/auth_token_keys.dart';
import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/security/storage/secure_storage_service.dart';
import 'package:sahely/data/models.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, AuthEntity>> login(LoginRequestModel request) async {
    try {
      final result = await remoteDataSource.login(request);

      return await result.fold(
        (failure) async => Left(failure),
        (authModel) async {
          // AuthApiService already wrote the pair; mirroring it here keeps the
          // repository usable with an injected storage in tests. Both paths use
          // AuthTokenKeys so the auth interceptor always finds the token.
          await secureStorage.write(
            key: AuthTokenKeys.accessToken,
            value: authModel.accessToken,
          );
          if (authModel.refreshToken.isNotEmpty) {
            await secureStorage.write(
              key: AuthTokenKeys.refreshToken,
              value: authModel.refreshToken,
            );
          }
          return Right(authModel.toEntity());
        },
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, String>> registerStep1(Role role) async {
    try {
      final result = await remoteDataSource.registerStep1(role);
      return result.map((response) => response.sessionId);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> registerStep2(
    RegisterStep2RequestModel request,
  ) =>
      _run(() => remoteDataSource.registerStep2(request));

  @override
  Future<Either<Failure, void>> verifyEmailOtp(String sessionId, String otp) =>
      _run(() => remoteDataSource.verifyEmailOtp(sessionId, otp));

  @override
  Future<Either<Failure, String>> sendPhoneOtp(String sessionId) async {
    try {
      final result = await remoteDataSource.sendPhoneOtp(sessionId);
      return result.map((response) => response.testHint);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhoneOtp(String sessionId, String otp) =>
      _run(() => remoteDataSource.verifyPhoneOtp(sessionId, otp));

  @override
  Future<Either<Failure, void>> logout(String refreshToken) async {
    try {
      final result = await remoteDataSource.logout(refreshToken);
      // Clear locally regardless: a failed revoke must still sign the user out
      // on this device rather than stranding them in a half-authenticated state.
      await _clearTokens();
      return result;
    } catch (e) {
      await _clearTokens();
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> logoutAll() async {
    try {
      final result = await remoteDataSource.logoutAll();
      await _clearTokens();
      return result;
    } catch (e) {
      await _clearTokens();
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Step 1 - `POST /auth/password/reset-request` emails a reset code.
  @override
  Future<Either<Failure, void>> resetPassword(String email) =>
      _run(() => remoteDataSource.requestPasswordReset(email));

  /// Step 2 - `POST /auth/password/reset` sets the new password.
  @override
  Future<Either<Failure, void>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) =>
      _run(
        () => remoteDataSource.confirmPasswordReset(
          email: email,
          code: code,
          newPassword: newPassword,
        ),
      );

  /// `POST /auth/password/change` - signs every other session out.
  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _run(
        () => remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );

  Future<Either<Failure, void>> _run(
    Future<Either<Failure, void>> Function() call,
  ) async {
    try {
      return await call();
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<void> _clearTokens() async {
    await secureStorage.delete(key: AuthTokenKeys.accessToken);
    await secureStorage.delete(key: AuthTokenKeys.refreshToken);
  }
}
