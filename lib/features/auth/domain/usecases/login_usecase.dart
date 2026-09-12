import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/auth_repository.dart';
import '../entities/auth_entity.dart';
import '../../data/models/login_request_model.dart';

/// Use case for user login
/// Handles the business logic for authenticating a user
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Execute login use case
  ///
  /// Returns [Either] containing [Failure] on error or [AuthEntity] on success
  Future<Either<Failure, AuthEntity>> call(LoginRequestModel params) async {
    return await repository.login(params);
  }
}
