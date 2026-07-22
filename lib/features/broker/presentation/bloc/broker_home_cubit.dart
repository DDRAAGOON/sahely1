import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/broker/domain/repositories/broker_repository.dart';

import 'package:sahely/features/broker/presentation/bloc/broker_home_state.dart';

class BrokerHomeCubit extends Cubit<BrokerHomeState> {
  final BrokerRepository repository;

  BrokerHomeCubit({required this.repository}) : super(BrokerHomeInitial());

  Future<void> loadDashboard() async {
    emit(BrokerHomeLoading());
    try {
      final dashboard = await repository.getBrokerDashboardData();
      emit(BrokerHomeLoaded(dashboard));
    } catch (e) {
      emit(BrokerHomeError('Failed to load dashboard: $e'));
    }
  }
}
