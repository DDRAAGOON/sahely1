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

class MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  UserProfileDto _mockProfile = const UserProfileDto(
    name: 'Mariam Hassan',
    email: 'mariam@example.com',
    phone: '+20 100 123 4567',
    bio: 'Sun-chaser & North Coast regular. Always hunting the next great beachfront escape 🏖️',
    instagram: '@mariam.h',
    reviewsGiven: 8,
    reviewsReceived: 6,
    stars: 47,
    referralCode: 'MARIAM-50',
  );

  @override
  Future<UserProfileDto> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProfile;
  }

  @override
  Future<void> updateProfile(UserProfileDto profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockProfile = profile;
  }

  @override
  Future<String> uploadProfileImage(String path) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'https://example.com/new_avatar.jpg';
  }

  @override
  Future<void> deleteProfileImage() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> updateCurrency(String currencyCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
