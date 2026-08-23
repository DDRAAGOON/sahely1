import '../../domain/entities/search_filter.dart';

class SearchFilterDto {
  static SearchFilter fromMap(Map<String, dynamic> map) {
    return SearchFilter(
      propertyType: map['propertyType'] ?? map['type'],
      minPrice: (map['minPrice'] ?? 0.0).toDouble(),
      maxPrice: (map['maxPrice'] ?? 1000000.0).toDouble(),
      minBedrooms: map['minBedrooms'] is int 
          ? map['minBedrooms'] 
          : (map['bedrooms'] != null ? int.tryParse(map['bedrooms'].toString().replaceAll('+', '')) : null),
      amenities: List<String>.from(map['amenities'] ?? []),
      petsAllowed: map['petsAllowed'] ?? (map['rules']?.contains('Pets allowed') ?? false),
      category: map['category'] ?? map['location'],
      isNew: map['isNew'] ?? false,
      topRated: map['topRated'] ?? false,
    );
  }
}
