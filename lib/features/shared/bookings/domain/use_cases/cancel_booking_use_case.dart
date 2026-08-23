import '../repositories/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<void> execute(String bookingId) {
    return repository.cancelBooking(bookingId);
  }
}
