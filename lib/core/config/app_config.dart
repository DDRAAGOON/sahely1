import 'package:flutter/foundation.dart';

import 'package:sahely/core/config/app_env.dart';

class AppConfig {
  static const String appName = 'Sahely';
  static const String version = '1.0.0';

  /// Selected via: --dart-define=SAHELY_ENV=dev|staging|prod
  /// Defaults to dev so local `flutter run` works out of the box.
  static const String _env =
      String.fromEnvironment('SAHELY_ENV', defaultValue: 'dev');

  static AppEnvironment get environment {
    switch (_env) {
      case 'prod':
        return AppEnvironment.prod;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.dev;
    }
  }

  static EnvConfig get config {
    switch (environment) {
      case AppEnvironment.prod:
        return EnvConfig.prod;
      case AppEnvironment.staging:
        return EnvConfig.staging;
      case AppEnvironment.dev:
        return EnvConfig.dev;
    }
  }

  /// Verbose network logging must never run in release builds,
  /// even if a non-prod env config is used by mistake.
  static bool get enableLogs => kDebugMode && config.enableLogs;
}
