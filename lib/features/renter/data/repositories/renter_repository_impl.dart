import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/features/renter/data/datasources/renter_api_data_source.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/properties/domain/entities/property_query.dart';

/// Property feeds for the renter home, straight from `/properties`.
class RenterRepositoryImpl implements RenterRepository {
  RenterRepositoryImpl({RenterApiDataSource? api})
      : _api = api ?? RenterApiDataSource(ApiClient());

  final RenterApiDataSource _api;

  @override
  Future<List<Property>> getAllProperties() async {
    final list = await _api.fetchAllProperties();
    return list.map((m) => Property.fromMap(m)).toList();
  }

  /// Trending rail.
  @override
  Future<List<Property>> getTrending() async {
    final list = await _api.fetchTrending();
    return list.map((m) => Property.fromMap(m)).toList();
  }

  /// Best-offers rail.
  @override
  Future<List<Property>> getOffers() async {
    final list = await _api.fetchOffers();
    return list.map((m) => Property.fromMap(m)).toList();
  }

  @override
  Future<Property> getProperty(String id) async =>
      Property.fromMap(await _api.fetchProperty(id));

  @override
  Future<PropertySearchResult> searchProperties(
    PropertyQuery query, {
    int page = 1,
    int limit = 50,
  }) async {
    final result = await _api.searchProperties(query, page: page, limit: limit);
    return (
      properties: result.properties.map(Property.fromMap).toList(),
      total: result.total,
    );
  }
}
