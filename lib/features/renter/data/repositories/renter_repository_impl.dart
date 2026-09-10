import 'package:sahely/core/config/app_config.dart';
import 'package:sahely/features/renter/data/datasources/mock_renter_data_source.dart';
import 'package:sahely/features/renter/data/datasources/renter_api_data_source.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

class RenterRepositoryImpl implements RenterRepository {
  final MockRenterDataSource remoteDataSource;
  final RenterApiDataSource? apiDataSource;

  RenterRepositoryImpl({required this.remoteDataSource, this.apiDataSource});

  @override
  Future<List<Property>> getAllProperties() async {
    if (AppConfig.useRemoteApi && apiDataSource != null) {
      final list = await apiDataSource!.fetchAllProperties();
      return list.map((m) => Property.fromMap(m)).toList();
    }
    final list = await remoteDataSource.fetchAllProperties();
    return list.map((m) => Property.fromMap(m)).toList();
  }

  /// Trending rail — live when wired, otherwise the top of the main feed.
  Future<List<Property>> getTrending() async {
    if (AppConfig.useRemoteApi && apiDataSource != null) {
      final list = await apiDataSource!.fetchTrending();
      return list.map((m) => Property.fromMap(m)).toList();
    }
    return getAllProperties();
  }

  /// Best-offers rail — cheapest live listings, otherwise the main feed.
  Future<List<Property>> getOffers() async {
    if (AppConfig.useRemoteApi && apiDataSource != null) {
      final list = await apiDataSource!.fetchOffers();
      return list.map((m) => Property.fromMap(m)).toList();
    }
    final all = await getAllProperties();
    return [...all]..sort((a, b) => a.price.compareTo(b.price));
  }
}
