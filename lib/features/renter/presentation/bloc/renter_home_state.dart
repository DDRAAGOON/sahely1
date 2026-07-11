import 'package:equatable/equatable.dart';

abstract class RenterHomeState extends Equatable {
  const RenterHomeState();

  @override
  List<Object?> get props => [];
}

class RenterHomeInitial extends RenterHomeState {}

class RenterHomeLoading extends RenterHomeState {}

class RenterHomeLoaded extends RenterHomeState {
  final List<Map<String, dynamic>> properties;

  const RenterHomeLoaded(this.properties);

  @override
  List<Object?> get props => [properties];
}

class RenterHomeError extends RenterHomeState {
  final String message;

  const RenterHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
