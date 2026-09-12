import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/features/shared/bookings/data/datasources/bookings_api_data_source.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';

/// Renter and owner bookings, backed by `/bookings`.
class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({BookingsApiDataSource? api, ApiClient? apiClient})
      : _api = api ?? BookingsApiDataSource(apiClient ?? ApiClient());

  final BookingsApiDataSource _api;

  @override
  Future<List<Booking>> getAllBookings() => _guard(() async {
        final dtos = await _api.fetchAllBookings();
        return dtos.map((dto) => dto.toEntity()).toList();
      });

  @override
  Future<void> addBooking(Booking booking) {
    if (booking.propertyId == null) {
      throw const ValidationFailure('This listing can no longer be booked.');
    }
    return _guard(() => _api.createBooking(booking));
  }

  /// The arrival checklist is submitted by the checklist screen through the
  /// checklist API (`/bookings/:id/checklist/...`); the booking list itself
  /// stores nothing for it.
  @override
  Future<void> updateChecklist(
      String bookingId, List<Map<String, dynamic>> newChecklist) async {}

  @override
  Future<void> cancelBooking(String bookingId) =>
      _guard(() => _api.cancelBooking(bookingId));

  /// Owner approves a pending request (`POST /bookings/:id/approve`).
  @override
  Future<void> confirmBooking(String bookingId) =>
      _guard(() => _api.approve(bookingId));

  /// Owner declines a pending request (`POST /bookings/:id/reject`).
  @override
  Future<void> rejectBooking(String bookingId) =>
      _guard(() => _api.reject(bookingId));

  @override
  Future<bool> checkAvailability(
    String propertyId,
    DateTime start,
    DateTime end,
  ) =>
      _guard(() => _api.checkAvailability(propertyId, start, end));

  @override
  Future<void> extendBooking(String bookingId, DateTime newEnd) =>
      _guard(() => _api.extend(bookingId, newEnd));

  /// Ends the stay (`POST /bookings/:id/check-out`).
  @override
  Future<void> completeBooking(String bookingId) =>
      _guard(() => _api.checkOut(bookingId));

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
