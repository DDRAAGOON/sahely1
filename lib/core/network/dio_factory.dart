import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sahely/core/config/app_config.dart';
import 'api_endpoints.dart';
import 'dio_interceptors.dart';

class DioFactory {
  DioFactory._();

  static Dio? _instance;

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

    if (AppConfig.config.enableLogs) {
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

    return dio;
  }
}
