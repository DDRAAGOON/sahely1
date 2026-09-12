import '../models/user_profile_dto.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileDto> getProfile();
  Future<void> updateProfile(UserProfileDto profile);
  Future<String> uploadProfileImage(String path);
  Future<void> deleteProfileImage();
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> updateLanguage(String languageCode);
  Future<void> updateCurrency(String currencyCode);
  Future<void> deleteAccount();
}
