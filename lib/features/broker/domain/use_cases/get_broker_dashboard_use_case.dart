import '../entities/broker_dashboard.dart';
import '../repositories/broker_repository.dart';

class GetBrokerDashboardUseCase {
  final BrokerRepository repository;

  GetBrokerDashboardUseCase(this.repository);

  Future<BrokerDashboard> execute() {
    return repository.getBrokerDashboardData();
  }
}
