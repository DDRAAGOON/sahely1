import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/payment_repository.dart';

/// Use case for setting default payment card
class SetDefaultCardUseCase {
  final PaymentRepository repository;

  SetDefaultCardUseCase(this.repository);

  Future<Either<Failure, void>> call(String cardId) async {
    return await repository.setDefaultCard(cardId);
  }
}
