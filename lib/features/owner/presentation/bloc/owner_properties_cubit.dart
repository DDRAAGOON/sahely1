import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_properties_state.dart';
import 'package:sahely/core/bloc/safe_emit.dart';

/// Drives the owner's "My Properties" list from `GET /properties/mine`.
class OwnerPropertiesCubit extends Cubit<OwnerPropertiesState>
    with SafeEmit<OwnerPropertiesState> {
  final OwnerRepository _repository;

  OwnerPropertiesCubit({required OwnerRepository repository})
      : _repository = repository,
        super(OwnerPropertiesInitial());

  Future<void> loadProperties() async {
    emit(OwnerPropertiesLoading());
    try {
      emit(OwnerPropertiesLoaded(await _repository.getMyProperties()));
    } catch (e) {
      emit(OwnerPropertiesError('Failed to load your properties: $e'));
    }
  }

  /// Deletes a listing, then removes it locally so the list updates without a
  /// second round trip. A failed delete leaves the list untouched and surfaces
  /// the error rather than pretending the property is gone.
  Future<void> deleteProperty(String propertyId) async {
    final current = state;
    if (current is! OwnerPropertiesLoaded) return;

    try {
      await _repository.deleteProperty(propertyId);
      emit(
        OwnerPropertiesLoaded(
          current.properties.where((p) => p.id != propertyId).toList(),
        ),
      );
    } catch (e) {
      emit(OwnerPropertiesError('Could not delete the property: $e'));
      emit(current);
    }
  }
}
