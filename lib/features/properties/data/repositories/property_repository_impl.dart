import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/exceptions.dart';
import 'package:sahely/core/errors/failures.dart';
import '../../domain/repositories/property_repository.dart';
import '../../domain/entities/property_entity.dart';
import '../datasources/property_remote_data_source.dart';

/// Repository implementation for properties
class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource remoteDataSource;

  PropertyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PropertyEntity>>> getProperties({
    PropertySearchFilters? filters,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await remoteDataSource.getProperties(
        filters: filters,
        page: page,
        limit: limit,
      );

      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PropertyEntity>> getPropertyDetails(String id) async {
    try {
      final result = await remoteDataSource.getPropertyDetails(id);

      return result.fold(
        (failure) => Left(failure),
        (model) => Right(model.toEntity()),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PropertyEntity>>> getTrendingProperties({
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getTrendingProperties(limit: limit);

      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PropertyEntity>>> getOffers({
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getOffers(limit: limit);

      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PropertyEntity>>> searchProperties({
    required String query,
    PropertySearchFilters? filters,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await remoteDataSource.searchProperties(
        query: query,
        filters: filters,
        page: page,
        limit: limit,
      );

      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPropertyAvailability(
    String id, {
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    try {
      final result = await remoteDataSource.getPropertyAvailability(
        id,
        checkIn: checkIn,
        checkOut: checkOut,
      );

      return result.fold(
        (failure) => Left(failure),
        (availability) => Right(availability),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
