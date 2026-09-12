import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/user_repository.dart';
import '../entities/user_entity.dart';

/// Use case for updating user profile
class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
      UserUpdateRequestEntity request) async {
    return await repository.updateUser(request);
  }
}
