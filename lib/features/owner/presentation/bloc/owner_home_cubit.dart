import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';

import 'owner_home_state.dart';

class OwnerHomeCubit extends Cubit<OwnerHomeState> {
  final OwnerRepository repository;

  OwnerHomeCubit({required this.repository}) : super(OwnerHomeInitial());

  Future<void> loadDashboard() async {
    emit(OwnerHomeLoading());
    try {
      final dashboard = await repository.getOwnerDashboard();
      emit(OwnerHomeLoaded(dashboard));
    } catch (e) {
      emit(OwnerHomeError('Failed to load owner dashboard: $e'));
    }
  }
}
