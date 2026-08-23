import '../repositories/booking_repository.dart';

class CompleteBookingUseCase {
  final BookingRepository repository;

  CompleteBookingUseCase(this.repository);

  Future<void> execute(String bookingId) {
    return repository.completeBooking(bookingId);
  }
}
