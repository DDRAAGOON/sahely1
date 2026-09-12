import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../repositories/booking_repository.dart';
import '../entities/booking_entity.dart';

/// Use case for calculating booking price
class CalculateBookingUseCase {
  final BookingRepository repository;

  CalculateBookingUseCase(this.repository);

  Future<Either<Failure, BookingCalculationResult>> call(
    BookingCalculationRequest request,
  ) async {
    return await repository.calculateBooking(request);
  }
}
