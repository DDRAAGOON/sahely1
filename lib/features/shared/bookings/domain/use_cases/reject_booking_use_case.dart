import '../repositories/booking_repository.dart';

class RejectBookingUseCase {
  final BookingRepository repository;

  RejectBookingUseCase(this.repository);

  Future<void> execute(String bookingId) {
    return repository.rejectBooking(bookingId);
  }
}
