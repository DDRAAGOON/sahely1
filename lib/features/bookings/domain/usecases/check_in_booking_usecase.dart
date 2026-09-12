import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/booking_repository.dart';
import '../entities/booking_entity.dart';

/// Use case for checking in to a booking
class CheckInBookingUseCase {
  final BookingRepository repository;

  CheckInBookingUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call(String bookingId) async {
    return await repository.checkIn(bookingId);
  }
}
