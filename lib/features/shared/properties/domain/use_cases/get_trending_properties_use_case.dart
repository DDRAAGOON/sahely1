import '../entities/property.dart';

class GetTrendingPropertiesUseCase {
  List<Property> execute(List<Property> properties, {String category = 'All'}) {
    if (category == 'All') {
      return properties.take(10).toList();
    }
    
    return properties.where((p) {
      if (category == 'Pool') return p.tags.contains('Pool');
      if (category == 'Beachfront') return p.tags.contains('Beachfront');
      return true;
    }).toList();
  }
}
