import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import 'package:sahely/core/config/app_config.dart';
import 'package:sahely/core/config/app_env.dart';
import 'package:sahely/core/security/network/asset_certificate_provider.dart';
import 'package:sahely/core/security/network/ssl_pinning_service_impl.dart';
import 'api_endpoints.dart';
import 'dio_interceptors.dart';
import 'interceptors/cache_interceptor.dart';
import 'interceptors/connectivity_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/refresh_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

class DioFactory {
  DioFactory._();

  static Dio? _instance;
  static CacheInterceptor? _cacheInterceptor;
  static Completer<void>? _pinningSetup;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  /// Exposes the cache interceptor so repositories can call invalidate().
  static CacheInterceptor get cache {
    _instance ??= _createDio();
    return _cacheInterceptor!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.config.apiBaseUrl,
        receiveTimeout:
            const Duration(milliseconds: ApiEndpoints.receiveTimeout),
        connectTimeout:
            const Duration(milliseconds: ApiEndpoints.connectionTimeout),
        sendTimeout:
            const Duration(milliseconds: ApiEndpoints.connectionTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-App-Version': AppConfig.version,
          'X-Platform': Platform.isIOS ? 'ios' : 'android',
        },
      ),
    );

    // Order matters:
    // 1. Connectivity — fail fast if offline
    // 2. Cache — serve cached GETs before hitting the network
    // 3. Auth — inject Bearer token
    // 4. Retry — retry transient failures
    // 5. Auto-refresh — handle 401 → refresh → retry
    // 6. Logging — log AFTER all transforms (debug only)

    final cacheInterceptor = CacheInterceptor(ttl: const Duration(minutes: 5));
    _cacheInterceptor = cacheInterceptor;

    dio.interceptors.addAll([
      ConnectivityInterceptor(),
      cacheInterceptor,
      AuthInterceptor(),
      RetryInterceptor(dio: dio),
      AutoRefreshInterceptor(dio: dio),
      if (kDebugMode) SahelyLoggingInterceptor(),
    ]);

    _configureSslPinning(dio);

    return dio;
  }

  /// Activates certificate pinning once pinned certificates are bundled
  /// under assets/certs/. Until then it fails open with the system
  /// trust store so development is never blocked.
  static void _configureSslPinning(Dio dio) {
    if (_pinningSetup != null) return;
    final completer = Completer<void>();
    _pinningSetup = completer;

    () async {
      try {
        final certPaths = switch (AppConfig.environment) {
          AppEnvironment.staging => ['assets/certs/staging_cert.pem'],
          AppEnvironment.prod => ['assets/certs/prod_cert.pem'],
          AppEnvironment.dev => ['assets/certs/dev_cert.pem'],
        };
        final pinning = SSLPinningServiceImpl(
            AssetCertificateProvider(certificatePaths: certPaths));
        await pinning.initialize();
        if (pinning.allowedCertificates.isEmpty) return;

        dio.httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () => HttpClient()
            ..badCertificateCallback =
                (cert, host, port) => pinning.validateCertificate(cert.der),
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[SECURITY] SSL pinning inactive: $e');
        }
      } finally {
        completer.complete();
      }
    }();
  }

  /// Reset the singleton (useful in tests).
  static void reset() {
    _instance = null;
    _cacheInterceptor = null;
    _pinningSetup = null;
  }
}
