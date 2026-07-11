import 'package:sahely/features/owner/data/datasources/mock_owner_data_source.dart';
import 'package:sahely/features/owner/domain/entities/owner_dashboard.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final MockOwnerDataSource remoteDataSource;

  OwnerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OwnerDashboard> getOwnerDashboard() async {
    // When real API arrives: call remoteDataSource.getOwnerDashboardFromApi()
    return await remoteDataSource.fetchOwnerDashboard();
  }
}
