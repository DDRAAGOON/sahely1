import 'package:sahely/features/shared/properties/domain/entities/property.dart';

abstract class RenterRepository {
  Future<List<Property>> getAllProperties();
}
