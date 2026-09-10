import 'package:sahely/core/config/app_config.dart';
import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/features/shared/bookings/data/datasources/bookings_api_data_source.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/mock_bookings_data_source.dart';
import '../models/booking_dto.dart';

class BookingRepositoryImpl implements BookingRepository {
  final MockBookingsDataSource dataSource;
  final BookingsApiDataSource? apiDataSource;

  BookingRepositoryImpl({required this.dataSource, ApiClient? apiClient})
      : apiDataSource =
            AppConfig.useRemoteApi ? BookingsApiDataSource(apiClient ?? ApiClient()) : null;

  @override
  Future<List<Booking>> getAllBookings() async {
    try {
      if (apiDataSource != null) {
        final dtos = await apiDataSource!.fetchAllBookings();
        return dtos.map((dto) => dto.toEntity()).toList();
      }
      final dtos = await dataSource.fetchAllBookings();
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> addBooking(Booking booking) async {
    try {
      if (apiDataSource != null && booking.propertyId != null) {
        await apiDataSource!.createBooking(booking);
        return;
      }
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
      if (apiDataSource != null) {
        await apiDataSource!.cancelBooking(bookingId);
        await dataSource.deleteBooking(bookingId); // keep local cache in sync
        return;
      }
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
  Future<void> extendBooking(String bookingId, DateTime newEnd) async {
    if (apiDataSource != null) {
      await apiDataSource!.extend(bookingId, newEnd);
      return;
    }}

  @override
  Future<void> completeBooking(String bookingId) async {}
}
