import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/user_repository.dart';

/// Use case for updating user currency preference
class UpdateCurrencyUseCase {
  final UserRepository repository;

  UpdateCurrencyUseCase(this.repository);

  Future<Either<Failure, void>> call(String currencyCode) async {
    return await repository.updateCurrency(currencyCode);
  }
}
