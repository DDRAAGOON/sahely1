import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/upload/file_upload_api.dart';

import '../models/user_profile_dto.dart';
import 'profile_remote_datasource.dart' show ProfileRemoteDataSource;

/// Real profile data source backed by `/users/me`.
class ApiProfileRemoteDataSource implements ProfileRemoteDataSource {
  final ApiClient apiClient;
  final FileUploadApi _uploads;

  ApiProfileRemoteDataSource(this.apiClient, {FileUploadApi? uploads})
      : _uploads = uploads ?? FileUploadApi(apiClient);

  /// `GET /users/me`. The live payload is camelCase: `firstName`, `lastName`,
  /// `fullLegalName`, `aboutYou`, `instagramUrl`, `avatarUrl`, `referralCode`.
  @override
  Future<UserProfileDto> getProfile() async {
    final res = await apiClient.get(ApiEndpoints.me);
    // The payload sits inside the `{ success, data }` envelope - reading
    // res.data directly returned the envelope and blanked the whole profile.
    final u = asMap(unwrapData(res.data));

    var name = [pick(u, 'first_name'), pick(u, 'last_name')]
        .whereType<String>()
        .join(' ')
        .trim();
    if (name.isEmpty) name = '${pick(u, 'full_legal_name') ?? ''}'.trim();

    return UserProfileDto(
      name: name,
      email: '${u['email'] ?? ''}',
      phone: '${u['phone'] ?? ''}',
      bio: '${pick(u, 'about_you') ?? ''}',
      instagram: _handle(pick(u, 'instagram_url')),
      tiktok: _handle(pick(u, 'tiktok_url')),
      facebook: pick(u, 'facebook_url') as String?,
      avatarPath: pick(u, 'avatar_url') as String?,
      reviewsGiven: asNum(pick(u, 'reviews_given'))?.toInt() ?? 0,
      reviewsReceived: asNum(pick(u, 'reviews_received'))?.toInt() ?? 0,
      stars: asNum(u['stars'])?.toInt() ?? 0,
      referralCode: '${pick(u, 'referral_code') ?? ''}',
    );
  }

  @override
  Future<void> updateProfile(UserProfileDto profile) async {
    final body = <String, dynamic>{
      'phone': profile.phone,
      'about_you': profile.bio,
    };

    final name = profile.name.trim();
    if (name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      body['first_name'] = parts.first;
      if (parts.length > 1) body['last_name'] = parts.sublist(1).join(' ');
    }
    if (profile.instagram?.isNotEmpty ?? false) {
      body['instagram_url'] = _url('instagram.com', profile.instagram!);
    }
    if (profile.tiktok?.isNotEmpty ?? false) {
      body['tiktok_url'] = _url('tiktok.com', profile.tiktok!);
    }
    if (profile.facebook?.isNotEmpty ?? false) {
      body['facebook_url'] = _url('facebook.com', profile.facebook!);
    }

    await apiClient.put(ApiEndpoints.me, data: body);
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await apiClient.post(
      ApiEndpoints.passwordChange,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  @override
  Future<void> updateCurrency(String currencyCode) async {
    await apiClient.put(
      ApiEndpoints.me,
      data: {'preferred_currency': currencyCode},
    );
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    // `UpdateUserProfileDto` has no language field; the locale is persisted
    // client-side by LanguageScreen. Kept for interface parity.
  }

  @override
  Future<void> deleteProfileImage() => apiClient.delete(ApiEndpoints.avatar);

  @override
  Future<void> deleteAccount() => apiClient.delete(ApiEndpoints.me);

  /// Uploads through the documented S3 flow
  /// (`request-url` -> direct PUT -> `confirm`) and stores the object key on
  /// the profile. `POST /users/me/avatar` is deprecated on the backend.
  @override
  Future<String> uploadProfileImage(String path) async {
    final objectKey = await _uploads.uploadFile(
      filePath: path,
      uploadType: UploadTypes.avatar,
    );
    await apiClient
        .put(ApiEndpoints.me, data: {'avatar_object_key': objectKey});
    return objectKey;
  }

  /// `https://instagram.com/sahely/` -> `@sahely`
  /// (the trailing slash is real in the live data, so empty segments are
  /// dropped before taking the handle).
  static String? _handle(dynamic url) {
    if (url == null) return null;
    final segments = '$url'.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return null;
    final last = segments.last;
    return last.startsWith('@') ? last : '@$last';
  }

  /// Accepts either a bare handle or an already-complete URL.
  static String _url(String host, String handleOrUrl) {
    final value = handleOrUrl.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return 'https://$host/${value.replaceFirst('@', '')}';
  }
}
