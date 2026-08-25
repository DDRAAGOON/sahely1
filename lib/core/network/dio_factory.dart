import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:sahely/core/config/app_config.dart';
import 'package:sahely/core/config/app_env.dart';
import 'package:sahely/core/security/network/asset_certificate_provider.dart';
import 'package:sahely/core/security/network/ssl_pinning_service_impl.dart';
import 'api_endpoints.dart';
import 'dio_interceptors.dart';

class DioFactory {
  DioFactory._();

  static Dio? _instance;
  static Completer<void>? _pinningSetup;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${AppConfig.config.baseUrl}/${AppConfig.config.apiVersion}',
        receiveTimeout: const Duration(milliseconds: ApiEndpoints.receiveTimeout),
        connectTimeout: const Duration(milliseconds: ApiEndpoints.connectionTimeout),
        sendTimeout: const Duration(milliseconds: ApiEndpoints.connectionTimeout),
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);

    if (AppConfig.enableLogs) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

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
        final pinning =
            SSLPinningServiceImpl(AssetCertificateProvider(certificatePaths: certPaths));
        await pinning.initialize();
        if (pinning.allowedCertificates.isEmpty) return;

        dio.httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () => HttpClient()
            ..badCertificateCallback = (cert, host, port) =>
                pinning.validateCertificate(cert.der),
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
}
