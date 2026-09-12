import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/failures.dart';

import '../repositories/user_repository.dart';

/// Step 1 of an email change: the API mails a confirmation code to the new
/// address once the current password is verified.
class RequestEmailChangeUseCase {
  final UserRepository repository;

  RequestEmailChangeUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String newEmail,
    required String password,
  }) {
    return repository.requestEmailChange(
      newEmail: newEmail,
      password: password,
    );
  }
}
