import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Simple in-memory cache for GET requests with a configurable TTL.
///
/// Only GET requests are cached. Cache is keyed by the full URL including
/// query parameters. Cache is bypassed for authenticated mutations.
class CacheInterceptor extends Interceptor {
  final Duration ttl;
  final _cache = <String, _CacheEntry>{};

  CacheInterceptor({this.ttl = const Duration(minutes: 5)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only cache GETs; skip if explicitly disabled via extra
    if (options.method.toUpperCase() != 'GET' ||
        options.extra['noCache'] == true) {
      return handler.next(options);
    }

    final key = _cacheKey(options);
    final entry = _cache[key];

    if (entry != null && !entry.isExpired) {
      if (kDebugMode) {
        debugPrint('[SAHELY-CACHE] 💾 HIT: ${options.path}');
      }
      return handler.resolve(
        Response(
          requestOptions: options,
          data: entry.data,
          statusCode: 200,
          statusMessage: 'OK (cached)',
        ),
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.requestOptions.extra['noCache'] != true &&
        response.statusCode == 200) {
      final key = _cacheKey(response.requestOptions);
      _cache[key] = _CacheEntry(data: response.data, ttl: ttl);

      if (kDebugMode) {
        debugPrint('[SAHELY-CACHE] 💾 STORED: ${response.requestOptions.path}');
      }
    }
    handler.next(response);
  }

  /// Invalidate all cached entries (call on logout / role switch).
  void invalidateAll() => _cache.clear();

  /// Invalidate a specific URL pattern.
  void invalidate(String pathPattern) {
    _cache.removeWhere((key, _) => key.contains(pathPattern));
  }

  String _cacheKey(RequestOptions options) {
    final params = options.queryParameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '${options.baseUrl}${options.path}?$params';
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime _expiresAt;

  _CacheEntry({required this.data, required Duration ttl})
      : _expiresAt = DateTime.now().add(ttl);

  bool get isExpired => DateTime.now().isAfter(_expiresAt);
}
