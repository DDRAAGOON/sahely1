import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/payment_repository.dart';
import '../entities/payment_entity.dart';

/// Use case for getting payment status
class GetPaymentStatusUseCase {
  final PaymentRepository repository;

  GetPaymentStatusUseCase(this.repository);

  Future<Either<Failure, PaymentEntity>> call(String paymentId) async {
    return await repository.getPaymentStatus(paymentId);
  }
}
