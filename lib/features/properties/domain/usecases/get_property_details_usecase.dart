import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/property_repository.dart';
import '../entities/property_entity.dart';

/// Use case for getting property details by ID
class GetPropertyDetailsUseCase {
  final PropertyRepository repository;

  GetPropertyDetailsUseCase(this.repository);

  Future<Either<Failure, PropertyEntity>> call(String propertyId) async {
    return await repository.getPropertyDetails(propertyId);
  }
}
