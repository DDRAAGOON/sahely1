import '../repositories/search_repository.dart';

class RecentSearchesUseCase {
  final SearchRepository repository;
  RecentSearchesUseCase(this.repository);

  Future<List<String>> execute() {
    return repository.getRecentSearches();
  }
}
