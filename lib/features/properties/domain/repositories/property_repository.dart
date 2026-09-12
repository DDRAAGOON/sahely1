import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../entities/property_entity.dart';

/// Repository interface for properties
abstract class PropertyRepository {
  /// Get list of properties with optional filters
  Future<Either<Failure, List<PropertyEntity>>> getProperties({
    PropertySearchFilters? filters,
    int page = 1,
    int limit = 20,
  });

  /// Get property details by ID
  Future<Either<Failure, PropertyEntity>> getPropertyDetails(String id);

  /// Get trending properties
  Future<Either<Failure, List<PropertyEntity>>> getTrendingProperties({
    int limit = 10,
  });

  /// Get special offers
  Future<Either<Failure, List<PropertyEntity>>> getOffers({
    int limit = 10,
  });

  /// Search properties
  Future<Either<Failure, List<PropertyEntity>>> searchProperties({
    required String query,
    PropertySearchFilters? filters,
    int page = 1,
    int limit = 20,
  });

  /// Get property availability
  Future<Either<Failure, Map<String, dynamic>>> getPropertyAvailability(
    String id, {
    required DateTime checkIn,
    required DateTime checkOut,
  });
}
