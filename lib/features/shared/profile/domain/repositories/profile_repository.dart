import '../models/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<void> updateProfile(UserProfile profile);
  Future<String> uploadProfileImage(String path);
  Future<void> deleteProfileImage();
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> updateLanguage(String languageCode);
  Future<void> updateCurrency(String currencyCode);
  Future<void> deleteAccount();
}
