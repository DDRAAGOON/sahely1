import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/booking_repository.dart';
import '../entities/booking_entity.dart';

/// Use case for creating a new booking
class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call({
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    String? specialRequests,
  }) async {
    return await repository.createBooking(
      propertyId: propertyId,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      specialRequests: specialRequests,
    );
  }
}
