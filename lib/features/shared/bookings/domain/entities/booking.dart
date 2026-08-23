import 'package:equatable/equatable.dart';

enum BookingStatus { upcoming, active, past }

class Booking extends Equatable {
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
  final List<Map<String, dynamic>> checklist;

  const Booking({
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
    this.checklist = const [],
  });

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

  Booking copyWith({
    String? id,
    String? propertyName,
    String? location,
    String? orderNumber,
    String? dates,
    String? guests,
    String? imageUrl,
    DateTime? checkIn,
    DateTime? checkOut,
    int? totalPaid,
    List<Map<String, dynamic>>? checklist,
  }) {
    return Booking(
      id: id ?? this.id,
      propertyName: propertyName ?? this.propertyName,
      location: location ?? this.location,
      orderNumber: orderNumber ?? this.orderNumber,
      dates: dates ?? this.dates,
      guests: guests ?? this.guests,
      imageUrl: imageUrl ?? this.imageUrl,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      totalPaid: totalPaid ?? this.totalPaid,
      checklist: checklist ?? this.checklist,
    );
  }

  @override
  List<Object?> get props => [
        id,
        propertyName,
        location,
        orderNumber,
        dates,
        guests,
        imageUrl,
        checkIn,
        checkOut,
        totalPaid,
        checklist,
      ];
}
