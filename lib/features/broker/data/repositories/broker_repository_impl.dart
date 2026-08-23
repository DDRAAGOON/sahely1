import 'package:sahely/features/broker/data/datasources/mock_broker_data_source.dart';
import 'package:sahely/features/broker/domain/entities/broker_dashboard.dart';
import 'package:sahely/features/broker/domain/entities/broker_portfolio.dart';
import 'package:sahely/features/broker/domain/entities/broker_wallet.dart';
import 'package:sahely/features/broker/domain/repositories/broker_repository.dart';
import 'package:sahely/data/sample_data.dart';

import '../../../../core/utils/currency_formatter.dart';

class BrokerRepositoryImpl implements BrokerRepository {
  final MockBrokerDataSource remoteDataSource;

  BrokerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BrokerDashboard> getBrokerDashboardData() async {
    // When real API arrives, this will call remoteDataSource.getBrokerDataFromApi()
    return await remoteDataSource.fetchBrokerDashboard();
  }

  @override
  Future<BrokerPortfolio> getBrokerPortfolio() async {
    return BrokerPortfolio(
      totalCount: 55,
      activeCount: 51,
      notListedCount: 4,
      properties: Sample.allTrending,
    );
  }

  @override
  Future<BrokerWallet> getBrokerWallet(int monthOffset) async {
    return BrokerWallet(
      availableBalance: 18240,
      pendingBalance: 5400,
      tierName: 'Gold Broker',
      commissionRate: 0.04,
      avgPerBooking: '${CurrencyFormatter.defaultSymbol} 920',
      toNextTier: 45,
      commissions: [
        BrokerCommission(
          propertyName: 'Palm Chalet',
          date: DateTime.now(),
          amount: '${CurrencyFormatter.defaultSymbol} 960',
          status: 'Paid',
        ),
      ],
    );
  }
}
