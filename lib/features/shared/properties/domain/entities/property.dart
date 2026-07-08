import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String id;
  final String name;
  final String area;
  final String imageUrl;
  final double pricePerNight;
  final double rating;
  final int reviewCount;
  final String type;
  final int beds;
  final int guests;
  final List<String> amenities;
  final bool petsOk;
  final bool isSaved;

  const Property({
    required this.id,
    required this.name,
    required this.area,
    required this.imageUrl,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    this.type = 'Villa',
    this.beds = 3,
    this.guests = 6,
    this.amenities = const [],
    this.petsOk = true,
    this.isSaved = false,
  });

  @override
  List<Object?> get props => [
        id, name, area, imageUrl, pricePerNight, rating, 
        reviewCount, type, beds, guests, amenities, petsOk, isSaved,
      ];
}
