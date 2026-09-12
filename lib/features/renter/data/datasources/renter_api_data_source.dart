import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/features/shared/properties/domain/entities/property_query.dart';

/// Real remote data source powering the renter home / browse feeds.
class RenterApiDataSource {
  final ApiClient apiClient;

  RenterApiDataSource(this.apiClient);

  /// `GET /properties/` - the browse feed.
  Future<List<Map<String, dynamic>>> fetchAllProperties({
    int limit = 50,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.properties,
      queryParameters: pageQuery(limit: limit),
    );
    return _parse(res.data);
  }

  /// `GET /properties/featured` - the curated home rail.
  ///
  /// The featured payload comes without the `images` array, so a listing
  /// would show an empty card; the cover is filled in from the listing
  /// itself, which is the only place the photos live.
  Future<List<Map<String, dynamic>>> fetchTrending({int limit = 10}) async {
    final res = await apiClient.get(
      ApiEndpoints.featuredProperties,
      queryParameters: {'limit': limit},
    );
    return _withCovers(_parse(res.data));
  }

  Future<List<Map<String, dynamic>>> _withCovers(
    List<Map<String, dynamic>> rows,
  ) async {
    return Future.wait(rows.map((row) async {
      if ('${row['imageUrl'] ?? ''}'.isNotEmpty) return row;
      final id = '${row['id'] ?? ''}';
      if (id.isEmpty) return row;
      try {
        final full = await fetchProperty(id);
        return {
          ...row,
          'imageUrl': full['imageUrl'] ?? '',
          'images': full['images'] ?? const [],
        };
      } catch (_) {
        return row;
      }
    }));
  }

  /// `GET /properties/:id` - one listing, e.g. a saved wishlist item.
  Future<Map<String, dynamic>> fetchProperty(String id) async {
    final res = await apiClient.get(ApiEndpoints.property(id));
    return _mapProperty(asMap(unwrapData(res.data)));
  }

  /// `GET /search/properties` — the one endpoint that filters listings.
  ///
  /// The backend validates the query strictly: an unknown parameter fails the
  /// whole request, which is why only the criteria it accepts are sent.
  Future<({List<Map<String, dynamic>> properties, int total})> searchProperties(
    PropertyQuery query, {
    int page = 1,
    int limit = 50,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.searchProperties,
      queryParameters: pageQuery(
        page: page,
        limit: limit,
        extra: _searchQuery(query),
      ),
    );
    final payload = unwrapData(res.data);
    final properties = asListOfMaps(payload).map(_mapProperty).toList();
    return (
      properties: properties,
      total: extractPagination(payload)?.total ?? properties.length,
    );
  }

  static Map<String, dynamic> _searchQuery(PropertyQuery q) => {
        if (q.keyword.isNotEmpty) 'keyword': q.keyword,
        if (q.type != null) 'type': q.type,
        if (q.minBedrooms != null) 'bedrooms': q.minBedrooms,
        if (q.guests != null) 'guests': q.guests,
        if (q.minPriceEgp != null) 'minPrice': q.minPriceEgp,
        if (q.maxPriceEgp != null) 'maxPrice': q.maxPriceEgp,
        if (q.amenities.isNotEmpty) 'amenities': q.amenities.join(','),
        if (q.checkIn != null) 'checkIn': _day(q.checkIn!),
        if (q.checkOut != null) 'checkOut': _day(q.checkOut!),
        if (q.smartLock) 'isSmartLocked': true,
        if (q.nearBeach) 'maxBeachDistance': _beachWalkMetres,
        if (q.governorate != null) 'governorate': q.governorate,
        if (q.minRating != null) 'minRating': q.minRating,
      };

  /// "By the beach" is everything within a kilometre of it.
  static const _beachWalkMetres = 1000;

  static String _day(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// The mobile API has no dedicated offers feed, so the home "offers" rail is
  /// served by the same curated `/properties/featured` list.
  Future<List<Map<String, dynamic>>> fetchOffers({int limit = 10}) =>
      fetchTrending(limit: limit);

  List<Map<String, dynamic>> _parse(dynamic body) =>
      asListOfMaps(unwrapData(body)).map(_mapProperty).toList();

  /// Backend property JSON -> the map shape `Property.fromMap` expects.
  ///
  /// The API documents its JSON as snake_case, but several property fields are
  /// serialised camelCase by the ORM. Every lookup accepts both spellings so a
  /// serialisation change on the backend cannot silently blank out the feed.
  static Map<String, dynamic> _mapProperty(Map<String, dynamic> p) {
    // basePricePerNight is in PIASTRES (375000); nightlyRate is the same
    // amount as an EGP string ("3750.00"). Reading the piastre field as EGP
    // showed prices 100x too high, so prefer nightlyRate and divide otherwise.
    final priceEgp =
        asNum(_pick(p, 'nightly_rate', 'nightlyRate'))?.toDouble() ??
            ((asNum(_pick(p, 'base_price_per_night', 'basePricePerNight'))
                        ?.toDouble() ??
                    0) /
                100);
    final propertyType =
        '${_pick(p, 'property_type', 'propertyType') ?? 'villa'}';
    // Photos: the cover first, then the owner's own order. Feed responses
    // carry no `images` array at all, only the detail endpoint does.
    final images = asListOfMaps(p['images'])
      ..sort((a, b) {
        final coverA = _pick(a, 'is_cover', 'isCover') == true ? 0 : 1;
        final coverB = _pick(b, 'is_cover', 'isCover') == true ? 0 : 1;
        if (coverA != coverB) return coverA - coverB;
        return (asNum(_pick(a, 'sort_order', 'sortOrder')) ?? 0)
            .compareTo(asNum(_pick(b, 'sort_order', 'sortOrder')) ?? 0);
      });
    final imageUrls = [
      for (final image in images)
        '${image['url'] ?? _pick(image, 'object_key', 'objectKey') ?? ''}',
    ]..removeWhere((url) => url.isEmpty);
    final cover = '${_pick(p, 'cover_image_url', 'coverImageUrl') ?? ''}';
    final imageUrl = imageUrls.isNotEmpty ? imageUrls.first : cover;
    final beachDistance =
        asNum(_pick(p, 'beach_distance_meters', 'beachDistanceMeters'));

    return {
      'id': '${p['id'] ?? ''}',
      'name': '${p['title'] ?? ''}',
      'location': '${p['governorate'] ?? p['city'] ?? 'North Coast'}',
      'rating':
          asNum(_pick(p, 'average_rating', 'averageRating'))?.toDouble() ?? 0.0,
      'reviewCount':
          asNum(_pick(p, 'total_reviews', 'totalReviews'))?.toInt() ?? 0,
      'price': priceEgp.round(),
      'type': _titleCase(propertyType),
      'beds': asNum(p['bedrooms'])?.toInt() ?? 0,
      'guests': asNum(_pick(p, 'max_guests', 'maxGuests'))?.toInt() ?? 0,
      'imageUrl': imageUrl,
      'images': imageUrls.isEmpty && cover.isNotEmpty ? [cover] : imageUrls,
      // The only feature the listing JSON supports: a pool, a view or any
      // other amenity is not part of it, so nothing else is claimed here.
      'features': [
        if (beachDistance != null && beachDistance <= _beachWalkMetres)
          'Beachfront',
      ],
      'partyAllowed': false,
      'petsAllowed': false,
      'mixedGroupsOK': true,
      // Detail fields: present on `/properties/:id`, absent from the feeds.
      'description': '${p['description'] ?? ''}',
      'bathrooms': asNum(p['bathrooms'])?.toInt() ?? 0,
      'areaSqm': asNum(_pick(p, 'area_sqm', 'areaSqm'))?.toDouble(),
      'floor': asNum(_pick(p, 'floor_number', 'floorNumber'))?.toInt(),
      'unit': '${_pick(p, 'unit_number', 'unitNumber') ?? ''}',
      'checkInTime': '${_pick(p, 'check_in_time', 'checkInTime') ?? ''}',
      'checkOutTime': '${_pick(p, 'check_out_time', 'checkOutTime') ?? ''}',
      'cancellationPolicy':
          '${_pick(p, 'cancellation_policy', 'cancellationPolicy') ?? ''}',
      'latitude': asNum(p['latitude'])?.toDouble(),
      'longitude': asNum(p['longitude'])?.toDouble(),
      'smartLock': _pick(p, 'is_smart_locked', 'isSmartLocked') == true,
    };
  }

  static dynamic _pick(Map<String, dynamic> json, String snake, String camel) =>
      json[snake] ?? json[camel];

  static String _titleCase(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}';
}
