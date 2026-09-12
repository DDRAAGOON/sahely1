import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/user_repository.dart';

/// Use case for updating user language preference
class UpdateLanguageUseCase {
  final UserRepository repository;

  UpdateLanguageUseCase(this.repository);

  Future<Either<Failure, void>> call(String languageCode) async {
    return await repository.updateLanguage(languageCode);
  }
}
