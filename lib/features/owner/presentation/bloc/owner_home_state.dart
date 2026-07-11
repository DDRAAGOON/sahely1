import 'package:equatable/equatable.dart';
import 'package:sahely/features/owner/domain/entities/owner_dashboard.dart';

abstract class OwnerHomeState extends Equatable {
  const OwnerHomeState();

  @override
  List<Object?> get props => [];
}

class OwnerHomeInitial extends OwnerHomeState {}

class OwnerHomeLoading extends OwnerHomeState {}

class OwnerHomeLoaded extends OwnerHomeState {
  final OwnerDashboard dashboard;

  const OwnerHomeLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class OwnerHomeError extends OwnerHomeState {
  final String message;

  const OwnerHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
