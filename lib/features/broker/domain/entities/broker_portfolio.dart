import 'package:equatable/equatable.dart';
import '../../../shared/properties/domain/entities/property.dart';

class BrokerPortfolio extends Equatable {
  final int totalCount;
  final int activeCount;
  final int notListedCount;
  final List<Property> properties;

  const BrokerPortfolio({
    required this.totalCount,
    required this.activeCount,
    required this.notListedCount,
    required this.properties,
  });

  @override
  List<Object?> get props =>
      [totalCount, activeCount, notListedCount, properties];
}
