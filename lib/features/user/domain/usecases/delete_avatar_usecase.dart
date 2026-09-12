import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/user_repository.dart';

/// Use case for deleting user avatar
class DeleteAvatarUseCase {
  final UserRepository repository;

  DeleteAvatarUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteAvatar();
  }
}
