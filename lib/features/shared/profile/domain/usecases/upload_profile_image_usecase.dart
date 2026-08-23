import '../repositories/profile_repository.dart';

class UploadProfileImageUseCase {
  final ProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  Future<String> execute(String path) {
    return repository.uploadProfileImage(path);
  }
}
