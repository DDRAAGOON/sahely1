import '../repositories/search_repository.dart';

class SaveSearchUseCase {
  final SearchRepository repository;
  SaveSearchUseCase(this.repository);

  Future<void> execute(String query) {
    if (query.trim().isEmpty) return Future.value();
    return repository.saveSearch(query);
  }
}
