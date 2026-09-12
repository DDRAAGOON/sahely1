import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/features/checklist/data/checklist_remote_data_source.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

/// Repository implementation for bookings.
///
/// The data sources already return `Either<Failure, Model>`, so this layer only
/// maps models to entities. The `try/catch` guards against programming errors
/// escaping the data source, not against HTTP failures.
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final ChecklistRemoteDataSource checklistDataSource;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.checklistDataSource,
  });

  @override
  Future<Either<Failure, BookingEntity>> createBooking({
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    String? specialRequests,
  }) =>
      _entity(
        () => remoteDataSource.createBooking(
          propertyId: propertyId,
          checkIn: checkIn,
          checkOut: checkOut,
          guests: guests,
          specialRequests: specialRequests,
        ),
      );

  @override
  Future<Either<Failure, BookingCalculationResult>> calculateBooking(
    BookingCalculationRequest request,
  ) async {
    try {
      final result = await remoteDataSource.calculateBooking(request);
      return result.map((model) => model.toEntity());
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await remoteDataSource.getMyBookings(
        status: status,
        page: page,
        limit: limit,
      );
      return result.map(
        (models) => models.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingDetails(String id) =>
      _entity(() => remoteDataSource.getBookingDetails(id));

  @override
  Future<Either<Failure, BookingEntity>> cancelBooking(String id) =>
      _entity(() => remoteDataSource.cancelBooking(id));

  @override
  Future<Either<Failure, BookingEntity>> checkIn(String id) =>
      _entity(() => remoteDataSource.checkIn(id));

  @override
  Future<Either<Failure, BookingEntity>> checkOut(String id) =>
      _entity(() => remoteDataSource.checkOut(id));

  @override
  Future<Either<Failure, void>> updateChecklist({
    required String bookingId,
    required String type,
    required String role,
    required Map<String, bool> items,
  }) async {
    try {
      return await checklistDataSource.submit(
        bookingId: bookingId,
        stage: type == 'departure'
            ? ChecklistStage.departure
            : ChecklistStage.arrival,
        role: role == 'owner' ? ChecklistRole.owner : ChecklistRole.renter,
        items: items.entries
            .map((e) => ChecklistItem(key: e.key, checked: e.value))
            .toList(),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, BookingEntity>> _entity(
    Future<Either<Failure, dynamic>> Function() call,
  ) async {
    try {
      final result = await call();
      return result.map<BookingEntity>((model) => model.toEntity());
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }
}
