import '../entities/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getAllBookings();
  Future<void> addBooking(Booking booking);
  Future<void> updateChecklist(String bookingId, List<Map<String, dynamic>> newChecklist);
  Future<void> cancelBooking(String bookingId);
  
  // Future operations
  Future<void> confirmBooking(String bookingId);
  Future<void> rejectBooking(String bookingId);
  Future<bool> checkAvailability(String propertyId, DateTime start, DateTime end);
  Future<void> extendBooking(String bookingId, DateTime newEnd);
  Future<void> completeBooking(String bookingId);
}
