import 'package:sahely/features/broker/data/datasources/mock_broker_data_source.dart';
import 'package:sahely/features/broker/domain/entities/broker_dashboard.dart';
import 'package:sahely/features/broker/domain/repositories/broker_repository.dart';

class BrokerRepositoryImpl implements BrokerRepository {
  final MockBrokerDataSource remoteDataSource;

  BrokerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BrokerDashboard> getBrokerDashboardData() async {
    // When real API arrives, this will call remoteDataSource.getBrokerDataFromApi()
    return await remoteDataSource.fetchBrokerDashboard();
  }
}
