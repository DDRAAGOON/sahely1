import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

/// Remote data source for the `user` module (`/users/*`).
///
/// The avatar upload endpoint (`POST /users/me/avatar`) is deprecated on the
/// backend - avatars go through the pre-signed S3 flow in `FileUploadApi` and
/// the resulting object key is then saved via [updateUser].
class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource(this._apiClient);

  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.me);
      return Right(UserModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Public profile of another user (host, guest, broker).
  Future<Either<Failure, Map<String, dynamic>>> getPublicUser(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.publicUser(id));
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// `PUT /users/me` - the API exposes update as PUT, not PATCH.
  Future<Either<Failure, UserModel>> updateUser(
    UserUpdateRequestEntity request,
  ) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.me,
        data: _profileBody(request),
      );
      return Right(UserModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, void>> deleteAvatar() =>
      _voidCall(() => _apiClient.delete(ApiEndpoints.avatar));

  /// `POST /auth/password/change` - signs every other session out.
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _voidCall(
        () => _apiClient.post(
          ApiEndpoints.passwordChange,
          data: {
            'current_password': currentPassword,
            'new_password': newPassword,
          },
        ),
      );

  Future<Either<Failure, void>> updateCurrency(String currencyCode) =>
      _voidCall(
        () => _apiClient.put(
          ApiEndpoints.me,
          data: {'preferred_currency': currencyCode},
        ),
      );

  Future<Either<Failure, void>> deleteAccount() =>
      _voidCall(() => _apiClient.delete(ApiEndpoints.me));

  /// Step 1 of an email change - the backend mails a code to the new address.
  Future<Either<Failure, void>> requestEmailChange({
    required String newEmail,
    required String password,
  }) =>
      _voidCall(
        () => _apiClient.put(
          ApiEndpoints.emailChangeRequest,
          data: {'new_email': newEmail, 'password': password},
        ),
      );

  /// Step 2 of an email change - confirm with the emailed code.
  Future<Either<Failure, void>> confirmEmailChange(String code) => _voidCall(
        () => _apiClient.put(
          ApiEndpoints.emailChangeConfirm,
          data: {'code': code},
        ),
      );

  /// Registers the FCM token so push notifications reach this device.
  Future<Either<Failure, void>> updateFcmToken(String token) => _voidCall(
        () => _apiClient.put(
          ApiEndpoints.fcmToken,
          data: {'fcm_token': token},
        ),
      );

  /// Links a broker to this account through their invitation code.
  Future<Either<Failure, void>> claimBrokerInvitation(String code) => _voidCall(
        () => _apiClient.post(
          ApiEndpoints.brokerInvitation,
          data: {'code': code},
        ),
      );

  Future<Either<Failure, Map<String, dynamic>>> getReferral() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.myReferral);
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Maps the domain request onto the backend's `UpdateUserProfileDto`.
  /// `fullName` is split because the API stores first/last separately.
  Map<String, dynamic> _profileBody(UserUpdateRequestEntity request) {
    final body = <String, dynamic>{};

    final fullName = request.fullName?.trim();
    if (fullName != null && fullName.isNotEmpty) {
      final parts = fullName.split(RegExp(r'\s+'));
      body['first_name'] = parts.first;
      if (parts.length > 1) body['last_name'] = parts.sublist(1).join(' ');
    }
    if (request.phone != null) body['phone'] = request.phone;
    if (request.bio != null) body['about_you'] = request.bio;
    if (request.instagram != null) {
      body['instagram_url'] = _socialUrl('instagram.com', request.instagram!);
    }
    if (request.tiktok != null) {
      body['tiktok_url'] = _socialUrl('tiktok.com', request.tiktok!);
    }
    if (request.facebook != null) {
      body['facebook_url'] = _socialUrl('facebook.com', request.facebook!);
    }
    if (request.preferredCurrency != null) {
      body['preferred_currency'] = request.preferredCurrency;
    }
    // `preferred_language` is not part of UpdateUserProfileDto; the app keeps
    // the locale client-side (see LanguageScreen).
    return body;
  }

  /// Accepts either a bare handle (`@sahely`) or a full profile URL.
  static String _socialUrl(String host, String handleOrUrl) {
    final value = handleOrUrl.trim();
    if (value.isEmpty) return '';
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return 'https://$host/${value.replaceFirst('@', '')}';
  }

  Future<Either<Failure, void>> _voidCall(Future<void> Function() call) async {
    try {
      await call();
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
