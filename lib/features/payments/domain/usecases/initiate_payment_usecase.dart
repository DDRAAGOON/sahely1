import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/payment_repository.dart';
import '../entities/payment_entity.dart';

/// Use case for initiating a payment
class InitiatePaymentUseCase {
  final PaymentRepository repository;

  InitiatePaymentUseCase(this.repository);

  Future<Either<Failure, PaymentInitiationResult>> call(
    PaymentInitiationRequest request,
  ) async {
    return await repository.initiatePayment(request);
  }
}
