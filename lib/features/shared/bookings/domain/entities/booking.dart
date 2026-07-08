import 'package:equatable/equatable.dart';

enum BookingStatus { upcoming, active, past, cancelled }

class Booking extends Equatable {
  final String id;
  final String propertyId;
  final String propertyName;
  final String propertyImage;
  final String location;
  final String orderNo;
  final DateTime startDate;
  final DateTime endDate;
  final int guests;
  final double totalPrice;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    required this.location,
    required this.orderNo,
    required this.startDate,
    required this.endDate,
    required this.guests,
    required this.totalPrice,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id, propertyId, propertyName, propertyImage, location, 
    orderNo, startDate, endDate, guests, totalPrice, status
  ];
}
