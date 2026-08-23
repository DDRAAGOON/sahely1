import 'cache_entry.dart';

abstract class CacheService {
  Future<void> save<T>({
    required String key,
    required T data,
    Duration? ttl,
    String version = '1.0.0',
    required Map<String, dynamic> Function(T) toJson,
  });

  Future<CacheEntry<T>?> read<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<bool> exists(String key);

  Future<void> remove(String key);

  Future<void> clear();

  Future<void> clearAll();
}
