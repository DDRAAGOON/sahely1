import 'package:equatable/equatable.dart';
import '../../../shared/properties/data/models/property_dto.dart';
import '../../domain/entities/owner_dashboard.dart';

class OwnerDashboardDto extends Equatable {
  final String ownerName;
  final int propertiesCount;
  final int bookingsCount;
  final String monthlyEarnings;
  final List<PropertyDto> trendingProperties;

  const OwnerDashboardDto({
    required this.ownerName,
    required this.propertiesCount,
    required this.bookingsCount,
    required this.monthlyEarnings,
    required this.trendingProperties,
  });

  factory OwnerDashboardDto.fromJson(Map<String, dynamic> json) {
    return OwnerDashboardDto(
      ownerName: json['ownerName'] as String,
      propertiesCount: json['propertiesCount'] as int,
      bookingsCount: json['bookingsCount'] as int,
      monthlyEarnings: json['monthlyEarnings'] as String,
      trendingProperties: (json['trendingProperties'] as List)
          .map((e) => PropertyDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerName': ownerName,
      'propertiesCount': propertiesCount,
      'bookingsCount': bookingsCount,
      'monthlyEarnings': monthlyEarnings,
      'trendingProperties': trendingProperties.map((e) => e.toJson()).toList(),
    };
  }

  OwnerDashboard toEntity() {
    return OwnerDashboard(
      ownerName: ownerName,
      propertiesCount: propertiesCount,
      bookingsCount: bookingsCount,
      monthlyEarnings: monthlyEarnings,
      trendingProperties: trendingProperties.map((e) => e.toEntity()).toList(),
    );
  }

  factory OwnerDashboardDto.fromEntity(OwnerDashboard entity) {
    return OwnerDashboardDto(
      ownerName: entity.ownerName,
      propertiesCount: entity.propertiesCount,
      bookingsCount: entity.bookingsCount,
      monthlyEarnings: entity.monthlyEarnings,
      trendingProperties: entity.trendingProperties
          .map((e) => PropertyDto.fromEntity(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        ownerName,
        propertiesCount,
        bookingsCount,
        monthlyEarnings,
        trendingProperties,
      ];
}
