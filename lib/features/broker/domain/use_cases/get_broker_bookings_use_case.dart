import '../entities/broker_booking.dart';
import '../repositories/broker_bookings_repository.dart';

class GetBrokerBookingsUseCase {
  final BrokerBookingsRepository repository;

  GetBrokerBookingsUseCase(this.repository);

  Future<List<BrokerBooking>> execute() {
    return repository.getBookings();
  }
}
