import 'package:dartz/dartz.dart';

import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

import '../../domain/entities/booking_entity.dart'
    show BookingCalculationRequest, BookingStatus;
import '../models/booking_model.dart';

/// Remote data source for the bookings module.
///
/// Flow order enforced by the backend: **calculate -> create -> pay**. Calling
/// `create` without a preceding `calculate` is rejected with a pricing error,
/// so [createBooking] takes the amounts returned by [calculateBooking].
class BookingRemoteDataSource {
  final ApiClient _apiClient;

  BookingRemoteDataSource(this._apiClient);

  // -- Renter flow ------------------------------------------------------------

  /// Step 1 of the booking flow - always call this before [createBooking].
  Future<Either<Failure, BookingCalculationResultModel>> calculateBooking(
    BookingCalculationRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.bookingCalculate,
        data: {
          'property_id': request.propertyId,
          'check_in': _isoDate(request.checkIn),
          'check_out': _isoDate(request.checkOut),
          'number_of_guests': request.guests,
        },
      );
      return Right(
        BookingCalculationResultModel.fromJson(
            asMap(unwrapData(response.data))),
      );
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// Step 2 - create the booking request.
  Future<Either<Failure, BookingModel>> createBooking({
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    String? specialRequests,
    int? depositAmount,
    int? securityDeposit,
    int? totalAmount,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.bookings,
        data: {
          'property_id': propertyId,
          'check_in': _isoDate(checkIn),
          'check_out': _isoDate(checkOut),
          'number_of_guests': guests,
          if (specialRequests != null && specialRequests.isNotEmpty)
            'special_requests': specialRequests,
          if (depositAmount != null) 'deposit_amount': depositAmount,
          if (securityDeposit != null) 'security_deposit': securityDeposit,
          if (totalAmount != null) 'total_amount': totalAmount,
        },
      );
      return Right(BookingModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, List<BookingModel>>> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) =>
      _list(
        ApiEndpoints.myBookings,
        query: pageQuery(
          page: page,
          limit: limit,
          extra: {if (status != null) 'status': status.name},
        ),
      );

  Future<Either<Failure, List<BookingModel>>> getAllBookings({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) =>
      _list(ApiEndpoints.bookings, query: pageQuery(page: page, limit: limit));

  Future<Either<Failure, BookingModel>> getBookingDetails(String id) =>
      _single(() => _apiClient.get(ApiEndpoints.booking(id)));

  Future<Either<Failure, BookingModel>> cancelBooking(
    String id, {
    String? reason,
  }) =>
      _single(
        () => _apiClient.post(
          ApiEndpoints.bookingCancel(id),
          data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
        ),
      );

  Future<Either<Failure, BookingModel>> checkIn(String id) =>
      _single(() => _apiClient.post(ApiEndpoints.bookingCheckIn(id)));

  Future<Either<Failure, BookingModel>> checkOut(String id) =>
      _single(() => _apiClient.post(ApiEndpoints.bookingCheckOut(id)));

  Future<Either<Failure, void>> dispute(String id, String reason) => _voidCall(
        () => _apiClient.post(
          ApiEndpoints.bookingDispute(id),
          data: {'reason': reason},
        ),
      );

  /// Smart-lock PIN for the stay; only valid inside the check-in window.
  Future<Either<Failure, Map<String, dynamic>>> getLockPin(String id) =>
      _map(ApiEndpoints.bookingLockPin(id));

  Future<Either<Failure, Map<String, dynamic>>> getReceipt(String id) =>
      _map(ApiEndpoints.bookingReceipt(id));

  // -- Owner flow -------------------------------------------------------------

  Future<Either<Failure, List<BookingModel>>> getOwnerBookings({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) =>
      _list(
        ApiEndpoints.ownerBookings,
        query: pageQuery(page: page, limit: limit),
      );

  Future<Either<Failure, List<BookingModel>>> getOwnerRequests({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) =>
      _list(
        ApiEndpoints.ownerRequests,
        query: pageQuery(page: page, limit: limit),
      );

  Future<Either<Failure, List<BookingModel>>> getPendingApproval({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) =>
      _list(
        ApiEndpoints.pendingApprovalBookings,
        query: pageQuery(page: page, limit: limit),
      );

  Future<Either<Failure, BookingModel>> approve(String id) =>
      _single(() => _apiClient.post(ApiEndpoints.bookingApprove(id)));

  Future<Either<Failure, BookingModel>> reject(String id) =>
      _single(() => _apiClient.post(ApiEndpoints.bookingReject(id)));

  Future<Either<Failure, void>> markNoShow(String id) =>
      _voidCall(() => _apiClient.post(ApiEndpoints.bookingNoShow(id)));

  Future<Either<Failure, void>> chargeLateCheckout(String id) =>
      _voidCall(() => _apiClient.post(ApiEndpoints.bookingLateCheckout(id)));

  // -- Helpers ----------------------------------------------------------------

  Future<Either<Failure, List<BookingModel>>> _list(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _apiClient.get(path, queryParameters: query);
      final bookings = asListOfMaps(unwrapData(response.data))
          .map(BookingModel.fromJson)
          .toList(growable: false);
      return Right(bookings);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, BookingModel>> _single(
    Future<dynamic> Function() call,
  ) async {
    try {
      final response = await call();
      return Right(BookingModel.fromJson(asMap(unwrapData(response.data))));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> _map(String path) async {
    try {
      final response = await _apiClient.get(path);
      return Right(asMap(unwrapData(response.data)));
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  Future<Either<Failure, void>> _voidCall(Future<void> Function() call) async {
    try {
      await call();
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMapper.map(e));
    }
  }

  /// The API takes calendar dates (`YYYY-MM-DD`); sending a full timestamp
  /// shifts the stay by a day for anyone east/west of UTC.
  static String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
