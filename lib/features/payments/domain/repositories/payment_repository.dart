import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../entities/payment_entity.dart';

/// Repository interface for payments
abstract class PaymentRepository {
  /// Initiate a payment
  Future<Either<Failure, PaymentInitiationResult>> initiatePayment(
    PaymentInitiationRequest request,
  );

  /// Get payment status
  Future<Either<Failure, PaymentEntity>> getPaymentStatus(String paymentId);

  /// Get user's payment cards
  Future<Either<Failure, List<PaymentCardEntity>>> getPaymentCards();

  /// Save a Paymob card token returned by Paymob's hosted checkout.
  /// The raw card number never reaches the app.
  Future<Either<Failure, PaymentCardEntity>> addPaymentCard({
    required String paymobCardToken,
    required String last4,
    required String brand,
    required int expiryMonth,
    required int expiryYear,
    bool isDefault,
  });

  /// Delete a payment card
  Future<Either<Failure, void>> deletePaymentCard(String cardId);

  /// Set a saved card as the default.
  Future<Either<Failure, void>> setDefaultCard(String cardId);

  /// Pay for a booking from the wallet balance. The server derives the amount
  /// from the booking, so no client-supplied amount is sent.
  Future<Either<Failure, PaymentEntity>> payWithWallet({
    required String bookingId,
  });
}
