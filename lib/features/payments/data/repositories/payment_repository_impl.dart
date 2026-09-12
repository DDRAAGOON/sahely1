import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

/// Repository implementation for payments.
///
/// The data source already returns `Either<Failure, Model>`; this layer only
/// converts models to entities.
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaymentInitiationResult>> initiatePayment(
    PaymentInitiationRequest request,
  ) =>
      _mapEntity(() => remoteDataSource.initiatePayment(request));

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentStatus(String paymentId) =>
      _mapEntity(() => remoteDataSource.getPaymentStatus(paymentId));

  @override
  Future<Either<Failure, List<PaymentCardEntity>>> getPaymentCards() async {
    try {
      final result = await remoteDataSource.getPaymentCards();
      return result.map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, PaymentCardEntity>> addPaymentCard({
    required String paymobCardToken,
    required String last4,
    required String brand,
    required int expiryMonth,
    required int expiryYear,
    bool isDefault = false,
  }) =>
      _mapEntity(
        () => remoteDataSource.addPaymentCard(
          paymobCardToken: paymobCardToken,
          last4: last4,
          brand: brand,
          expiryMonth: expiryMonth,
          expiryYear: expiryYear,
          isDefault: isDefault,
        ),
      );

  @override
  Future<Either<Failure, void>> deletePaymentCard(String cardId) async {
    try {
      return await remoteDataSource.deletePaymentCard(cardId);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultCard(String cardId) async {
    try {
      return await remoteDataSource.setDefaultCard(cardId);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> payWithWallet({
    required String bookingId,
  }) =>
      _mapEntity(() => remoteDataSource.payWithWallet(bookingId: bookingId));

  Future<Either<Failure, T>> _mapEntity<T>(
    Future<Either<Failure, dynamic>> Function() call,
  ) async {
    try {
      final result = await call();
      return result.map<T>((model) => model.toEntity() as T);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
