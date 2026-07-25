import 'package:equatable/equatable.dart';

abstract class DisputeState extends Equatable {
  const DisputeState();

  @override
  List<Object?> get props => [];
}

class DisputeInitial extends DisputeState {}

class DisputeSubmitting extends DisputeState {}

class DisputeSuccess extends DisputeState {}

class DisputeError extends DisputeState {
  final String message;
  const DisputeError(this.message);

  @override
  List<Object?> get props => [message];
}
