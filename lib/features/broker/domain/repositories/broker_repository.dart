import 'package:sahely/features/broker/domain/entities/broker_dashboard.dart';

abstract class BrokerRepository {
  Future<BrokerDashboard> getBrokerDashboardData();
}
