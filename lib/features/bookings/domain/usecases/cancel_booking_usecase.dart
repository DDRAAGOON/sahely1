import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/booking_repository.dart';
import '../entities/booking_entity.dart';

/// Use case for cancelling a booking
class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call(String bookingId) async {
    return await repository.cancelBooking(bookingId);
  }
}
