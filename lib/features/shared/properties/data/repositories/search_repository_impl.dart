import 'package:sahely/core/errors/exception_mapper.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({required this.localDataSource});

  @override
  Future<List<String>> getRecentSearches() async {
    try {
      return await localDataSource.getRecentSearches();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> saveSearch(String query) async {
    try {
      await localDataSource.saveSearch(query);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    try {
      await localDataSource.clearRecentSearches();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<List<String>> getRawSuggestionData() async {
    try {
      // Fetches raw strings for compounds, locations etc. from API or Local
      return [
        'Marassi', 'Hacienda', 'Amwaj', 'Seashell', 'Telal', 'La Vista'
      ];
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
