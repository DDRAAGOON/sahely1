import '../entities/property.dart';
import '../entities/sort_type.dart';

class SortPropertiesUseCase {
  List<Property> execute(List<Property> properties, SortType sortType) {
    final results = List<Property>.from(properties);
    
    switch (sortType) {
      case SortType.priceLowToHigh:
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceHighToLow:
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.ratingHighToLow:
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortType.newest:
        // Mock newest by ID or added date if exists
        results.sort((a, b) => b.id.compareTo(a.id));
        break;
      case SortType.none:
        break;
    }
    
    return results;
  }
}
