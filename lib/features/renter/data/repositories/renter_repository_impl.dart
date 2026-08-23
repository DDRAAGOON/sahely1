import 'package:sahely/features/renter/data/datasources/mock_renter_data_source.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

class RenterRepositoryImpl implements RenterRepository {
  final MockRenterDataSource remoteDataSource;

  RenterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Property>> getAllProperties() async {
    final list = await remoteDataSource.fetchAllProperties();
    return list.map((m) => Property.fromMap(m)).toList();
  }
}
