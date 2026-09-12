import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/features/broker/data/datasources/broker_api_data_source.dart';
import 'package:sahely/features/broker/domain/entities/broker_booking.dart';
import 'package:sahely/features/broker/domain/repositories/broker_bookings_repository.dart';

/// The broker's bookings are the stays booked on properties they referred.
///
/// The mobile API exposes them through `GET /broker/commissions`: one row per
/// booking with `{booking_id, commission_piastres, commission_egp,
/// commission_rate, booking_status, status, check_in, check_out}`. The rows
/// carry no property title, photo or guest count, so those fields stay empty
/// and the cards show the booking reference, dates and commission.
class BrokerBookingsRepositoryImpl implements BrokerBookingsRepository {
  BrokerBookingsRepositoryImpl({BrokerApiDataSource? api, ApiClient? apiClient})
      : _api = api ?? BrokerApiDataSource(apiClient ?? ApiClient());

  final BrokerApiDataSource _api;

  @override
  Future<List<BrokerBooking>> getBookings() async {
    try {
      final rows = await _api.fetchCommissions();
      return rows
          .map(_toBooking)
          .whereType<BrokerBooking>()
          .toList(growable: false);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  static const _closedStatuses = {'CANCELLED', 'EXPIRED', 'REJECTED'};

  static BrokerBooking? _toBooking(Map<String, dynamic> json) {
    final checkIn = asDate(json['check_in']);
    final checkOut = asDate(json['check_out']);
    if (checkIn == null || checkOut == null) return null;

    final id = '${json['booking_id'] ?? ''}';
    final bookingStatus = '${json['booking_status'] ?? ''}'.toUpperCase();
    final egp = asNum(json['commission_egp'])?.toDouble() ??
        (asNum(json['commission_piastres'])?.toDouble() ?? 0) / 100;

    return BrokerBooking(
      id: id,
      propertyName: '${json['property_title'] ?? ''}',
      area: '${json['property_area'] ?? ''}',
      imageUrl: '${json['property_image'] ?? ''}',
      dates: _formatStay(checkIn, checkOut),
      guests: '',
      orderNo: _reference(id),
      status: _tab(checkIn, checkOut,
          closed: _closedStatuses.contains(bookingStatus)),
      profit: egp,
      checkIn: checkIn,
      checkOut: checkOut,
    );
  }

  /// Which of the page's three tabs the stay belongs to.
  static String _tab(DateTime checkIn, DateTime checkOut,
      {required bool closed}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (closed || !checkOut.isAfter(today)) return 'Past';
    if (checkIn.isAfter(today)) return 'Upcoming';
    return 'Active';
  }

  /// Short, human-readable booking reference from the booking UUID.
  static String _reference(String id) {
    final compact = id.replaceAll('-', '');
    if (compact.isEmpty) return '';
    return 'SHLY-${compact.substring(0, compact.length < 8 ? compact.length : 8).toUpperCase()}';
  }

  static const _months = [
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
    'Dec',
  ];

  /// `Jun 21 – 25 · 4 nights` (or `Jun 29 – Jul 3 · 4 nights`).
  static String _formatStay(DateTime checkIn, DateTime checkOut) {
    final nights = DateTime(checkOut.year, checkOut.month, checkOut.day)
        .difference(DateTime(checkIn.year, checkIn.month, checkIn.day))
        .inDays;
    final start = '${_months[checkIn.month - 1]} ${checkIn.day}';
    final end = checkIn.month == checkOut.month
        ? '${checkOut.day}'
        : '${_months[checkOut.month - 1]} ${checkOut.day}';
    return '$start – $end · $nights ${nights == 1 ? 'night' : 'nights'}';
  }
}
