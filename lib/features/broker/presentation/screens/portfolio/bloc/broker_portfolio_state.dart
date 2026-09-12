import 'package:equatable/equatable.dart';
import 'package:sahely/features/broker/domain/entities/broker_portfolio.dart';

abstract class BrokerPortfolioState extends Equatable {
  const BrokerPortfolioState();

  @override
  List<Object?> get props => [];
}

class BrokerPortfolioInitial extends BrokerPortfolioState {}

class BrokerPortfolioLoading extends BrokerPortfolioState {}

class BrokerPortfolioLoaded extends BrokerPortfolioState {
  final BrokerPortfolio portfolio;

  const BrokerPortfolioLoaded(this.portfolio);

  @override
  List<Object?> get props => [portfolio];
}

class BrokerPortfolioError extends BrokerPortfolioState {
  final String message;

  const BrokerPortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
