import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sahely/features/broker/domain/use_cases/get_broker_portfolio_use_case.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/bloc/broker_portfolio_state.dart';
import 'package:sahely/core/bloc/safe_emit.dart';

/// Drives the broker's referred-properties page from `GET /broker/properties`.
class BrokerPortfolioCubit extends Cubit<BrokerPortfolioState>
    with SafeEmit<BrokerPortfolioState> {
  final GetBrokerPortfolioUseCase _getBrokerPortfolioUseCase;

  BrokerPortfolioCubit({
    required GetBrokerPortfolioUseCase getBrokerPortfolioUseCase,
  })  : _getBrokerPortfolioUseCase = getBrokerPortfolioUseCase,
        super(BrokerPortfolioInitial());

  Future<void> loadPortfolio() async {
    emit(BrokerPortfolioLoading());
    try {
      emit(BrokerPortfolioLoaded(await _getBrokerPortfolioUseCase.execute()));
    } catch (e) {
      emit(BrokerPortfolioError('Failed to load your portfolio: $e'));
    }
  }
}
