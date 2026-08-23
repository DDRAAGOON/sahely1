import '../entities/broker_booking.dart';

class FilterBrokerBookingsUseCase {
  List<BrokerBooking> execute(List<BrokerBooking> bookings, String status) {
    return bookings.where((b) => b.status == status).toList();
  }
}
