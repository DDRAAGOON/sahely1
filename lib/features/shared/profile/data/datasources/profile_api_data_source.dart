import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'profile_remote_datasource.dart' show ProfileRemoteDataSource;
import '../models/user_profile_dto.dart';

/// Real remote data source backed by /users/me.
class ApiProfileRemoteDataSource implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ApiProfileRemoteDataSource(this.apiClient);

  @override
  Future<UserProfileDto> getProfile() async {
    final res = await apiClient.get(ApiEndpoints.me);
    final u = asMap(res.data);
    return UserProfileDto(
      name: [
        u['first_name'],
        u['last_name'],
      ].where((e) => e != null).join(' ').trim(),
      email: '${u['email'] ?? ''}',
      phone: '${u['phone'] ?? ''}',
      bio: '${u['about_you'] ?? ''}',
      instagram: u['instagram_url'] == null
          ? null
          : '@${u['instagram_url'].toString().split('/').last}',
      tiktok: u['tiktok_url'] == null
          ? null
          : '@${u['tiktok_url'].toString().split('/').last}',
      facebook: u['facebook_url'] as String?,
      avatarPath: u['avatar_url'] as String?,
      reviewsGiven: 0,
      reviewsReceived: 0,
      stars: 0,
      referralCode: '${u['referral_code'] ?? ''}',
    );
  }

  @override
  Future<void> updateProfile(UserProfileDto profile) async {
    final body = <String, dynamic>{
      'phone': profile.phone,
      'about_you': profile.bio,
    };
    if (profile.name.trim().contains(' ')) {
      final parts = profile.name.trim().split(' ');
      body['first_name'] = parts.first;
      body['last_name'] = parts.sublist(1).join(' ');
    }
    if (profile.instagram != null && profile.instagram!.isNotEmpty) {
      body['instagram_url'] =
          'https://instagram.com/${profile.instagram!.replaceFirst('@', '')}';
    }
    await apiClient.put(ApiEndpoints.updateMe, data: body);
  }

  @override
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    await apiClient.post('/auth/password/change', data: {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
  }

  @override
  Future<void> updateCurrency(String currencyCode) async {
    await apiClient.put(ApiEndpoints.updateMe,
        data: {'preferred_currency': currencyCode});
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    // Language preference is client-side only for now; interface parity only.
  }

  @override
  Future<void> deleteProfileImage() async {
    await apiClient.delete(ApiEndpoints.avatar);
  }

  @override
  Future<void> deleteAccount() => apiClient.delete(ApiEndpoints.deleteMe);

  @override
  Future<String> uploadProfileImage(String path) async {
    // Real uploads go through the S3 pre-signed flow (files module):
    // POST /files/upload/request-url → PUT bytes → POST /files/upload/confirm.
    throw UnimplementedError('Use the S3 pre-signed upload flow (files module)');
  }
}
