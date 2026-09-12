import 'package:dartz/dartz.dart';
import 'package:sahely/core/errors/failures.dart';
import '../entities/booking_entity.dart';

/// Repository interface for bookings
abstract class BookingRepository {
  /// Create a new booking
  Future<Either<Failure, BookingEntity>> createBooking({
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    String? specialRequests,
  });

  /// Calculate booking price
  Future<Either<Failure, BookingCalculationResult>> calculateBooking(
    BookingCalculationRequest request,
  );

  /// Get user's bookings
  Future<Either<Failure, List<BookingEntity>>> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = 20,
  });

  /// Get booking details
  Future<Either<Failure, BookingEntity>> getBookingDetails(String id);

  /// Cancel booking
  Future<Either<Failure, BookingEntity>> cancelBooking(String id);

  /// Check in to booking
  Future<Either<Failure, BookingEntity>> checkIn(String id);

  /// Check out from booking
  Future<Either<Failure, BookingEntity>> checkOut(String id);

  /// Update checklist
  Future<Either<Failure, void>> updateChecklist({
    required String bookingId,
    required String type,
    required String role,
    required Map<String, bool> items,
  });
}
