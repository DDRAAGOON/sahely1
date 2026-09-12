import 'package:equatable/equatable.dart';

/// Property entity representing a property listing
class PropertyEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final int pricePerNight; // in piastres (divide by 100 for display)
  final int capacity;
  final int bedrooms;
  final int bathrooms;
  final int area; // in square meters
  final List<String> amenities;
  final List<PropertyImageEntity> images;
  final String? ownerId;
  final String? ownerName;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final DateTime? availableFrom;
  final DateTime? availableTo;
  final List<String> tags;
  final String propertyType; // apartment, villa, chalet, etc.
  final DateTime createdAt;

  const PropertyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.pricePerNight,
    required this.capacity,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.amenities,
    required this.images,
    this.ownerId,
    this.ownerName,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    this.availableFrom,
    this.availableTo,
    required this.tags,
    required this.propertyType,
    required this.createdAt,
  });

  /// Get price in EGP (divide piastres by 100)
  double get priceInEgp => pricePerNight / 100;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        latitude,
        longitude,
        pricePerNight,
        capacity,
        bedrooms,
        bathrooms,
        area,
        amenities,
        images,
        ownerId,
        ownerName,
        rating,
        reviewCount,
        isAvailable,
        availableFrom,
        availableTo,
        tags,
        propertyType,
        createdAt,
      ];
}

/// Property image entity
class PropertyImageEntity extends Equatable {
  final String id;
  final String url;
  final String? caption;
  final bool isPrimary;
  final int order;

  const PropertyImageEntity({
    required this.id,
    required this.url,
    this.caption,
    required this.isPrimary,
    required this.order,
  });

  @override
  List<Object?> get props => [id, url, caption, isPrimary, order];
}

/// Property search filters
class PropertySearchFilters extends Equatable {
  final String? location;
  final double? minPrice;
  final double? maxPrice;
  final int? minCapacity;
  final int? maxCapacity;
  final int? minBedrooms;
  final int? maxBedrooms;
  final List<String>? amenities;
  final String? propertyType;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? radius; // in km for location-based search
  final String? sortBy; // price, rating, distance, etc.
  final String? sortOrder; // asc, desc

  const PropertySearchFilters({
    this.location,
    this.minPrice,
    this.maxPrice,
    this.minCapacity,
    this.maxCapacity,
    this.minBedrooms,
    this.maxBedrooms,
    this.amenities,
    this.propertyType,
    this.checkIn,
    this.checkOut,
    this.radius,
    this.sortBy,
    this.sortOrder,
  });

  PropertySearchFilters copyWith({
    String? location,
    double? minPrice,
    double? maxPrice,
    int? minCapacity,
    int? maxCapacity,
    int? minBedrooms,
    int? maxBedrooms,
    List<String>? amenities,
    String? propertyType,
    DateTime? checkIn,
    DateTime? checkOut,
    double? radius,
    String? sortBy,
    String? sortOrder,
  }) {
    return PropertySearchFilters(
      location: location ?? this.location,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minCapacity: minCapacity ?? this.minCapacity,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      minBedrooms: minBedrooms ?? this.minBedrooms,
      maxBedrooms: maxBedrooms ?? this.maxBedrooms,
      amenities: amenities ?? this.amenities,
      propertyType: propertyType ?? this.propertyType,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      radius: radius ?? this.radius,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
        location,
        minPrice,
        maxPrice,
        minCapacity,
        maxCapacity,
        minBedrooms,
        maxBedrooms,
        amenities,
        propertyType,
        checkIn,
        checkOut,
        radius,
        sortBy,
        sortOrder,
      ];
}
