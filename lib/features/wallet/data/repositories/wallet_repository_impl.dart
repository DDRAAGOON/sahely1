import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';

/// Repository implementation for the wallet.
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WalletEntity>> getWallet() async {
    try {
      final result = await remoteDataSource.getWallet();
      return result.map((model) => model.toEntity());
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransactionEntity>>> getTransactions({
    int page = 1,
    int limit = 20,
    WalletTransactionType? type,
  }) async {
    try {
      final result = await remoteDataSource.getTransactions(
        page: page,
        limit: limit,
        type: type,
      );
      return result.map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, WithdrawalRequestEntity>> requestWithdrawal({
    required int amountPiastres,
    required String accountNumberEncrypted,
    String? bankName,
  }) async {
    try {
      final result = await remoteDataSource.requestWithdrawal(
        amount: _toEgpString(amountPiastres),
        accountNumberEncrypted: accountNumberEncrypted,
        bankName: bankName,
      );
      return result.map((model) => model.toEntity());
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, WithdrawalRequestEntity>> getWithdrawalStatus(
    String withdrawalId,
  ) async {
    try {
      final result = await remoteDataSource.getWithdrawalStatus(withdrawalId);
      return result.map((model) => model.toEntity());
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Piastres -> the decimal EGP string the API expects (`"250.00"`).
  static String _toEgpString(int piastres) =>
      (piastres / 100).toStringAsFixed(2);
}
