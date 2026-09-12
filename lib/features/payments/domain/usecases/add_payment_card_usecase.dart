import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/failures.dart';

import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

/// Saves a Paymob card token so the user can pay with it again later.
class AddPaymentCardUseCase {
  final PaymentRepository repository;

  AddPaymentCardUseCase(this.repository);

  Future<Either<Failure, PaymentCardEntity>> call({
    required String paymobCardToken,
    required String last4,
    required String brand,
    required int expiryMonth,
    required int expiryYear,
    bool isDefault = false,
  }) {
    return repository.addPaymentCard(
      paymobCardToken: paymobCardToken,
      last4: last4,
      brand: brand,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      isDefault: isDefault,
    );
  }
}
