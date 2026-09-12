import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

import '../../domain/entities/property_entity.dart' show PropertySearchFilters;
import '../models/property_model.dart';

/// Remote data source for the properties module.
///
/// Endpoints (mobile guide, `properties` + `search` modules):
///  * `GET  /properties/`                     browse / filter
///  * `GET  /properties/:id`                  detail
///  * `GET  /properties/featured`             home feed
///  * `GET  /properties/:id/availability`     calendar
///  * `GET  /properties/:id/quote`            price quote for N nights
///  * `GET  /search/properties`               advanced search
///  * `GET  /search/map`                      map pins
///  * `GET  /search/suggestions`              compound/location autocomplete
///  * `GET  /properties/mine*`                owner portfolio
///  * `POST /properties/addProperty`, `PATCH|DELETE /properties/:id`,
///    `POST /properties/:id/submit|unlist|relist`  listing lifecycle
class PropertyRemoteDataSource {
  final ApiClient _apiClient;

  PropertyRemoteDataSource(this._apiClient);

  // -- Browse -----------------------------------------------------------------

  Future<Either<Failure, List<PropertyModel>>> getProperties({
    PropertySearchFilters? filters,
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.properties,
        queryParameters: pageQuery(
          page: page,
          limit: limit,
          extra: _filterQuery(filters),
        ),
      );
      return Right(_parseList(response.data));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, PropertyModel>> getPropertyDetails(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.property(id));
      return Right(PropertyModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Home feed. The backend exposes a single curated feed (`/properties/featured`);
  /// there is no separate "offers" endpoint in the mobile API.
  Future<Either<Failure, List<PropertyModel>>> getFeaturedProperties({
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.featuredProperties,
        queryParameters: {'limit': limit},
      );
      return Right(_parseList(response.data));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Kept for the existing "trending" home rail, served by the featured feed.
  Future<Either<Failure, List<PropertyModel>>> getTrendingProperties({
    int limit = 10,
  }) =>
      getFeaturedProperties(limit: limit);

  /// Kept for the existing "offers" home rail, served by the featured feed.
  Future<Either<Failure, List<PropertyModel>>> getOffers({int limit = 10}) =>
      getFeaturedProperties(limit: limit);

  // -- Search -----------------------------------------------------------------

  Future<Either<Failure, List<PropertyModel>>> searchProperties({
    required String query,
    PropertySearchFilters? filters,
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchProperties,
        queryParameters: pageQuery(
          page: page,
          limit: limit,
          extra: {'q': query, ..._filterQuery(filters)},
        ),
      );
      return Right(_parseList(response.data));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Compound / location autocomplete for the search bar.
  Future<Either<Failure, List<Map<String, dynamic>>>> searchSuggestions(
    String query,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchSuggestions,
        queryParameters: {'q': query},
      );
      return Right(asListOfMaps(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Map pins for the Google Maps view.
  Future<Either<Failure, List<Map<String, dynamic>>>> searchMap({
    PropertySearchFilters? filters,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchMap,
        queryParameters: _filterQuery(filters),
      );
      return Right(asListOfMaps(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  // -- Availability & pricing -------------------------------------------------

  Future<Either<Failure, Map<String, dynamic>>> getPropertyAvailability(
    String id, {
    DateTime? checkIn,
    DateTime? checkOut,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.propertyAvailability(id),
        queryParameters: {
          if (checkIn != null) 'check_in': _isoDate(checkIn),
          if (checkOut != null) 'check_out': _isoDate(checkOut),
        },
      );
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Price quote for a stay (EGP; the deposit is a hold, not a charge).
  ///
  /// The endpoint takes a **night count**, not dates - passing check_in/check_out
  /// is rejected with `nights must be an integer of at least 1`.
  Future<Either<Failure, Map<String, dynamic>>> getQuote(
    String id, {
    required DateTime checkIn,
    required DateTime checkOut,
    int guests = 1,
  }) async {
    final nights = checkOut.difference(checkIn).inDays;
    if (nights < 1) {
      return const Left(
        ValidationFailure(
            'Check-out must be at least one night after check-in.'),
      );
    }
    try {
      final response = await _apiClient.get(
        ApiEndpoints.propertyQuote(id),
        queryParameters: {'nights': nights, 'guests': guests},
      );
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  // -- Owner portfolio --------------------------------------------------------

  Future<Either<Failure, List<PropertyModel>>> getMyProperties() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.myProperties);
      return Right(_parseList(response.data));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getMyCalendar() =>
      _getMap(ApiEndpoints.myCalendar);

  Future<Either<Failure, Map<String, dynamic>>> getMyEarnings() =>
      _getMap(ApiEndpoints.myEarnings);

  Future<Either<Failure, Map<String, dynamic>>> getPortfolioDashboard() =>
      _getMap(ApiEndpoints.myPortfolioDashboard);

  Future<Either<Failure, List<Map<String, dynamic>>>> getMyRenters() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.myRenters);
      return Right(asListOfMaps(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  // -- Listing lifecycle: create -> images -> submit -> unlist/relist ----------

  /// Requires an approved KYC; the backend answers `ERR_KYC_REQUIRED` otherwise.
  Future<Either<Failure, PropertyModel>> createProperty(
    Map<String, dynamic> body,
  ) async {
    try {
      final response =
          await _apiClient.post(ApiEndpoints.propertyCreate, data: body);
      return Right(PropertyModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, PropertyModel>> updateProperty(
    String id,
    Map<String, dynamic> changes,
  ) async {
    try {
      final response =
          await _apiClient.patch(ApiEndpoints.property(id), data: changes);
      return Right(PropertyModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, void>> deleteProperty(String id) =>
      _voidCall(() => _apiClient.delete(ApiEndpoints.property(id)));

  Future<Either<Failure, void>> submitProperty(String id) =>
      _voidCall(() => _apiClient.post(ApiEndpoints.propertySubmit(id)));

  Future<Either<Failure, void>> unlistProperty(String id) =>
      _voidCall(() => _apiClient.post(ApiEndpoints.propertyUnlist(id)));

  Future<Either<Failure, void>> relistProperty(String id) =>
      _voidCall(() => _apiClient.post(ApiEndpoints.propertyRelist(id)));

  Future<Either<Failure, void>> blockDates(
    String id, {
    required List<DateTime> dates,
    String? reason,
  }) =>
      _voidCall(
        () => _apiClient.post(
          ApiEndpoints.propertyBlockDates(id),
          data: {
            'dates': dates.map(_isoDate).toList(),
            if (reason != null) 'reason': reason,
          },
        ),
      );

  Future<Either<Failure, void>> unblockDates(
    String id, {
    required List<DateTime> dates,
  }) =>
      _voidCall(
        () => _apiClient.delete(
          ApiEndpoints.propertyBlockDates(id),
          data: {'dates': dates.map(_isoDate).toList()},
        ),
      );

  Future<Either<Failure, void>> removeImage(String id, String imageId) =>
      _voidCall(
          () => _apiClient.delete(ApiEndpoints.propertyImage(id, imageId)));

  Future<Either<Failure, void>> setCoverImage(String id, String imageId) =>
      _voidCall(
        () => _apiClient.put(ApiEndpoints.propertyImageCover(id, imageId)),
      );

  Future<Either<Failure, void>> requestPhotography(String id,
          {String? notes}) =>
      _voidCall(
        () => _apiClient.post(
          ApiEndpoints.propertyPhotographyRequest(id),
          data: {if (notes != null) 'notes': notes},
        ),
      );

  Future<Either<Failure, Map<String, dynamic>>> photographyStatus(String id) =>
      _getMap(ApiEndpoints.propertyPhotographyStatus(id));

  // -- Helpers ----------------------------------------------------------------

  Future<Either<Failure, Map<String, dynamic>>> _getMap(String path) async {
    try {
      final response = await _apiClient.get(path);
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, void>> _voidCall(Future<void> Function() call) async {
    try {
      await call();
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  List<PropertyModel> _parseList(dynamic body) => asListOfMaps(unwrapData(body))
      .map(PropertyModel.fromJson)
      .toList(growable: false);

  /// Filters are sent snake_case, matching the backend's JSON convention.
  /// Prices are exposed in EGP by the UI and stored in piastres server-side.
  Map<String, dynamic> _filterQuery(PropertySearchFilters? filters) {
    if (filters == null) return const {};
    return <String, dynamic>{
      if (filters.location != null) 'location': filters.location,
      if (filters.minPrice != null)
        'min_price': (filters.minPrice! * 100).round(),
      if (filters.maxPrice != null)
        'max_price': (filters.maxPrice! * 100).round(),
      if (filters.minCapacity != null) 'min_guests': filters.minCapacity,
      if (filters.maxCapacity != null) 'max_guests': filters.maxCapacity,
      if (filters.minBedrooms != null) 'min_bedrooms': filters.minBedrooms,
      if (filters.maxBedrooms != null) 'max_bedrooms': filters.maxBedrooms,
      if (filters.amenities != null && filters.amenities!.isNotEmpty)
        'amenities': filters.amenities!.join(','),
      if (filters.propertyType != null) 'property_type': filters.propertyType,
      if (filters.checkIn != null) 'check_in': _isoDate(filters.checkIn!),
      if (filters.checkOut != null) 'check_out': _isoDate(filters.checkOut!),
      if (filters.radius != null) 'radius': filters.radius,
      if (filters.sortBy != null) 'sort_by': filters.sortBy,
      if (filters.sortOrder != null) 'sort_order': filters.sortOrder,
    };
  }

  /// The API takes calendar dates (`YYYY-MM-DD`), never a full timestamp -
  /// sending one shifts the stay by a day in non-UTC time zones.
  static String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
