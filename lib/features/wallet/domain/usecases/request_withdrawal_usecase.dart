import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/failures.dart';

import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

/// Requests a payout from the wallet balance.
class RequestWithdrawalUseCase {
  final WalletRepository repository;

  RequestWithdrawalUseCase(this.repository);

  Future<Either<Failure, WithdrawalRequestEntity>> call({
    required int amountPiastres,
    required String accountNumberEncrypted,
    String? bankName,
  }) {
    return repository.requestWithdrawal(
      amountPiastres: amountPiastres,
      accountNumberEncrypted: accountNumberEncrypted,
      bankName: bankName,
    );
  }
}
