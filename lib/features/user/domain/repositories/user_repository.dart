import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Repository interface for user operations
abstract class UserRepository {
  /// Get current user profile
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Update user profile
  Future<Either<Failure, UserEntity>> updateUser(
      UserUpdateRequestEntity request);

  /// Upload user avatar
  Future<Either<Failure, String>> uploadAvatar(String imagePath);

  /// Delete user avatar
  Future<Either<Failure, void>> deleteAvatar();

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update user language preference
  Future<Either<Failure, void>> updateLanguage(String languageCode);

  /// Update user currency preference
  Future<Either<Failure, void>> updateCurrency(String currencyCode);

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount();

  /// Step 1 of an email change. The API requires the current password before
  /// it will mail a confirmation code to [newEmail].
  Future<Either<Failure, void>> requestEmailChange({
    required String newEmail,
    required String password,
  });

  /// Step 2 of an email change: confirm with the emailed code.
  Future<Either<Failure, void>> verifyEmailChange(String code);

  /// Register this device's FCM token so push notifications arrive.
  Future<Either<Failure, void>> updateFcmToken(String token);
}
