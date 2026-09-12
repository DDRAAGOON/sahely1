import '../entities/booking.dart';
import '../repositories/booking_repository.dart';
import '../services/booking_status_service.dart';

class GetActiveBookingsUseCase {
  final BookingRepository repository;
  final BookingStatusService statusService;

  GetActiveBookingsUseCase(this.repository, this.statusService);

  Future<List<Booking>> execute() async {
    final all = await repository.getAllBookings();
    return all.where((b) {
      return statusService.calculateStatus(b.checkIn, b.checkOut) ==
          BookingStatus.active;
    }).toList();
  }
}
