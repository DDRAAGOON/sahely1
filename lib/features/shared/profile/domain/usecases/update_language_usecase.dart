import '../repositories/profile_repository.dart';

class UpdateLanguageUseCase {
  final ProfileRepository repository;

  UpdateLanguageUseCase(this.repository);

  Future<void> execute(String languageCode) {
    return repository.updateLanguage(languageCode);
  }
}
