class BrokerBooking {
  final String id;
  final String propertyName;
  final String area;
  final String imageUrl;
  final String dates;
  final String guests;
  final String orderNo;
  final String status;
  final double profit;
  final DateTime checkIn;
  final DateTime checkOut;

  const BrokerBooking({
    required this.id,
    required this.propertyName,
    required this.area,
    required this.imageUrl,
    required this.dates,
    required this.guests,
    required this.orderNo,
    required this.status,
    required this.profit,
    required this.checkIn,
    required this.checkOut,
  });
}

class BrokerBookingsRepository {
  final List<BrokerBooking> _bookings = [
    BrokerBooking(
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
    BrokerBooking(
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
    BrokerBooking(
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

  Future<List<BrokerBooking>> getBookings() async {
    return _bookings;
  }
}
