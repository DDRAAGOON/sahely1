import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/property_repository.dart';
import '../entities/property_entity.dart';

/// Use case for getting properties with optional filters
class GetPropertiesUseCase {
  final PropertyRepository repository;

  GetPropertiesUseCase(this.repository);

  Future<Either<Failure, List<PropertyEntity>>> call({
    PropertySearchFilters? filters,
    int page = 1,
    int limit = 20,
  }) async {
    return await repository.getProperties(
      filters: filters,
      page: page,
      limit: limit,
    );
  }
}
