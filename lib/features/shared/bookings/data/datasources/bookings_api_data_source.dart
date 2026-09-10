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
    final data = unwrapData(res.data);
    final list = (data is List)
        ? data
        : ((data['bookings'] ?? data['data'] ?? []) as List);
    return list
        .whereType<Map>()
        .map((e) => _mapBooking(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Creates the booking on the backend; returns its server id.
  Future<String> createBooking(Booking booking, {int propertyPriceEgp = 0}) async {
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

  Future<void> cancelBooking(String id) async {
    await apiClient.post(ApiEndpoints.bookingCancel(id), data: {
      'reason': 'Cancelled from app',
    });
  }

  Future<void> extend(String id, DateTime newCheckOut) async {
    await apiClient.post(ApiEndpoints.bookingExtend(id), data: {
      'new_check_out': _isoDate(newCheckOut),
    });
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
      for (var d = start;
          d.isBefore(end);
          d = d.add(const Duration(days: 1))) {
        if (blocked.contains(_isoDate(d))) return false;
      }
      return true;
    } catch (_) {
      return true; // fail-open so a flaky availability endpoint never blocks UX
    }
  }

  static String _isoDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static BookingDto _mapBooking(Map<String, dynamic> b) {
    final property = (b['property'] as Map?) ?? const {};
    final images = (property['images'] as List?) ?? const [];
    String image = '';
    if (images.isNotEmpty) {
      final first = Map<String, dynamic>.from(images.first as Map);
      image = '${first['url'] ?? ''}';
    }
    final checkIn = DateTime.tryParse('${b['check_in_date'] ?? b['checkInDate'] ?? ''}') ??
        DateTime.now().add(const Duration(days: 7));
    final checkOut = DateTime.tryParse('${b['check_out_date'] ?? b['checkOutDate'] ?? ''}') ??
        checkIn.add(const Duration(days: 3));
    return BookingDto(
      id: '${b['id']}',
      propertyName:
          '${property['title'] ?? b['property_title'] ?? 'Property'}',
      location: '${property['governorate'] ?? property['city'] ?? ''}',
      orderNumber: '${b['reference'] ?? b['id']}'.substring(0, 12.clamp(0, '${b['reference'] ?? b['id']}'.length)),
      dates: '${_fmt(checkIn)} – ${_fmt(checkOut)}',
      guests: '${b['number_of_guests'] ?? 2} guests',
      imageUrl: image,
      checkIn: _isoDate(checkIn),
      checkOut: _isoDate(checkOut),
      totalPaid: (b['total_charged'] as num? ?? 0) ~/ 100,
      checklist: const [],
    );
  }

  static String _fmt(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[d.month - 1]} ${d.day}';
  }
}
