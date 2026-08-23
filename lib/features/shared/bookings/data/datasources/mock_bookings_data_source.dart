import '../models/booking_dto.dart';

class MockBookingsDataSource {
  final List<BookingDto> _bookings = [
    BookingDto(
      id: '1',
      propertyName: 'Lagoon Retreat',
      location: 'Marassi · North Coast',
      orderNumber: 'SHLY-7741',
      dates: 'Active Stay · 4 nights',
      guests: '2 adults, 1 child',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      checkIn: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      checkOut: DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      totalPaid: 2100000,
      checklist: const [
        {'label': 'Key collection / Smart lock', 'completed': false},
        {'label': 'Wi-Fi connectivity', 'completed': false},
        {'label': 'AC performance', 'completed': false},
        {'label': 'Cleaning standard', 'completed': false},
        {'label': 'Hot water availability', 'completed': false},
        {'label': 'Pool access', 'completed': false},
      ],
    ),
    BookingDto(
      id: '2',
      propertyName: 'Azure Beach Villa',
      location: 'Hacienda Bay · North Coast',
      orderNumber: 'SHLY-8842',
      dates: 'Upcoming · 4 nights',
      guests: '2 adults',
      imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=400',
      checkIn: DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      checkOut: DateTime.now().add(const Duration(days: 11)).toIso8601String(),
      totalPaid: 1800000,
      checklist: const [],
    ),
    BookingDto(
      id: '3',
      propertyName: 'Sunset Chalet',
      location: 'Amwaj · North Coast',
      orderNumber: 'SHLY-9910',
      dates: 'Past Stay · 4 nights',
      guests: '4 adults',
      imageUrl: 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800',
      checkIn: DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      checkOut: DateTime.now().subtract(const Duration(days: 26)).toIso8601String(),
      totalPaid: 1200000,
      checklist: const [],
    ),
  ];

  Future<List<BookingDto>> fetchAllBookings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _bookings;
  }

  Future<void> saveBooking(BookingDto booking) async {
    _bookings.add(booking);
  }

  Future<void> deleteBooking(String id) async {
    _bookings.removeWhere((b) => b.id == id);
  }

  Future<void> updateChecklist(String bookingId, List<Map<String, dynamic>> newChecklist) async {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(checklist: newChecklist);
    }
  }
}
