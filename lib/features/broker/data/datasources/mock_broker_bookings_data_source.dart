import '../models/broker_booking_dto.dart';

class MockBrokerBookingsDataSource {
  final List<BrokerBookingDto> _bookings = [
    BrokerBookingDto(
      id: '1',
      propertyName: 'Azure Beach Villa',
      area: 'Hacienda Bay',
      imageUrl:
          'https://images.unsplash.com/photo-1776762893024-890728937eab?w=800',
      dates: 'Jun 21 – 25 · 4 nights',
      guests: '2 adults',
      orderNo: 'SHLY-8842',
      status: 'Upcoming',
      profit: 450.0,
      checkIn: DateTime(2026, 6, 21, 15, 0),
      checkOut: DateTime(2026, 6, 25, 11, 0),
    ),
    BrokerBookingDto(
      id: '2',
      propertyName: 'Lagoon Retreat',
      area: 'Marassi',
      imageUrl:
          'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800',
      dates: 'Jun 14 – 18 · 4 nights',
      guests: '4 adults',
      orderNo: 'SHLY-7741',
      status: 'Active',
      profit: 620.0,
      checkIn: DateTime(2026, 6, 14, 15, 0),
      checkOut: DateTime(2026, 6, 18, 11, 0),
    ),
    BrokerBookingDto(
      id: '3',
      propertyName: 'Sunset Chalet',
      area: 'Amwaj',
      imageUrl:
          'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800',
      dates: 'May 10 – 14 · 4 nights',
      guests: '4 adults',
      orderNo: 'SHLY-9910',
      status: 'Past',
      profit: 380.0,
      checkIn: DateTime(2024, 5, 10, 15, 0),
      checkOut: DateTime(2024, 5, 14, 11, 0),
    ),
  ];

  Future<List<BrokerBookingDto>> fetchBookings() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _bookings;
  }
}
