import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/features/shared/bookings/data/models/booking_dto.dart';
import 'package:sahely/features/shared/bookings/domain/entities/booking.dart';

/// Real remote data source for the renter/owner booking flows.
class BookingsApiDataSource {
  final ApiClient apiClient;

  BookingsApiDataSource(this.apiClient);

  Future<List<BookingDto>> fetchAllBookings() async {
    final res = await apiClient.get(ApiEndpoints.myBookings);
    return asListOfMaps(unwrapData(res.data)).map(_mapBooking).toList();
  }

  /// Owner-side inbox: confirmed stays and incoming requests.
  Future<List<BookingDto>> fetchOwnerBookings() async {
    final res = await apiClient.get(ApiEndpoints.ownerBookings);
    return asListOfMaps(unwrapData(res.data)).map(_mapBooking).toList();
  }

  Future<List<BookingDto>> fetchOwnerRequests() async {
    final res = await apiClient.get(ApiEndpoints.ownerRequests);
    return asListOfMaps(unwrapData(res.data)).map(_mapBooking).toList();
  }

  Future<void> approve(String id) =>
      apiClient.post(ApiEndpoints.bookingApprove(id));

  Future<void> reject(String id) =>
      apiClient.post(ApiEndpoints.bookingReject(id));

  Future<void> checkIn(String id) =>
      apiClient.post(ApiEndpoints.bookingCheckIn(id));

  Future<void> checkOut(String id) =>
      apiClient.post(ApiEndpoints.bookingCheckOut(id));

  /// Creates the booking on the backend; returns its server id.
  Future<String> createBooking(Booking booking,
      {int propertyPriceEgp = 0}) async {
    final res = await apiClient.post(ApiEndpoints.bookings, data: {
      'property_id': booking.propertyId,
      'check_in': _isoDate(booking.checkIn),
      'check_out': _isoDate(booking.checkOut),
      'number_of_guests': int.tryParse(
              RegExp(r'(\d+)').firstMatch(booking.guests)?.group(1) ?? '') ??
          2,
      if (booking.specialRequests != null)
        'special_requests': booking.specialRequests,
    });
    final data = unwrapData(res.data);
    return (data['id'] ?? data['booking']?['id'] ?? '').toString();
  }

  Future<void> cancelBooking(String id, {String? reason}) async {
    await apiClient.post(
      ApiEndpoints.bookingCancel(id),
      data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    );
  }

  /// The mobile API has no "extend stay" route: the flow is a *new* booking for
  /// the extra nights. Callers should create that booking instead, so this
  /// deliberately reports the gap rather than silently doing nothing.
  Future<void> extend(String id, DateTime newCheckOut) async {
    throw UnsupportedError(
      'Extending a stay is not exposed by the mobile API. '
      'Create a follow-up booking for the additional nights instead.',
    );
  }

  Future<bool> checkAvailability(
      String propertyId, DateTime start, DateTime end) async {
    try {
      final res =
          await apiClient.get(ApiEndpoints.propertyAvailability(propertyId));
      final data = unwrapData(res.data);
      final blocked = ((data['blocked_dates'] ?? data['blockedDates']) as List?)
              ?.map((e) => e.toString().substring(0, 10))
              .toSet() ??
          {};
      for (var d = start; d.isBefore(end); d = d.add(const Duration(days: 1))) {
        if (blocked.contains(_isoDate(d))) return false;
      }
      return true;
    } catch (_) {
      return true; // fail-open so a flaky availability endpoint never blocks UX
    }
  }

  static String _isoDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Maps a live booking row.
  ///
  /// Verified field names: `reference`, `checkIn`/`checkOut` (NOT
  /// `check_in_date`), `numberOfGuests`, `totalAmount` in piastres, and a
  /// nested `property` object using the same camelCase entity shape as
  /// `/properties/featured`.
  static BookingDto _mapBooking(Map<String, dynamic> b) {
    final property = asMap(b['property']);
    final images = asListOfMaps(property['images']);
    final image = images.isEmpty ? '' : '${images.first['url'] ?? ''}';

    final checkIn =
        asDate(pick(b, 'check_in')) ?? asDate(pick(b, 'check_in_date'));
    final checkOut =
        asDate(pick(b, 'check_out')) ?? asDate(pick(b, 'check_out_date'));

    final guests = asNum(pick(b, 'number_of_guests'))?.toInt() ?? 0;
    final totalPiastres =
        asNum(pick(b, 'total_amount')) ?? asNum(pick(b, 'total_charged')) ?? 0;

    final reference = '${b['reference'] ?? b['id'] ?? ''}';

    return BookingDto(
      id: '${b['id'] ?? ''}',
      propertyId: '${pick(b, 'property_id') ?? property['id'] ?? ''}',
      propertyName: '${property['title'] ?? ''}',
      location: '${property['governorate'] ?? property['city'] ?? ''}',
      orderNumber: reference,
      dates: (checkIn == null || checkOut == null)
          ? ''
          : '${_fmt(checkIn)} - ${_fmt(checkOut)}',
      guests: guests == 1 ? '1 guest' : '$guests guests',
      imageUrl: image,
      checkIn: checkIn == null ? '' : _isoDate(checkIn),
      checkOut: checkOut == null ? '' : _isoDate(checkOut),
      totalPaid: (totalPiastres ~/ 100).toInt(),
      checklist: const [],
      latitude: asNum(property['latitude'])?.toDouble(),
      longitude: asNum(property['longitude'])?.toDouble(),
    );
  }

  static String _fmt(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${m[d.month - 1]} ${d.day}';
  }
}
