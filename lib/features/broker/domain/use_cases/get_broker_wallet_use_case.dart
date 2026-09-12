import '../entities/broker_wallet.dart';
import '../repositories/broker_repository.dart';

class GetBrokerWalletUseCase {
  final BrokerRepository repository;
  GetBrokerWalletUseCase(this.repository);

  Future<BrokerWallet> execute(int monthOffset) =>
      repository.getBrokerWallet(monthOffset);
}
