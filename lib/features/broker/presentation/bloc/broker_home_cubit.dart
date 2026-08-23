import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/broker/domain/use_cases/get_broker_dashboard_use_case.dart';

import 'package:sahely/features/broker/presentation/bloc/broker_home_state.dart';

class BrokerHomeCubit extends Cubit<BrokerHomeState> {
  final GetBrokerDashboardUseCase _getBrokerDashboardUseCase;

  BrokerHomeCubit({required GetBrokerDashboardUseCase getBrokerDashboardUseCase})
      : _getBrokerDashboardUseCase = getBrokerDashboardUseCase,
        super(BrokerHomeInitial());

  Future<void> loadDashboard() async {
    emit(BrokerHomeLoading());
    try {
      final dashboard = await _getBrokerDashboardUseCase.execute();
      emit(BrokerHomeLoaded(dashboard));
    } catch (e) {
      emit(BrokerHomeError('Failed to load dashboard: $e'));
    }
  }
}
