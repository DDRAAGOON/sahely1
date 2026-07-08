import 'package:flutter/material.dart';

/// App-level role. Drives badge colour/label across the app.
enum Role { renter, owner, broker }

extension RoleX on Role {
  String get label => switch (this) {
        Role.renter => 'Renter',
        Role.owner => 'Property Owner',
        Role.broker => 'Broker',
      };

  String get shortLabel => switch (this) {
        Role.renter => 'Renter',
        Role.owner => 'Owner',
        Role.broker => 'Broker',
      };
}

class Property {
  const Property({
    this.id,
    required this.name,
    required this.area,
    this.image = '',
    this.imageUrl,
    this.price = 0,
    this.pricePerNight,
    required this.rating,
    this.reviews = 0,
    this.reviewCount,
    this.type = 'Villa',
    this.beds = 3,
    this.guests = 6,
    this.tags = const [],
    this.amenities = const [],
    this.petsOk = true,
    this.minutesToBeach,
    this.guestFavourite = false,
    this.saved = false,
    this.isSaved = false,
  });

  final String? id;
  final String name;
  final String area; // compound / location
  final String image;
  final String? imageUrl;
  final int price; // EGP per night
  final num? pricePerNight;
  final double rating;
  final int reviews;
  final int? reviewCount;
  final String type;
  final int beds;
  final int guests;
  final List<String> tags;
  final List<String> amenities;
  final bool petsOk;
  final int? minutesToBeach;
  final bool guestFavourite;
  final bool saved;
  final bool isSaved;

  String get effectiveImageUrl => imageUrl ?? image;
  int get effectivePrice => pricePerNight?.toInt() ?? price;
  int get effectiveReviewCount => reviewCount ?? reviews;
  bool get isSavedValue => isSaved || saved;
  String get propertyId => id ?? name;
}

class ServiceItem {
  const ServiceItem(this.name, this.fromPrice, this.gradient);
  final String name;
  final String fromPrice;
  final List<Color> gradient;
}
