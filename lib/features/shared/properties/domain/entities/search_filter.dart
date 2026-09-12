import 'package:equatable/equatable.dart';

class SearchFilter extends Equatable {
  final String? propertyType;
  final double minPrice;
  final double maxPrice;
  final int? minBedrooms;
  final List<String> amenities;
  final bool petsAllowed;
  final String? category;
  final bool isNew;
  final bool topRated;

  const SearchFilter({
    this.propertyType,
    this.minPrice = 0.0,
    this.maxPrice = 1000000.0,
    this.minBedrooms,
    this.amenities = const [],
    this.petsAllowed = false,
    this.category,
    this.isNew = false,
    this.topRated = false,
  });

  factory SearchFilter.fromMap(Map<String, dynamic> map) {
    return SearchFilter(
      propertyType: map['propertyType'] ?? map['type'],
      minPrice: (map['minPrice'] ?? 0.0).toDouble(),
      maxPrice: (map['maxPrice'] ?? 1000000.0).toDouble(),
      minBedrooms: map['minBedrooms'] is int
          ? map['minBedrooms']
          : (map['bedrooms'] != null
              ? int.tryParse(map['bedrooms'].toString().replaceAll('+', ''))
              : null),
      amenities: List<String>.from(map['amenities'] ?? []),
      petsAllowed: map['petsAllowed'] ??
          (map['rules']?.contains('Pets allowed') ?? false),
      category: map['category'] ?? map['location'],
      isNew: map['isNew'] ?? false,
      topRated: map['topRated'] ?? false,
    );
  }

  SearchFilter copyWith({
    String? propertyType,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    List<String>? amenities,
    bool? petsAllowed,
    String? category,
    bool? isNew,
    bool? topRated,
  }) {
    return SearchFilter(
      propertyType: propertyType ?? this.propertyType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minBedrooms: minBedrooms ?? this.minBedrooms,
      amenities: amenities ?? this.amenities,
      petsAllowed: petsAllowed ?? this.petsAllowed,
      category: category ?? this.category,
      isNew: isNew ?? this.isNew,
      topRated: topRated ?? this.topRated,
    );
  }

  @override
  List<Object?> get props => [
        propertyType,
        minPrice,
        maxPrice,
        minBedrooms,
        amenities,
        petsAllowed,
        category,
        isNew,
        topRated,
      ];
}
