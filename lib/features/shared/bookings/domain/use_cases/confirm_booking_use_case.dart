import '../repositories/booking_repository.dart';

class ConfirmBookingUseCase {
  final BookingRepository repository;

  ConfirmBookingUseCase(this.repository);

  Future<void> execute(String bookingId) {
    return repository.confirmBooking(bookingId);
  }
}
