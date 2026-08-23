import 'package:sahely/features/broker/domain/entities/broker_dashboard.dart';
import 'package:sahely/features/broker/domain/entities/broker_portfolio.dart';
import 'package:sahely/features/broker/domain/entities/broker_wallet.dart';

abstract class BrokerRepository {
  Future<BrokerDashboard> getBrokerDashboardData();
  Future<BrokerPortfolio> getBrokerPortfolio();
  Future<BrokerWallet> getBrokerWallet(int monthOffset);
}
