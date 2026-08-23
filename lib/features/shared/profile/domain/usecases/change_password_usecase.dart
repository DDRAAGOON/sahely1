import '../repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> execute(String currentPassword, String newPassword) {
    if (currentPassword.isEmpty) {
      throw Exception('Current password cannot be empty');
    }
    if (newPassword.length < 6) {
      throw Exception('New password must be at least 6 characters long');
    }
    if (currentPassword == newPassword) {
      throw Exception('New password cannot be the same as the current password');
    }
    return repository.changePassword(currentPassword, newPassword);
  }
}
