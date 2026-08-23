import 'package:sahely/core/config/app_env.dart';

class AppConfig {
  static const String appName = 'Sahely';
  static const String version = '1.0.0';
  static const bool debugMode = true;

  static EnvConfig get config => EnvConfig.dev;
}
