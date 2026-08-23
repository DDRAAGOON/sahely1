import 'package:sahely/features/broker/domain/entities/broker_booking.dart';

abstract class BrokerBookingsRepository {
  Future<List<BrokerBooking>> getBookings();
}
