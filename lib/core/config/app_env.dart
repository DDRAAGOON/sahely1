enum AppEnvironment { dev, staging, prod }

class EnvConfig {
  final AppEnvironment environment;
  final String baseUrl;
  final String apiVersion;
  final String appName;
  final bool enableLogs;
  final bool enableCrashReporting;

  const EnvConfig({
    required this.environment,
    required this.baseUrl,
    required this.apiVersion,
    required this.appName,
    required this.enableLogs,
    required this.enableCrashReporting,
  });

  static EnvConfig dev = const EnvConfig(
    environment: AppEnvironment.dev,
    baseUrl: 'https://dev-api.sahely.com',
    apiVersion: 'v1',
    appName: 'Sahely (Dev)',
    enableLogs: true,
    enableCrashReporting: false,
  );

  static EnvConfig staging = const EnvConfig(
    environment: AppEnvironment.staging,
    baseUrl: 'https://staging-api.sahely.com',
    apiVersion: 'v1',
    appName: 'Sahely (Staging)',
    enableLogs: true,
    enableCrashReporting: true,
  );

  static EnvConfig prod = const EnvConfig(
    environment: AppEnvironment.prod,
    baseUrl: 'https://api.sahely.com',
    apiVersion: 'v1',
    appName: 'Sahely',
    enableLogs: false,
    enableCrashReporting: true,
  );
}
