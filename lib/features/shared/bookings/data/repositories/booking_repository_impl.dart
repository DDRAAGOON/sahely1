import 'package:sahely/core/errors/exception_mapper.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/mock_bookings_data_source.dart';
import '../models/booking_dto.dart';

class BookingRepositoryImpl implements BookingRepository {
  final MockBookingsDataSource dataSource;

  BookingRepositoryImpl({required this.dataSource});

  @override
  Future<List<Booking>> getAllBookings() async {
    try {
      final dtos = await dataSource.fetchAllBookings();
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> addBooking(Booking booking) async {
    try {
      await dataSource.saveBooking(BookingDto.fromEntity(booking));
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> updateChecklist(String bookingId, List<Map<String, dynamic>> newChecklist) async {
    try {
      await dataSource.updateChecklist(bookingId, newChecklist);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await dataSource.deleteBooking(bookingId);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> confirmBooking(String bookingId) async {}

  @override
  Future<void> rejectBooking(String bookingId) async {}

  @override
  Future<bool> checkAvailability(String propertyId, DateTime start, DateTime end) async => true;

  @override
  Future<void> extendBooking(String bookingId, DateTime newEnd) async {}

  @override
  Future<void> completeBooking(String bookingId) async {}
}
