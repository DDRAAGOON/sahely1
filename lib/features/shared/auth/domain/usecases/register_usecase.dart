import 'package:dartz/dart_z.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    return await repository.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }
}
