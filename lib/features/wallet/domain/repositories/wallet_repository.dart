import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../entities/wallet_entity.dart';

/// Repository interface for wallet
abstract class WalletRepository {
  /// Get user's wallet
  Future<Either<Failure, WalletEntity>> getWallet();

  /// Get wallet transactions
  Future<Either<Failure, List<WalletTransactionEntity>>> getTransactions({
    int page = 1,
    int limit = 20,
    WalletTransactionType? type,
  });

  /// Request a payout.
  ///
  /// [amountPiastres] is converted to the decimal EGP string the API expects.
  /// [accountNumberEncrypted] must already be encrypted by the caller - the
  /// API never accepts a plaintext account number.
  Future<Either<Failure, WithdrawalRequestEntity>> requestWithdrawal({
    required int amountPiastres,
    required String accountNumberEncrypted,
    String? bankName,
  });

  /// Get withdrawal status
  Future<Either<Failure, WithdrawalRequestEntity>> getWithdrawalStatus(
    String withdrawalId,
  );
}
