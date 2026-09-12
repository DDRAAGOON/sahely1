import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

import '../../domain/entities/wallet_entity.dart' show WalletTransactionType;
import '../models/wallet_model.dart';

/// Remote data source for the `wallets` module.
///
/// The backend exposes two surfaces:
///  * `/wallet/*`      - the balance/transactions/withdrawals every user has,
///  * `/wallets/me/*`  - the richer owner payout dashboard.
///
/// Withdrawal account numbers must already be encrypted by the caller
/// (`account_number_encrypted`); this layer never sees a plaintext IBAN.
class WalletRemoteDataSource {
  final ApiClient _apiClient;

  WalletRemoteDataSource(this._apiClient);

  Future<Either<Failure, WalletModel>> getWallet() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.wallet);
      return Right(WalletModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, List<WalletTransactionModel>>> getTransactions({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
    WalletTransactionType? type,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.walletTransactions,
        queryParameters: pageQuery(
          page: page,
          limit: limit,
          extra: {if (type != null) 'type': type.name},
        ),
      );
      final transactions = asListOfMaps(unwrapData(response.data))
          .map(WalletTransactionModel.fromJson)
          .toList(growable: false);
      return Right(transactions);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// `GET /wallet/transactions` as raw rows.
  ///
  /// The history screen groups by month and tells a top-up from a booking
  /// payment by `reference_type`, which the typed model does not carry.
  Future<Either<Failure, List<Map<String, dynamic>>>> getTransactionRows({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.walletTransactions,
        queryParameters: pageQuery(page: page, limit: limit),
      );
      return Right(asListOfMaps(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// `POST /wallet/withdraw`.
  ///
  /// [amount] is the decimal EGP string the API expects; [accountNumberEncrypted]
  /// is the already-encrypted destination account.
  Future<Either<Failure, WithdrawalRequestModel>> requestWithdrawal({
    required String amount,
    required String accountNumberEncrypted,
    String? bankName,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.walletWithdraw,
        data: {
          'amount': amount,
          'account_number_encrypted': accountNumberEncrypted,
          if (bankName != null) 'bank_name': bankName,
        },
      );
      return Right(
        WithdrawalRequestModel.fromJson(asMap(unwrapData(response.data))),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, WithdrawalRequestModel>> getWithdrawalStatus(
    String withdrawalId,
  ) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.withdrawStatus(withdrawalId));
      return Right(
        WithdrawalRequestModel.fromJson(asMap(unwrapData(response.data))),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  // -- Owner payout dashboard (`/wallets/me/*`) -------------------------------

  Future<Either<Failure, Map<String, dynamic>>> getMyWallet() =>
      _mapCall(ApiEndpoints.myWallet);

  Future<Either<Failure, Map<String, dynamic>>> getOwnerDashboard() =>
      _mapCall(ApiEndpoints.myWalletDashboard);

  Future<Either<Failure, List<Map<String, dynamic>>>> getOwnerTransactions({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.myWalletTransactions,
        queryParameters: pageQuery(page: page, limit: limit),
      );
      return Right(asListOfMaps(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> requestOwnerWithdrawal({
    required String amount,
    required String accountNumberEncrypted,
    String? bankName,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.myWalletWithdrawals,
        data: {
          'amount': amount,
          'account_number_encrypted': accountNumberEncrypted,
          if (bankName != null) 'bank_name': bankName,
        },
      );
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> _mapCall(String path) async {
    try {
      final response = await _apiClient.get(path);
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
