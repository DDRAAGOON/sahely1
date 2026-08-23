import '../entities/booking.dart';

class BookingStatusService {
  BookingStatus calculateStatus(DateTime checkIn, DateTime checkOut) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkInDate = DateTime(checkIn.year, checkIn.month, checkIn.day);

    if (today.isBefore(checkInDate)) {
      return BookingStatus.upcoming;
    } else if (now.isAfter(checkOut)) {
      return BookingStatus.past;
    } else {
      return BookingStatus.active;
    }
  }
}
