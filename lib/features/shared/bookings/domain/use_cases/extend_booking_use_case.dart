import '../repositories/booking_repository.dart';

class ExtendBookingUseCase {
  final BookingRepository repository;

  ExtendBookingUseCase(this.repository);

  Future<void> execute(String bookingId, DateTime newEnd) {
    return repository.extendBooking(bookingId, newEnd);
  }
}
