import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';

/// Real remote data source powering the renter home / browse feeds.
class RenterApiDataSource {
  final ApiClient apiClient;

  RenterApiDataSource(this.apiClient);

  Future<List<Map<String, dynamic>>> fetchAllProperties() async {
    final res = await apiClient.get(
      ApiEndpoints.properties,
      queryParameters: {'limit': 50},
    );
    final data = unwrapData(res.data);
    final list = (data['data'] ?? data['properties'] ?? []) as List;
    return list
        .whereType<Map>()
        .map((e) => _mapProperty(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchTrending({int limit = 10}) async {
    final res = await apiClient
        .get(ApiEndpoints.trending, queryParameters: {'limit': limit});
    final data = unwrapData(res.data);
    final list = (data['properties'] ?? []) as List;
    return list
        .whereType<Map>()
        .map((e) => _mapProperty(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchOffers({int limit = 10}) async {
    final res = await apiClient
        .get(ApiEndpoints.offers, queryParameters: {'limit': limit});
    final data = unwrapData(res.data);
    final list = (data['properties'] ?? []) as List;
    return list
        .whereType<Map>()
        .map((e) => _mapProperty(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Backend property JSON → the map shape [Property.fromMap] expects.
  static Map<String, dynamic> _mapProperty(Map<String, dynamic> p) {
    // nightlyRate is EGP ("4000.00"); basePricePerNight is piastres.
    final priceEgp = double.tryParse('${p['nightlyRate'] ?? ''}') ??
        ((p['basePricePerNight'] as num? ?? 0) / 100);
    final images = (p['images'] as List?) ?? const [];
    String image = '';
    if (images.isNotEmpty) {
      final first = Map<String, dynamic>.from(images.first as Map);
      image = '${first['url'] ?? first['objectKey'] ?? ''}';
    }
    return {
      'id': p['id'],
      'name': p['title'],
      'location': p['governorate'] ?? p['city'] ?? p['compoundId'] ?? 'North Coast',
      'rating': double.tryParse('${p['averageRating'] ?? 0}') ?? 0.0,
      'reviewCount': p['totalReviews'] ?? 0,
      'price': priceEgp.round(),
      'type': _titleCase('${p['propertyType'] ?? 'villa'}'),
      'beds': p['bedrooms'] ?? 2,
      'guests': p['maxGuests'] ?? 6,
      'imageUrl': image,
      'features': [
        if ((p['beachDistanceMeters'] as num?) != null) 'Beachfront',
        if ('${p['propertyType']}' == 'villa') 'Pool',
      ],
      'partyAllowed': false,
      'petsAllowed': false,
      'mixedGroupsOK': true,
    };
  }

  static String _titleCase(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}';
}
