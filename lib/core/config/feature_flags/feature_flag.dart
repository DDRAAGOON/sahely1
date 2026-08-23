import 'package:equatable/equatable.dart';

enum FeatureGroup {
  auth,
  renter,
  owner,
  broker,
  shared,
  experimental,
}

class FeatureFlag extends Equatable {
  final String key;
  final bool defaultValue;
  final FeatureGroup group;
  final String description;

  const FeatureFlag({
    required this.key,
    this.defaultValue = false,
    this.group = FeatureGroup.shared,
    this.description = '',
  });

  @override
  List<Object?> get props => [key, defaultValue, group, description];
}
