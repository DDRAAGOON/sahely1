enum PropertyStatus { active, underReview, draft, paused }

class Property {
  const Property({
    this.id = '1',
    required this.name,
    required this.area,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    this.type = 'Villa',
    this.beds = 3,
    this.guests = 6,
    this.tags = const [],
    this.petsOk = true,
    this.partyAllowed = false,
    this.mixedGroupsOK = true,
    this.minutesToBeach,
    this.guestFavourite = false,
    this.saved = false,
    this.status = PropertyStatus.active,
  });

  final String id;
  final String name;
  final String area; // compound / location
  final String image;
  final int price; // EGP per night
  final double rating;
  final int reviews;
  final String type;
  final int beds;
  final int guests;
  final List<String> tags;
  final bool petsOk;
  final bool partyAllowed;
  final bool mixedGroupsOK;
  final int? minutesToBeach;
  final bool guestFavourite;
  final bool saved;
  final PropertyStatus status;

  factory Property.fromMap(Map<String, dynamic> map) {
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

    return Property(
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
      partyAllowed: parseBool(map['partyAllowed'], false),
      mixedGroupsOK: parseBool(map['mixedGroupsOK'], true),
    );
  }
}
