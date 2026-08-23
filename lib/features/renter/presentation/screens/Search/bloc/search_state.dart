import 'package:equatable/equatable.dart';
import '../../../../../shared/properties/domain/entities/property.dart';
import '../../../../../shared/properties/domain/entities/search_filter.dart';
import '../../../../../shared/properties/domain/entities/sort_type.dart';

enum SearchStatus { initial, loading, success, error }

class SearchState extends Equatable {
  final List<Property> allProperties;
  final List<Property> filteredResults;
  final List<String> recentSearches;
  final List<String> suggestions;
  final SearchStatus status;
  final String errorMessage;
  final String query;
  final SearchFilter filter;
  final SortType sortType;

  const SearchState({
    this.allProperties = const [],
    this.filteredResults = const [],
    this.recentSearches = const [],
    this.suggestions = const [],
    this.status = SearchStatus.initial,
    this.errorMessage = '',
    this.query = '',
    this.filter = const SearchFilter(),
    this.sortType = SortType.ratingHighToLow,
  });

  SearchState copyWith({
    List<Property>? allProperties,
    List<Property>? filteredResults,
    List<String>? recentSearches,
    List<String>? suggestions,
    SearchStatus? status,
    String? errorMessage,
    String? query,
    SearchFilter? filter,
    SortType? sortType,
  }) {
    return SearchState(
      allProperties: allProperties ?? this.allProperties,
      filteredResults: filteredResults ?? this.filteredResults,
      recentSearches: recentSearches ?? this.recentSearches,
      suggestions: suggestions ?? this.suggestions,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      sortType: sortType ?? this.sortType,
    );
  }

  @override
  List<Object?> get props => [
        allProperties,
        filteredResults,
        recentSearches,
        suggestions,
        status,
        errorMessage,
        query,
        filter,
        sortType,
      ];
}
