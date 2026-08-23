import 'cache_service.dart';
import 'cache_policy.dart';
import 'cache_result.dart';
import '../../errors/failures.dart';

class CacheManager {
  final CacheService _cacheService;

  CacheManager(this._cacheService);

  Future<CacheResult<T>> handle<T>({
    required String key,
    required Future<T> Function() remoteCall,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    CachePolicy policy = CachePolicy.cacheFirst,
    Duration? ttl,
    String version = '1.0.0',
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      return _fetchRemoteAndSave(key, remoteCall, toJson, ttl, version);
    }

    switch (policy) {
      case CachePolicy.noCache:
        try {
          final data = await remoteCall();
          return CacheResult.success(data);
        } catch (e) {
          return CacheResult.failure(CacheFailure(e.toString()));
        }

      case CachePolicy.cacheOnly:
        return _readFromCache(key, fromJson);

      case CachePolicy.cacheFirst:
        final cached = await _readFromCache(key, fromJson);
        if (cached.isSuccess) return cached;
        return _fetchRemoteAndSave(key, remoteCall, toJson, ttl, version);

      case CachePolicy.remoteFirst:
        try {
          return await _fetchRemoteAndSave(key, remoteCall, toJson, ttl, version);
        } catch (e) {
          return _readFromCache(key, fromJson);
        }

      case CachePolicy.cacheAndRemote:
        // This policy usually requires a Stream or multiple callbacks.
        // For simplicity in this generic implementation, we'll return cache first if available.
        final cached = await _readFromCache(key, fromJson);
        // Note: The caller should trigger a background update separately if needed.
        return cached;
    }
  }

  Future<CacheResult<T>> _readFromCache<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final entry = await _cacheService.read<T>(key: key, fromJson: fromJson);
      if (entry != null && !entry.isExpired) {
        return CacheResult.success(entry.data, isFromCache: true);
      }
      return CacheResult.failure(const CacheFailure('Cache missed or expired'));
    } catch (e) {
      return CacheResult.failure(CacheFailure(e.toString()));
    }
  }

  Future<CacheResult<T>> _fetchRemoteAndSave<T>(
    String key,
    Future<T> Function() remoteCall,
    Map<String, dynamic> Function(T) toJson,
    Duration? ttl,
    String version,
  ) async {
    try {
      final data = await remoteCall();
      await _cacheService.save(
        key: key,
        data: data,
        ttl: ttl,
        version: version,
        toJson: toJson,
      );
      return CacheResult.success(data);
    } catch (e) {
      return CacheResult.failure(CacheFailure(e.toString()));
    }
  }

  Future<void> clearAll() => _cacheService.clearAll();
}
