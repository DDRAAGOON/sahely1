import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/properties/domain/entities/property_query.dart';

/// A page of search results together with how many listings match in total.
typedef PropertySearchResult = ({List<Property> properties, int total});

abstract class RenterRepository {
  Future<List<Property>> getAllProperties();

  /// The curated trending rail (`/properties/featured`).
  Future<List<Property>> getTrending();

  /// The best-offers rail.
  Future<List<Property>> getOffers();

  /// One listing by id (`/properties/:id`).
  Future<Property> getProperty(String id);

  /// Search and filter (`/search/properties`). An empty query returns the
  /// whole catalogue, so the same call backs both browsing and filtering.
  Future<PropertySearchResult> searchProperties(
    PropertyQuery query, {
    int page,
    int limit,
  });
}
