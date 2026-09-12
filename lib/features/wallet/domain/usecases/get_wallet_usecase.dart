import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/wallet_repository.dart';
import '../entities/wallet_entity.dart';

/// Use case for getting user's wallet
class GetWalletUseCase {
  final WalletRepository repository;

  GetWalletUseCase(this.repository);

  Future<Either<Failure, WalletEntity>> call() async {
    return await repository.getWallet();
  }
}
