import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/property_repository.dart';
import '../entities/property_entity.dart';

/// Use case for searching properties
class SearchPropertiesUseCase {
  final PropertyRepository repository;

  SearchPropertiesUseCase(this.repository);

  Future<Either<Failure, List<PropertyEntity>>> call({
    required String query,
    PropertySearchFilters? filters,
    int page = 1,
    int limit = 20,
  }) async {
    return await repository.searchProperties(
      query: query,
      filters: filters,
      page: page,
      limit: limit,
    );
  }
}
