import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/user_repository.dart';
import '../entities/user_entity.dart';

/// Use case for getting current user profile
class GetCurrentUserUseCase {
  final UserRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}
