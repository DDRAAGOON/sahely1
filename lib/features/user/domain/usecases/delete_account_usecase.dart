import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/user_repository.dart';

/// Use case for deleting user account
class DeleteAccountUseCase {
  final UserRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteAccount();
  }
}
