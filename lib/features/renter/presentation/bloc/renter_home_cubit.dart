import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/get_properties_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/get_trending_properties_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/search_properties_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/filter_properties_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/sort_properties_use_case.dart';

import 'package:sahely/features/renter/presentation/bloc/renter_home_state.dart';
import 'package:sahely/core/bloc/safe_emit.dart';

class RenterHomeCubit extends Cubit<RenterHomeState>
    with SafeEmit<RenterHomeState> {
  final GetPropertiesUseCase _getPropertiesUseCase;
  final GetTrendingPropertiesUseCase _getTrendingPropertiesUseCase;
  final SearchPropertiesUseCase _searchPropertiesUseCase;

  RenterHomeCubit({
    required GetPropertiesUseCase getPropertiesUseCase,
    required GetTrendingPropertiesUseCase getTrendingPropertiesUseCase,
    required SearchPropertiesUseCase searchPropertiesUseCase,
    required FilterPropertiesUseCase filterPropertiesUseCase,
    required SortPropertiesUseCase sortPropertiesUseCase,
  })  : _getPropertiesUseCase = getPropertiesUseCase,
        _getTrendingPropertiesUseCase = getTrendingPropertiesUseCase,
        _searchPropertiesUseCase = searchPropertiesUseCase,
        super(RenterHomeInitial());

  Future<void> loadProperties() async {
    emit(RenterHomeLoading());
    try {
      final properties = await _getPropertiesUseCase.execute();
      emit(RenterHomeLoaded(properties));
    } catch (e) {
      emit(RenterHomeError('Failed to load properties: $e'));
    }
  }

  List<Property> getTrending(List<Property> properties,
      {String category = 'All'}) {
    return _getTrendingPropertiesUseCase.execute(properties,
        category: category);
  }

  List<Property> search(List<Property> properties, String query) {
    return _searchPropertiesUseCase.execute(properties, query);
  }
}
