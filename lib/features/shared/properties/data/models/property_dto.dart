import '../../domain/entities/property.dart';

class PropertyDto {
  final String id;
  final String name;
  final String area;
  final String image;
  final int price;
  final double rating;
  final int reviews;
  final String type;
  final int beds;
  final int guests;
  final List<String> tags;
  final bool petsOk;
  final int? minutesToBeach;
  final bool guestFavourite;
  final bool saved;

  const PropertyDto({
    required this.id,
    required this.name,
    required this.area,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.type,
    required this.beds,
    required this.guests,
    required this.tags,
    required this.petsOk,
    this.minutesToBeach,
    required this.guestFavourite,
    required this.saved,
  });

  factory PropertyDto.fromJson(Map<String, dynamic> map) {
    int parseInt(dynamic value, [int fallback = 0]) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ??
            int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ??
            fallback;
      }
      return fallback;
    }

    double parseDouble(dynamic value, [double fallback = 0.0]) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ??
            double.tryParse(value.replaceAll(RegExp(r'[^0-9\.]'), '')) ??
            fallback;
      }
      return fallback;
    }

    bool parseBool(dynamic value, [bool fallback = true]) {
      if (value is bool) return value;
      if (value is String) {
        final lower = value.toLowerCase();
        if (lower == 'true' || lower == 'yes' || lower == '1') return true;
        if (lower == 'false' || lower == 'no' || lower == '0') return false;
      }
      return fallback;
    }

    return PropertyDto(
      id: map['id']?.toString() ?? '1',
      name: map['name'] ?? 'Untitled',
      area: map['location'] ?? map['area'] ?? 'North Coast',
      image: map['imageUrl'] ?? map['image'] ?? '',
      price: parseInt(map['price']),
      rating: parseDouble(map['rating']),
      reviews: parseInt(map['reviewCount'] ?? map['reviews']),
      type: map['type'] ?? 'Villa',
      beds: parseInt(map['beds'], 3),
      guests: parseInt(map['guests'], 6),
      tags: List<String>.from(map['features'] ?? map['tags'] ?? []),
      petsOk: parseBool(map['petsAllowed'] ?? map['petsOk'], true),
      minutesToBeach: map['minutesToBeach'] as int?,
      guestFavourite: parseBool(map['guestFavourite'], false),
      saved: parseBool(map['saved'], false),
    );
  }

  Property toEntity() {
    return Property(
      id: id,
      name: name,
      area: area,
      image: image,
      price: price,
      rating: rating,
      reviews: reviews,
      type: type,
      beds: beds,
      guests: guests,
      tags: tags,
      petsOk: petsOk,
      minutesToBeach: minutesToBeach,
      guestFavourite: guestFavourite,
      saved: saved,
    );
  }

  factory PropertyDto.fromEntity(Property entity) {
    return PropertyDto(
      id: entity.id,
      name: entity.name,
      area: entity.area,
      image: entity.image,
      price: entity.price,
      rating: entity.rating,
      reviews: entity.reviews,
      type: entity.type,
      beds: entity.beds,
      guests: entity.guests,
      tags: entity.tags,
      petsOk: entity.petsOk,
      minutesToBeach: entity.minutesToBeach,
      guestFavourite: entity.guestFavourite,
      saved: entity.saved,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
      'image': image,
      'price': price,
      'rating': rating,
      'reviews': reviews,
      'type': type,
      'beds': beds,
      'guests': guests,
      'tags': tags,
      'petsOk': petsOk,
      'minutesToBeach': minutesToBeach,
      'guestFavourite': guestFavourite,
      'saved': saved,
    };
  }
}
