import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource localDataSource;
  final RenterRepository properties;

  SearchRepositoryImpl({
    required this.localDataSource,
    required this.properties,
  });

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

  /// The places and listing names people can search for, taken from the live
  /// listings: every area first, then the listing titles.
  @override
  Future<List<String>> getRawSuggestionData() async {
    try {
      final listings = await properties.getAllProperties();
      final areas = listings.map((p) => p.area.trim());
      final names = listings.map((p) => p.name.trim());
      return {...areas, ...names}.where((s) => s.isNotEmpty).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
