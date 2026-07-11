import 'package:equatable/equatable.dart';
import 'package:sahely/features/broker/domain/entities/broker_dashboard.dart';

abstract class BrokerHomeState extends Equatable {
  const BrokerHomeState();

  @override
  List<Object?> get props => [];
}

class BrokerHomeInitial extends BrokerHomeState {}

class BrokerHomeLoading extends BrokerHomeState {}

class BrokerHomeLoaded extends BrokerHomeState {
  final BrokerDashboard dashboard;

  const BrokerHomeLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class BrokerHomeError extends BrokerHomeState {
  final String message;

  const BrokerHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
