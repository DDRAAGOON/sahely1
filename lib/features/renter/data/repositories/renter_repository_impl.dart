import 'package:sahely/features/renter/data/datasources/mock_renter_data_source.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';

class RenterRepositoryImpl implements RenterRepository {
  final MockRenterDataSource remoteDataSource;

  RenterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Map<String, dynamic>>> getAllProperties() async {
    return await remoteDataSource.fetchAllProperties();
  }
}
