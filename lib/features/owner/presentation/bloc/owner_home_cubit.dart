import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/owner/domain/use_cases/get_owner_dashboard_use_case.dart';

import 'package:sahely/features/owner/presentation/bloc/owner_home_state.dart';

class OwnerHomeCubit extends Cubit<OwnerHomeState> {
  final GetOwnerDashboardUseCase _getOwnerDashboardUseCase;

  OwnerHomeCubit({required GetOwnerDashboardUseCase getOwnerDashboardUseCase})
      : _getOwnerDashboardUseCase = getOwnerDashboardUseCase,
        super(OwnerHomeInitial());

  Future<void> loadDashboard() async {
    emit(OwnerHomeLoading());
    try {
      final dashboard = await _getOwnerDashboardUseCase.execute();
      emit(OwnerHomeLoaded(dashboard));
    } catch (e) {
      emit(OwnerHomeError('Failed to load owner dashboard: $e'));
    }
  }
}
