import '../repositories/booking_repository.dart';

class CheckBookingAvailabilityUseCase {
  final BookingRepository repository;

  CheckBookingAvailabilityUseCase(this.repository);

  Future<bool> execute(String propertyId, DateTime start, DateTime end) {
    return repository.checkAvailability(propertyId, start, end);
  }
}
