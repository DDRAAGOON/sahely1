import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

import '../../domain/entities/payment_entity.dart'
    show PaymentInitiationRequest, PaymentMethod;
import '../models/payment_model.dart';

/// Remote data source for the `payments` module (Paymob).
///
/// Admin routes (`/payments/admin/holds*`, `/payments/security-deposit/*`) and
/// the Paymob webhook/callback are server-side only and deliberately absent.
///
/// Every amount crossing this boundary is in **piastres** (1 EGP = 100).
class PaymentRemoteDataSource {
  final ApiClient _apiClient;

  PaymentRemoteDataSource(this._apiClient);

  // -- Paying for a booking ---------------------------------------------------

  /// Routes to the right endpoint for the chosen method:
  ///  * wallet -> `POST /payments/wallet-pay` (deducts the wallet balance),
  ///  * card   -> `POST /payments/intents` (Paymob intent, optionally reusing
  ///    a saved card),
  ///  * cash   -> `POST /payments/initiate` (plain Paymob intention).
  Future<Either<Failure, PaymentInitiationResultModel>> initiatePayment(
    PaymentInitiationRequest request, {
    bool saveCard = false,
  }) async {
    try {
      final response = switch (request.method) {
        PaymentMethod.wallet => await _apiClient.post(
            ApiEndpoints.paymentWalletPay,
            data: {'booking_id': request.bookingId},
          ),
        PaymentMethod.card => await _apiClient.post(
            ApiEndpoints.paymentIntents,
            data: {
              'booking_id': request.bookingId,
              'currency': request.currency,
              'save_card': saveCard,
              if (request.cardId != null) 'saved_card_id': request.cardId,
            },
          ),
        PaymentMethod.cash => await _apiClient.post(
            ApiEndpoints.paymentInitiate,
            data: {'booking_id': request.bookingId},
          ),
      };

      return Right(
        PaymentInitiationResultModel.fromJson(asMap(unwrapData(response.data))),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, PaymentModel>> getPayment(String paymentId) =>
      _payment(() => _apiClient.get(ApiEndpoints.payment(paymentId)));

  Future<Either<Failure, PaymentModel>> getPaymentStatus(String paymentId) =>
      _payment(() => _apiClient.get(ApiEndpoints.paymentStatus(paymentId)));

  Future<Either<Failure, PaymentModel>> payWithWallet({
    required String bookingId,
  }) =>
      _payment(
        () => _apiClient.post(
          ApiEndpoints.paymentWalletPay,
          data: {'booking_id': bookingId},
        ),
      );

  // -- Saved cards ------------------------------------------------------------

  Future<Either<Failure, List<PaymentCardModel>>> getPaymentCards() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.paymentCards);
      final cards = asListOfMaps(unwrapData(response.data))
          .map(PaymentCardModel.fromJson)
          .toList(growable: false);
      return Right(cards);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Persists a Paymob card token. The raw PAN never reaches this app - the
  /// token comes back from Paymob's own checkout.
  Future<Either<Failure, PaymentCardModel>> addPaymentCard({
    required String paymobCardToken,
    required String last4,
    required String brand,
    required int expiryMonth,
    required int expiryYear,
    bool isDefault = false,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.paymentCards,
        data: {
          'paymob_card_token': paymobCardToken,
          'last4': last4,
          'brand': brand,
          'expiry_month': expiryMonth,
          'expiry_year': expiryYear,
          'is_default': isDefault,
        },
      );
      return Right(PaymentCardModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, void>> deletePaymentCard(String cardId) => _voidCall(
        () => _apiClient.delete(ApiEndpoints.paymentCard(cardId)),
      );

  /// `PATCH /payments/cards/:cardId/default`.
  Future<Either<Failure, void>> setDefaultCard(String cardId) => _voidCall(
        () => _apiClient.patch(ApiEndpoints.paymentCardDefault(cardId)),
      );

  // -- Wallet top-up ----------------------------------------------------------

  /// Creates a funding intent plus the matching Paymob intention.
  /// [idempotencyKey] guards against a double charge when the user retries.
  Future<Either<Failure, Map<String, dynamic>>> createTopUp({
    required int amountPiastres,
    bool saveCard = false,
    String? idempotencyKey,
    String? linkedBookingId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.paymentTopUp,
        data: {
          'amount_piastres': amountPiastres,
          'save_card': saveCard,
          if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
          if (linkedBookingId != null) 'linked_booking_id': linkedBookingId,
        },
      );
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getTopUpStatus(String id) =>
      _mapCall(() => _apiClient.get(ApiEndpoints.topUpStatus(id)));

  /// FX rates used to render prices in the user's preferred currency.
  Future<Either<Failure, Map<String, dynamic>>> getCurrencyRates() =>
      _mapCall(() => _apiClient.get(ApiEndpoints.currencyRates));

  // -- Helpers ----------------------------------------------------------------

  Future<Either<Failure, PaymentModel>> _payment(
    Future<dynamic> Function() call,
  ) async {
    try {
      final response = await call();
      return Right(PaymentModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> _mapCall(
    Future<dynamic> Function() call,
  ) async {
    try {
      final response = await call();
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, void>> _voidCall(Future<void> Function() call) async {
    try {
      await call();
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
