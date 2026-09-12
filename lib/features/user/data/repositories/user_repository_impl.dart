import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/upload/file_upload_api.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

/// Repository implementation for the user module (`/users/*`).
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final FileUploadApi uploads;

  UserRepositoryImpl({required this.remoteDataSource, required this.uploads});

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final result = await remoteDataSource.getCurrentUser();
      return result.map((model) => model.toEntity());
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(
    UserUpdateRequestEntity request,
  ) async {
    try {
      final result = await remoteDataSource.updateUser(request);
      return result.map((model) => model.toEntity());
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// `POST /users/me/avatar` is deprecated, so the avatar goes through the
  /// pre-signed S3 flow and the resulting object key is saved on the profile.
  @override
  Future<Either<Failure, String>> uploadAvatar(String imagePath) async {
    try {
      final objectKey = await uploads.uploadFile(
        filePath: imagePath,
        uploadType: UploadTypes.avatar,
      );
      return Right(objectKey);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAvatar() =>
      _run(remoteDataSource.deleteAvatar);

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

  /// The API has no language field on the profile; the locale is stored on the
  /// device, so this succeeds without a round trip.
  @override
  Future<Either<Failure, void>> updateLanguage(String languageCode) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> updateCurrency(String currencyCode) =>
      _run(() => remoteDataSource.updateCurrency(currencyCode));

  @override
  Future<Either<Failure, void>> deleteAccount() =>
      _run(remoteDataSource.deleteAccount);

  @override
  Future<Either<Failure, void>> requestEmailChange({
    required String newEmail,
    required String password,
  }) =>
      _run(
        () => remoteDataSource.requestEmailChange(
          newEmail: newEmail,
          password: password,
        ),
      );

  @override
  Future<Either<Failure, void>> verifyEmailChange(String code) =>
      _run(() => remoteDataSource.confirmEmailChange(code));

  @override
  Future<Either<Failure, void>> updateFcmToken(String token) =>
      _run(() => remoteDataSource.updateFcmToken(token));

  Future<Either<Failure, void>> _run(
    Future<Either<Failure, void>> Function() call,
  ) async {
    try {
      return await call();
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
