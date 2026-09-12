import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/property_repository.dart';
import '../entities/property_entity.dart';

/// Use case for getting special offers
class GetOffersUseCase {
  final PropertyRepository repository;

  GetOffersUseCase(this.repository);

  Future<Either<Failure, List<PropertyEntity>>> call({int limit = 10}) async {
    return await repository.getOffers(limit: limit);
  }
}
