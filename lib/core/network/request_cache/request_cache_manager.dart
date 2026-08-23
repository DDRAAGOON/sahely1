import '../../storage/cache/cache_service.dart';
import '../../storage/cache/cache_result.dart';
import 'request_cache_policy.dart';
import '../../errors/failures.dart';

class RequestCacheManager {
  final CacheService _cacheService;

  RequestCacheManager(this._cacheService);

  Future<CacheResult<T>> execute<T>({
    required String key,
    required Future<T> Function() remoteCall,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    RequestCachePolicy policy = RequestCachePolicy.cacheFirst,
    Duration? ttl,
    String version = '1.0.0',
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      return _fetchRemoteAndSave(key, remoteCall, toJson, ttl, version);
    }

    switch (policy) {
      case RequestCachePolicy.noCache:
        return _fetchRemoteOnly(remoteCall);

      case RequestCachePolicy.networkOnly:
        return _fetchRemoteAndSave(key, remoteCall, toJson, ttl, version);

      case RequestCachePolicy.cacheOnly:
        return _readFromCache(key, fromJson);

      case RequestCachePolicy.cacheFirst:
        final cached = await _readFromCache(key, fromJson);
        if (cached.isSuccess) return cached;
        return _fetchRemoteAndSave(key, remoteCall, toJson, ttl, version);

      case RequestCachePolicy.networkFirst:
        try {
          return await _fetchRemoteAndSave(key, remoteCall, toJson, ttl, version);
        } catch (e) {
          return _readFromCache(key, fromJson);
        }

      case RequestCachePolicy.staleWhileRevalidate:
        final cached = await _readFromCache(key, fromJson);
        // Trigger background update
        _fetchRemoteAndSave(key, remoteCall, toJson, ttl, version).ignore();
        
        if (cached.isSuccess) return cached;
        return _fetchRemoteAndSave(key, remoteCall, toJson, ttl, version);
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
      return CacheResult.failure(const CacheFailure('Cache miss or expired'));
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

  Future<CacheResult<T>> _fetchRemoteOnly<T>(Future<T> Function() remoteCall) async {
    try {
      final data = await remoteCall();
      return CacheResult.success(data);
    } catch (e) {
      return CacheResult.failure(CacheFailure(e.toString()));
    }
  }

  Future<void> clearAll() => _cacheService.clearAll();
  
  Future<void> invalidate(String key) => _cacheService.remove(key);
}
