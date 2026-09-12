import 'package:equatable/equatable.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

abstract class OwnerPropertiesState extends Equatable {
  const OwnerPropertiesState();

  @override
  List<Object?> get props => [];
}

class OwnerPropertiesInitial extends OwnerPropertiesState {}

class OwnerPropertiesLoading extends OwnerPropertiesState {}

class OwnerPropertiesLoaded extends OwnerPropertiesState {
  final List<Property> properties;

  const OwnerPropertiesLoaded(this.properties);

  @override
  List<Object?> get props => [properties];
}

class OwnerPropertiesError extends OwnerPropertiesState {
  final String message;

  const OwnerPropertiesError(this.message);

  @override
  List<Object?> get props => [message];
}
