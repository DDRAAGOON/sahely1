import 'package:flutter/material.dart';

import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/providers/safe_notifier.dart';
import 'package:sahely/features/shared/bookings/data/datasources/bookings_api_data_source.dart';

enum BookingStatus { upcoming, active, past }

class Booking {
  final String id;
  final String propertyId;
  final String propertyName;
  final String location;
  final String orderNumber;
  final String dates;
  final String guests;
  final String imageUrl;
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPaid;

  /// Where the listing is, when the backend has coordinates for it.
  final double? latitude;
  final double? longitude;

  List<Map<String, dynamic>> checklist;

  Booking({
    required this.id,
    this.propertyId = '',
    required this.propertyName,
    required this.location,
    required this.orderNumber,
    required this.dates,
    required this.guests,
    required this.imageUrl,
    required this.checkIn,
    required this.checkOut,
    required this.totalPaid,
    this.latitude,
    this.longitude,
    List<Map<String, dynamic>>? checklist,
  }) : checklist = checklist ??
            [
              {'label': 'Key collection / Smart lock', 'completed': false},
              {'label': 'Wi-Fi connectivity', 'completed': false},
              {'label': 'AC performance', 'completed': false},
              {'label': 'Cleaning standard', 'completed': false},
              {'label': 'Hot water availability', 'completed': false},
              {'label': 'Pool access', 'completed': false},
            ];

  BookingStatus get status {
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

  String get statusText {
    switch (status) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.past:
        return 'Past';
    }
  }
}

/// The signed-in user's own stays (`GET /bookings/my`).
///
/// Screens call [load] when they open. A failed request keeps the last list
/// on screen instead of blanking it.
class BookingsProvider extends ChangeNotifier with SafeNotifier {
  BookingsProvider({BookingsApiDataSource? api}) : _injectedApi = api;

  final BookingsApiDataSource? _injectedApi;

  /// Created on first use, so building the provider needs no network stack.
  late final BookingsApiDataSource _api =
      _injectedApi ?? BookingsApiDataSource(ApiClient());

  final List<Booking> _bookings = [];
  bool _loading = false;
  bool _loaded = false;
  Object? _error;

  bool get isLoading => _loading;
  bool get isLoaded => _loaded;
  Object? get error => _error;

  List<Booking> get activeBookings =>
      _bookings.where((b) => b.status == BookingStatus.active).toList();

  List<Booking> get upcomingBookings =>
      _bookings.where((b) => b.status == BookingStatus.upcoming).toList();

  List<Booking> get pastBookings =>
      _bookings.where((b) => b.status == BookingStatus.past).toList();

  /// [force] is for pull-to-refresh: it reloads even when the list is
  /// already there.
  Future<void> load({bool force = false}) async {
    if (_loading) return;
    if (_loaded && !force && _bookings.isNotEmpty && _error == null) return;
    _loading = true;
    notifyListeners();
    try {
      final dtos = await _api.fetchAllBookings();
      _bookings
        ..clear()
        ..addAll(dtos
            .where((d) => d.checkIn.isNotEmpty && d.checkOut.isNotEmpty)
            .map((d) => Booking(
                  id: d.id,
                  propertyId: d.propertyId,
                  propertyName: d.propertyName,
                  location: d.location,
                  orderNumber: d.orderNumber,
                  dates: d.dates,
                  guests: d.guests,
                  imageUrl: d.imageUrl,
                  checkIn: DateTime.parse(d.checkIn),
                  checkOut: DateTime.parse(d.checkOut),
                  totalPaid: d.totalPaid,
                  latitude: d.latitude,
                  longitude: d.longitude,
                )));
      _loaded = true;
      _error = null;
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void updateChecklist(
      String bookingId, List<Map<String, dynamic>> newChecklist) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index].checklist = newChecklist;
      notifyListeners();
    }
  }
}
