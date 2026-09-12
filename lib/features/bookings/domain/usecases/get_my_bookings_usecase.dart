import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/booking_repository.dart';
import '../entities/booking_entity.dart';

/// Use case for getting user's bookings
class GetMyBookingsUseCase {
  final BookingRepository repository;

  GetMyBookingsUseCase(this.repository);

  Future<Either<Failure, List<BookingEntity>>> call({
    BookingStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    return await repository.getMyBookings(
      status: status,
      page: page,
      limit: limit,
    );
  }
}
