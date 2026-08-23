abstract class SearchRepository {
  Future<List<String>> getRecentSearches();
  Future<void> saveSearch(String query);
  Future<void> clearRecentSearches();
  Future<List<String>> getRawSuggestionData();
}
