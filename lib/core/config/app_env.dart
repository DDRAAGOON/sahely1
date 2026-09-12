enum AppEnvironment { dev, staging, prod }

class EnvConfig {
  final AppEnvironment environment;
  final String baseUrl;

  /// Path segment appended to [baseUrl] to reach the REST API.
  ///
  /// The written API guide says `{ENV_BASE_URL}/api`, but the deployed backend
  /// actually serves `/api/v1` (`/api/...` answers 404), so that is the
  /// default. Override per build with:
  /// `--dart-define=SAHELY_API_PREFIX=api`
  final String apiPrefix;

  final String appName;
  final bool enableLogs;
  final bool enableCrashReporting;

  const EnvConfig({
    required this.environment,
    required this.baseUrl,
    required this.apiPrefix,
    required this.appName,
    required this.enableLogs,
    required this.enableCrashReporting,
  });

  /// Fully qualified API root, e.g. `https://api.sahely.com/api`.
  String get apiBaseUrl {
    final root = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final prefix =
        apiPrefix.startsWith('/') ? apiPrefix.substring(1) : apiPrefix;
    return prefix.isEmpty ? root : '$root/$prefix';
  }

  static const String _prefixOverride =
      String.fromEnvironment('SAHELY_API_PREFIX', defaultValue: 'api/v1');

  static const EnvConfig dev = EnvConfig(
    environment: AppEnvironment.dev,
    // Deployed dev backend. For a local NestJS instance use
    // 'http://10.0.2.2:43000' (Android emulator) or the LAN IP on a device.
    baseUrl: 'https://apisahely.staysahely.com',
    apiPrefix: _prefixOverride,
    appName: 'Sahely (Dev)',
    enableLogs: true,
    enableCrashReporting: false,
  );

  static const EnvConfig staging = EnvConfig(
    environment: AppEnvironment.staging,
    baseUrl: 'https://apisahely.staysahely.com',
    apiPrefix: _prefixOverride,
    appName: 'Sahely (Staging)',
    enableLogs: true,
    enableCrashReporting: true,
  );

  static const EnvConfig prod = EnvConfig(
    environment: AppEnvironment.prod,
    baseUrl: 'https://api.sahely.com',
    apiPrefix: _prefixOverride,
    appName: 'Sahely',
    enableLogs: false,
    enableCrashReporting: true,
  );
}
