import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/wallet_repository.dart';
import '../entities/wallet_entity.dart';

/// Use case for getting wallet transactions
class GetWalletTransactionsUseCase {
  final WalletRepository repository;

  GetWalletTransactionsUseCase(this.repository);

  Future<Either<Failure, List<WalletTransactionEntity>>> call({
    int page = 1,
    int limit = 20,
    WalletTransactionType? type,
  }) async {
    return await repository.getTransactions(
      page: page,
      limit: limit,
      type: type,
    );
  }
}
