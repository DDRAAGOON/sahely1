import '../entities/property.dart';
import '../entities/search_filter.dart';
import '../entities/search_constants.dart';

class FilterPropertiesUseCase {
  List<Property> execute(List<Property> properties, SearchFilter filter) {
    return properties.where((p) {
      if (filter.propertyType != null &&
          filter.propertyType != SearchConstants.all &&
          p.type != filter.propertyType) {
        return false;
      }

      if (p.price < filter.minPrice || p.price > filter.maxPrice) {
        return false;
      }

      if (filter.minBedrooms != null && p.beds < filter.minBedrooms!) {
        return false;
      }

      if (filter.amenities.isNotEmpty) {
        if (!filter.amenities.every((a) => p.tags.contains(a))) return false;
      }

      if (filter.petsAllowed && !p.petsOk) return false;

      if (filter.category != null && filter.category != SearchConstants.all) {
        if (!p.tags.contains(filter.category!)) return false;
      }

      if (filter.topRated && p.rating < 4.8) return false;

      return true;
    }).toList();
  }
}
