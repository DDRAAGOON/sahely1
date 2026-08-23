import '../entities/property.dart';

class SearchPropertiesUseCase {
  List<Property> execute(List<Property> properties, String query) {
    if (query.isEmpty) return properties;
    final lowercaseQuery = query.toLowerCase();
    return properties.where((p) =>
      p.name.toLowerCase().contains(lowercaseQuery) ||
      p.area.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
}
