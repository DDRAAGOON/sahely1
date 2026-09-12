enum PropertyStatus { active, underReview, draft, paused }

class Property {
  const Property({
    this.id = '1',
    required this.name,
    required this.area,
    required this.image,
    this.images = const [],
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
    this.description = '',
    this.baths = 0,
    this.areaSqm,
    this.floor,
    this.unit = '',
    this.checkInTime = '',
    this.checkOutTime = '',
    this.cancellationPolicy = '',
    this.latitude,
    this.longitude,
    this.smartLock = false,
  });

  final String id;
  final String name;
  final String area; // compound / location
  final String image;

  /// Every photo of the listing, cover first (`GET /properties/:id`).
  /// Feed responses carry only the cover, so this is empty until the
  /// listing itself is fetched.
  final List<String> images;

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

  // -- Straight from `GET /properties/:id`; empty when the listing has none.

  final String description;
  final int baths;
  final double? areaSqm;
  final int? floor;

  /// The unit number inside a compound, when the listing has one.
  final String unit;

  /// `16:00:00` as the backend stores it.
  final String checkInTime;
  final String checkOutTime;

  /// flexible · moderate · strict.
  final String cancellationPolicy;

  final double? latitude;
  final double? longitude;

  /// Whether a smart lock is fitted.
  final bool smartLock;

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
      images: [
        for (final url in (map['images'] as List?) ?? const [])
          if ('$url'.isNotEmpty) '$url',
      ],
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
      description: map['description'] ?? '',
      baths: parseInt(map['baths'] ?? map['bathrooms']),
      areaSqm: map['areaSqm'] == null ? null : parseDouble(map['areaSqm']),
      floor: map['floor'] == null ? null : parseInt(map['floor']),
      unit: map['unit'] ?? '',
      checkInTime: map['checkInTime'] ?? '',
      checkOutTime: map['checkOutTime'] ?? '',
      cancellationPolicy: map['cancellationPolicy'] ?? '',
      latitude: map['latitude'] == null ? null : parseDouble(map['latitude']),
      longitude:
          map['longitude'] == null ? null : parseDouble(map['longitude']),
      smartLock: parseBool(map['smartLock'], false),
    );
  }
}
