import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/get_properties_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/search_properties_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/filter_properties_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/sort_properties_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/search_suggestions_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/recent_searches_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/clear_recent_searches_use_case.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/save_search_use_case.dart';
import 'search_state.dart';
import 'package:sahely/core/bloc/safe_emit.dart';

class SearchCubit extends Cubit<SearchState> with SafeEmit<SearchState> {
  final GetPropertiesUseCase _getPropertiesUseCase;
  final SearchPropertiesUseCase _searchPropertiesUseCase;
  final FilterPropertiesUseCase _filterPropertiesUseCase;
  final SortPropertiesUseCase _sortPropertiesUseCase;
  final SearchSuggestionsUseCase _searchSuggestionsUseCase;
  final RecentSearchesUseCase _recentSearchesUseCase;
  final ClearRecentSearchesUseCase _clearRecentSearchesUseCase;

  Timer? _debounce;

  SearchCubit({
    required GetPropertiesUseCase getPropertiesUseCase,
    required SearchPropertiesUseCase searchPropertiesUseCase,
    required FilterPropertiesUseCase filterPropertiesUseCase,
    required SortPropertiesUseCase sortPropertiesUseCase,
    required SearchSuggestionsUseCase searchSuggestionsUseCase,
    required RecentSearchesUseCase recentSearchesUseCase,
    required ClearRecentSearchesUseCase clearRecentSearchesUseCase,
    required SaveSearchUseCase saveSearchUseCase,
  })  : _getPropertiesUseCase = getPropertiesUseCase,
        _searchPropertiesUseCase = searchPropertiesUseCase,
        _filterPropertiesUseCase = filterPropertiesUseCase,
        _sortPropertiesUseCase = sortPropertiesUseCase,
        _searchSuggestionsUseCase = searchSuggestionsUseCase,
        _recentSearchesUseCase = recentSearchesUseCase,
        _clearRecentSearchesUseCase = clearRecentSearchesUseCase,
        super(const SearchState());

  Future<void> init() async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final properties = await _getPropertiesUseCase.execute();
      final recent = await _recentSearchesUseCase.execute();
      emit(state.copyWith(
        allProperties: properties,
        filteredResults: properties,
        recentSearches: recent,
        status: SearchStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: SearchStatus.error, errorMessage: e.toString()));
    }
  }

  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final suggestions = await _searchSuggestionsUseCase.execute(query);
      emit(state.copyWith(query: query, suggestions: suggestions));
      _applySearchAndFilter();
    });
  }

  void _applySearchAndFilter() {
    var results =
        _searchPropertiesUseCase.execute(state.allProperties, state.query);
    results = _filterPropertiesUseCase.execute(results, state.filter);
    results = _sortPropertiesUseCase.execute(results, state.sortType);
    emit(state.copyWith(filteredResults: results));
  }

  Future<void> clearRecent() async {
    await _clearRecentSearchesUseCase.execute();
    emit(state.copyWith(recentSearches: []));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
