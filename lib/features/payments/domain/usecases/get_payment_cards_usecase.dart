import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/payment_repository.dart';
import '../entities/payment_entity.dart';

/// Use case for getting user's payment cards
class GetPaymentCardsUseCase {
  final PaymentRepository repository;

  GetPaymentCardsUseCase(this.repository);

  Future<Either<Failure, List<PaymentCardEntity>>> call() async {
    return await repository.getPaymentCards();
  }
}
