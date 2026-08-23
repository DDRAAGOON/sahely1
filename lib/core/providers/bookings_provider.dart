import 'package:flutter/material.dart';

enum BookingStatus { upcoming, active, past }

class Booking {
  final String id;
  final String propertyName;
  final String location;
  final String orderNumber;
  final String dates;
  final String guests;
  final String imageUrl;
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPaid;
  List<Map<String, dynamic>> checklist;

  Booking({
    required this.id,
    required this.propertyName,
    required this.location,
    required this.orderNumber,
    required this.dates,
    required this.guests,
    required this.imageUrl,
    required this.checkIn,
    required this.checkOut,
    required this.totalPaid,
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

class BookingsProvider extends ChangeNotifier {
  static final DateTime _now = DateTime.now();

  final List<Booking> _bookings = [
    Booking(
      id: '1',
      propertyName: 'Lagoon Retreat',
      location: 'Marassi · North Coast',
      orderNumber: 'SHLY-7741',
      dates: 'Active Stay · 4 nights',
      guests: '2 adults, 1 child',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      checkIn: _now.subtract(const Duration(days: 1)),
      checkOut: _now.add(const Duration(days: 3)),
      totalPaid: 2100000,
    ),
    Booking(
      id: '2',
      propertyName: 'Azure Beach Villa',
      location: 'Hacienda Bay · North Coast',
      orderNumber: 'SHLY-8842',
      dates: 'Upcoming · 4 nights',
      guests: '2 adults',
      imageUrl:
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=400',
      checkIn: _now.add(const Duration(days: 7)),
      checkOut: _now.add(const Duration(days: 11)),
      totalPaid: 1800000,
    ),
    Booking(
      id: '3',
      propertyName: 'Sunset Chalet',
      location: 'Amwaj · North Coast',
      orderNumber: 'SHLY-9910',
      dates: 'Past Stay · 4 nights',
      guests: '4 adults',
      imageUrl:
          'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800',
      checkIn: _now.subtract(const Duration(days: 30)),
      checkOut: _now.subtract(const Duration(days: 26)),
      totalPaid: 1200000,
    ),
  ];

  List<Booking> get activeBookings =>
      _bookings.where((b) => b.status == BookingStatus.active).toList();

  List<Booking> get upcomingBookings =>
      _bookings.where((b) => b.status == BookingStatus.upcoming).toList();

  List<Booking> get pastBookings =>
      _bookings.where((b) => b.status == BookingStatus.past).toList();

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
