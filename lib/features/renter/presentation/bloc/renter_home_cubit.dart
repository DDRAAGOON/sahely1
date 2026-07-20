import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';

import 'renter_home_state.dart';

class RenterHomeCubit extends Cubit<RenterHomeState> {
  final RenterRepository repository;

  RenterHomeCubit({required this.repository}) : super(RenterHomeInitial());

  Future<void> loadProperties() async {
    emit(RenterHomeLoading());
    try {
      final properties = await repository.getAllProperties();
      emit(RenterHomeLoaded(properties));
    } catch (e) {
      emit(RenterHomeError('Failed to load properties: $e'));
    }
  }
}
