import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/booking_repository.dart';
import '../entities/booking_entity.dart';

/// Use case for checking out from a booking
class CheckOutBookingUseCase {
  final BookingRepository repository;

  CheckOutBookingUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call(String bookingId) async {
    return await repository.checkOut(bookingId);
  }
}
