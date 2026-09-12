import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/booking_repository.dart';
import '../entities/booking_entity.dart';

/// Use case for getting booking details
class GetBookingDetailsUseCase {
  final BookingRepository repository;

  GetBookingDetailsUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call(String bookingId) async {
    return await repository.getBookingDetails(bookingId);
  }
}
