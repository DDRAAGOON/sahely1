import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetBookingDetailsUseCase {
  final BookingRepository repository;

  GetBookingDetailsUseCase(this.repository);

  Future<Booking?> execute(String id) async {
    final all = await repository.getAllBookings();
    try {
      return all.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
