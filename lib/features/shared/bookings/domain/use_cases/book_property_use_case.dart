import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class BookPropertyUseCase {
  final BookingRepository repository;

  BookPropertyUseCase(this.repository);

  Future<void> execute(Booking booking) {
    return repository.addBooking(booking);
  }
}
