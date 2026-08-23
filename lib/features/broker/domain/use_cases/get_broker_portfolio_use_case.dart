import '../entities/broker_portfolio.dart';
import '../repositories/broker_repository.dart';

class GetBrokerPortfolioUseCase {
  final BrokerRepository repository;
  GetBrokerPortfolioUseCase(this.repository);

  Future<BrokerPortfolio> execute() => repository.getBrokerPortfolio();
}
