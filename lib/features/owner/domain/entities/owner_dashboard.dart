import 'package:sahely/features/shared/properties/domain/entities/property.dart';

class OwnerDashboard {
  final String ownerName;
  final int propertiesCount;

  /// Listings currently live for guests.
  final int activePropertiesCount;
  final int bookingsCount;
  final String monthlyEarnings;
  final List<Property> trendingProperties;

  const OwnerDashboard({
    required this.ownerName,
    required this.propertiesCount,
    this.activePropertiesCount = 0,
    required this.bookingsCount,
    required this.monthlyEarnings,
    required this.trendingProperties,
  });
}
