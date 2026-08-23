import 'package:equatable/equatable.dart';

class BrokerBooking extends Equatable {
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

  BrokerBooking copyWith({
    String? id,
    String? propertyName,
    String? area,
    String? imageUrl,
    String? dates,
    String? guests,
    String? orderNo,
    String? status,
    double? profit,
    DateTime? checkIn,
    DateTime? checkOut,
  }) {
    return BrokerBooking(
      id: id ?? this.id,
      propertyName: propertyName ?? this.propertyName,
      area: area ?? this.area,
      imageUrl: imageUrl ?? this.imageUrl,
      dates: dates ?? this.dates,
      guests: guests ?? this.guests,
      orderNo: orderNo ?? this.orderNo,
      status: status ?? this.status,
      profit: profit ?? this.profit,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }

  factory BrokerBooking.fromJson(Map<String, dynamic> json) {
    return BrokerBooking(
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
