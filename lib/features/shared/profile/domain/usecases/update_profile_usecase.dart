import '../models/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> execute(UserProfile profile) {
    if (profile.name.trim().isEmpty) {
      throw Exception('Name cannot be empty');
    }
    if (profile.email.trim().isEmpty || !profile.email.contains('@')) {
      throw Exception('Invalid email address');
    }
    return repository.updateProfile(profile);
  }
}
