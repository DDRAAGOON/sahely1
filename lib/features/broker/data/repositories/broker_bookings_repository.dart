class BrokerBooking {
  final String id;
  final String propertyName;
  final String area;
  final String imageUrl;
  final String dateRange;
  final String guests;
  final String orderNo;
  final String status;
  final double profit;

  const BrokerBooking({
    required this.id,
    required this.propertyName,
    required this.area,
    required this.imageUrl,
    required this.dateRange,
    required this.guests,
    required this.orderNo,
    required this.status,
    required this.profit,
  });
}

class BrokerBookingsRepository {
  final List<BrokerBooking> _bookings = [
    const BrokerBooking(
      id: '1',
      propertyName: 'Azure Beach Villa',
      area: 'Hacienda Bay',
      imageUrl: 'https://images.unsplash.com/photo-1776762893024-890728937eab?w=800',
      dateRange: 'Jun 21 – 25',
      guests: '2 guests',
      orderNo: 'SHLY-8842',
      status: 'Upcoming',
      profit: 450.0,
    ),
    const BrokerBooking(
      id: '2',
      propertyName: 'Lagoon Retreat',
      area: 'Marassi',
      imageUrl: 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800',
      dateRange: 'Jun 14 – 18',
      guests: '4 guests',
      orderNo: 'SHLY-7741',
      status: 'Active',
      profit: 620.0,
    ),
  ];

  Future<List<BrokerBooking>> getBookings() async {
    return _bookings;
  }
}
