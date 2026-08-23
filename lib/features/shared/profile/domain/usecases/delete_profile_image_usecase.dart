import '../repositories/profile_repository.dart';

class DeleteProfileImageUseCase {
  final ProfileRepository repository;

  DeleteProfileImageUseCase(this.repository);

  Future<void> execute() {
    return repository.deleteProfileImage();
  }
}
