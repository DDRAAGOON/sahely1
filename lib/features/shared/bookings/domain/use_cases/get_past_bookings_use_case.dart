import '../entities/booking.dart';
import '../repositories/booking_repository.dart';
import '../services/booking_status_service.dart';

class GetPastBookingsUseCase {
  final BookingRepository repository;
  final BookingStatusService statusService;

  GetPastBookingsUseCase(this.repository, this.statusService);

  Future<List<Booking>> execute() async {
    final all = await repository.getAllBookings();
    return all.where((b) {
      return statusService.calculateStatus(b.checkIn, b.checkOut) == BookingStatus.past;
    }).toList();
  }
}
