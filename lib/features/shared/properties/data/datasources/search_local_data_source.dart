abstract class SearchLocalDataSource {
  Future<List<String>> getRecentSearches();
  Future<void> saveSearch(String query);
  Future<void> clearRecentSearches();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  // Real implementation would use SharedPreferences
  final List<String> _cache = [];

  @override
  Future<List<String>> getRecentSearches() async {
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> saveSearch(String query) async {
    if (query.isEmpty) return;
    _cache.remove(query);
    _cache.insert(0, query);
    if (_cache.length > 10) _cache.removeLast();
  }

  @override
  Future<void> clearRecentSearches() async {
    _cache.clear();
  }
}
