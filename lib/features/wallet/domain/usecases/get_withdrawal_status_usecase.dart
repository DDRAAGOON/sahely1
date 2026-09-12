import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/wallet_repository.dart';
import '../entities/wallet_entity.dart';

/// Use case for getting withdrawal status
class GetWithdrawalStatusUseCase {
  final WalletRepository repository;

  GetWithdrawalStatusUseCase(this.repository);

  Future<Either<Failure, WithdrawalRequestEntity>> call(
      String withdrawalId) async {
    return await repository.getWithdrawalStatus(withdrawalId);
  }
}
