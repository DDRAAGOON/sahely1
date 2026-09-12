import '../repositories/search_repository.dart';

class SearchSuggestionsUseCase {
  final SearchRepository repository;
  SearchSuggestionsUseCase(this.repository);

  Future<List<String>> execute(String query) async {
    if (query.isEmpty) return [];

    final rawData = await repository.getRawSuggestionData();
    final lowercaseQuery = query.toLowerCase();

    return rawData
        .where((item) => item.toLowerCase().contains(lowercaseQuery))
        .toList();
  }
}
