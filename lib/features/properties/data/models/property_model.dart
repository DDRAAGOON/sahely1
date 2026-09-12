import 'package:sahely/core/network/api_envelope.dart';
import '../../domain/entities/property_entity.dart';

/// Property model from API response
class PropertyModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final int pricePerNight;
  final int capacity;
  final int bedrooms;
  final int bathrooms;
  final int area;
  final List<String> amenities;
  final List<PropertyImageModel> images;
  final String? ownerId;
  final String? ownerName;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final DateTime? availableFrom;
  final DateTime? availableTo;
  final List<String> tags;
  final String propertyType;
  final DateTime createdAt;

  PropertyModel({
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

  /// Parses the backend property entity.
  ///
  /// Verified against a live `/properties/featured` response: the API
  /// serialises camelCase, sends decimals as *strings* (`"30.0697820"`,
  /// `"120.50"`), and prices in **piastres** (`basePricePerNight: 375000`)
  /// alongside a formatted EGP string (`nightlyRate: "3750.00"`).
  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    final status = '${json['status'] ?? ''}'.toLowerCase();

    return PropertyModel(
      id: json['id']?.toString() ?? '',
      title: '${json['title'] ?? ''}',
      description: '${json['description'] ?? ''}',
      // The API has no single "location" field; the UI shows the area.
      location:
          '${json['governorate'] ?? json['city'] ?? pick(json, 'address_line1') ?? ''}',
      latitude: asNum(json['latitude'])?.toDouble() ?? 0.0,
      longitude: asNum(json['longitude'])?.toDouble() ?? 0.0,
      pricePerNight: asNum(pick(json, 'base_price_per_night'))?.toInt() ??
          // Fall back to the EGP string, converted to piastres.
          ((asNum(pick(json, 'nightly_rate'))?.toDouble() ?? 0) * 100).round(),
      capacity: asNum(pick(json, 'max_guests'))?.toInt() ??
          asNum(pick(json, 'max_occupancy'))?.toInt() ??
          0,
      bedrooms: asNum(json['bedrooms'])?.toInt() ?? 0,
      bathrooms: asNum(json['bathrooms'])?.toInt() ?? 0,
      area: asNum(pick(json, 'area_sqm'))?.round() ?? 0,
      amenities: asStringList(json['amenities']),
      images: asListOfMaps(json['images'])
          .map(PropertyImageModel.fromJson)
          .toList(),
      ownerId: pick(json, 'owner_id')?.toString(),
      ownerName: pick(json, 'owner_name')?.toString(),
      rating: asNum(pick(json, 'average_rating'))?.toDouble() ?? 0.0,
      reviewCount: asNum(pick(json, 'total_reviews'))?.toInt() ?? 0,
      // A listing is bookable while it is active and not soft-deleted.
      isAvailable: status == 'active' && pick(json, 'deleted_at') == null,
      availableFrom: asDate(pick(json, 'listing_start_date')),
      availableTo: asDate(pick(json, 'listing_end_date')),
      tags: asStringList(json['tags']),
      propertyType: '${pick(json, 'property_type') ?? ''}',
      createdAt: asDate(pick(json, 'created_at')) ?? DateTime.now(),
    );
  }

  /// Convert to domain entity
  PropertyEntity toEntity() {
    return PropertyEntity(
      id: id,
      title: title,
      description: description,
      location: location,
      latitude: latitude,
      longitude: longitude,
      pricePerNight: pricePerNight,
      capacity: capacity,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      area: area,
      amenities: amenities,
      images: images.map((e) => e.toEntity()).toList(),
      ownerId: ownerId,
      ownerName: ownerName,
      rating: rating,
      reviewCount: reviewCount,
      isAvailable: isAvailable,
      availableFrom: availableFrom,
      availableTo: availableTo,
      tags: tags,
      propertyType: propertyType,
      createdAt: createdAt,
    );
  }
}

/// Property image model
class PropertyImageModel {
  final String id;
  final String url;
  final String? caption;
  final bool isPrimary;
  final int order;

  PropertyImageModel({
    required this.id,
    required this.url,
    this.caption,
    required this.isPrimary,
    required this.order,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: json['id']?.toString() ?? '',
      url: json['url'] ?? '',
      caption: json['caption'],
      isPrimary: pick(json, 'is_primary') as bool? ?? false,
      order: json['order'] as int? ?? 0,
    );
  }

  /// Convert to domain entity
  PropertyImageEntity toEntity() {
    return PropertyImageEntity(
      id: id,
      url: url,
      caption: caption,
      isPrimary: isPrimary,
      order: order,
    );
  }
}
