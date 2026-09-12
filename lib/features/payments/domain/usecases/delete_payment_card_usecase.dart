import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/payment_repository.dart';

/// Use case for deleting a payment card
class DeletePaymentCardUseCase {
  final PaymentRepository repository;

  DeletePaymentCardUseCase(this.repository);

  Future<Either<Failure, void>> call(String cardId) async {
    return await repository.deletePaymentCard(cardId);
  }
}
