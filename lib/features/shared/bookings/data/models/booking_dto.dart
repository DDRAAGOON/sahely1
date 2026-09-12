import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';

class BookingDto extends Equatable {
  final String id;
  final String propertyId;
  final String propertyName;
  final String location;
  final String orderNumber;
  final String dates;
  final String guests;
  final String imageUrl;
  final String checkIn;
  final String checkOut;
  final int totalPaid;
  final List<Map<String, dynamic>> checklist;

  const BookingDto({
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
    required this.checklist,
    this.latitude,
    this.longitude,
  });

  /// Where the listing is, when the backend has coordinates for it.
  final double? latitude;
  final double? longitude;

  BookingDto copyWith({
    String? id,
    String? propertyName,
    String? location,
    String? orderNumber,
    String? dates,
    String? guests,
    String? imageUrl,
    String? checkIn,
    String? checkOut,
    int? totalPaid,
    List<Map<String, dynamic>>? checklist,
  }) {
    return BookingDto(
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

  factory BookingDto.fromJson(Map<String, dynamic> json) {
    return BookingDto(
      id: json['id'] as String,
      propertyName: json['propertyName'] as String,
      location: json['location'] as String,
      orderNumber: json['orderNumber'] as String,
      dates: json['dates'] as String,
      guests: json['guests'] as String,
      imageUrl: json['imageUrl'] as String,
      checkIn: json['checkIn'] as String,
      checkOut: json['checkOut'] as String,
      totalPaid: json['totalPaid'] as int,
      checklist: List<Map<String, dynamic>>.from(json['checklist'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyName': propertyName,
      'location': location,
      'orderNumber': orderNumber,
      'dates': dates,
      'guests': guests,
      'imageUrl': imageUrl,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'totalPaid': totalPaid,
      'checklist': checklist,
    };
  }

  Booking toEntity() {
    return Booking(
      id: id,
      propertyName: propertyName,
      location: location,
      orderNumber: orderNumber,
      dates: dates,
      guests: guests,
      imageUrl: imageUrl,
      checkIn: DateTime.parse(checkIn),
      checkOut: DateTime.parse(checkOut),
      totalPaid: totalPaid,
      checklist: checklist,
    );
  }

  factory BookingDto.fromEntity(Booking entity) {
    return BookingDto(
      id: entity.id,
      propertyName: entity.propertyName,
      location: entity.location,
      orderNumber: entity.orderNumber,
      dates: entity.dates,
      guests: entity.guests,
      imageUrl: entity.imageUrl,
      checkIn: entity.checkIn.toIso8601String(),
      checkOut: entity.checkOut.toIso8601String(),
      totalPaid: entity.totalPaid,
      checklist: entity.checklist,
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
