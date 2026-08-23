import 'package:equatable/equatable.dart';
import '../../domain/entities/broker_booking.dart';

class BrokerBookingDto extends Equatable {
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

  const BrokerBookingDto({
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

  factory BrokerBookingDto.fromJson(Map<String, dynamic> json) {
    return BrokerBookingDto(
      id: json['id'] as String,
      propertyName: json['propertyName'] as String,
      area: json['area'] as String,
      imageUrl: json['imageUrl'] as String,
      dates: json['dates'] as String,
      guests: json['guests'] as String,
      orderNo: json['orderNo'] as String,
      status: json['status'] as String,
      profit: (json['profit'] as num).toDouble(),
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyName': propertyName,
      'area': area,
      'imageUrl': imageUrl,
      'dates': dates,
      'guests': guests,
      'orderNo': orderNo,
      'status': status,
      'profit': profit,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
    };
  }

  BrokerBooking toEntity() {
    return BrokerBooking(
      id: id,
      propertyName: propertyName,
      area: area,
      imageUrl: imageUrl,
      dates: dates,
      guests: guests,
      orderNo: orderNo,
      status: status,
      profit: profit,
      checkIn: checkIn,
      checkOut: checkOut,
    );
  }

  factory BrokerBookingDto.fromEntity(BrokerBooking entity) {
    return BrokerBookingDto(
      id: entity.id,
      propertyName: entity.propertyName,
      area: entity.area,
      imageUrl: entity.imageUrl,
      dates: entity.dates,
      guests: entity.guests,
      orderNo: entity.orderNo,
      status: entity.status,
      profit: entity.profit,
      checkIn: entity.checkIn,
      checkOut: entity.checkOut,
    );
  }

  @override
  List<Object?> get props => [
        id,
        propertyName,
        area,
        imageUrl,
        dates,
        guests,
        orderNo,
        status,
        profit,
        checkIn,
        checkOut,
      ];
}
