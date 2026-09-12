import 'dart:developer' as developer;
import 'security_logger.dart';
import 'security_log_entry.dart';

class ConsoleSecurityLogger implements SecurityLogger {
  @override
  Future<void> log(SecurityLogEntry entry) async {
    final logMessage =
        '[SECURITY] [${entry.level.name.toUpperCase()}] [${entry.eventType.name}] ${entry.message} ${entry.metadata ?? ''}';

    developer.log(
      logMessage,
      name: 'security.logger',
      time: entry.timestamp,
      level: _mapLevelToDeveloperLevel(entry.level),
    );
  }

  int _mapLevelToDeveloperLevel(SecurityLogLevel level) {
    switch (level) {
      case SecurityLogLevel.info:
        return 0;
      case SecurityLogLevel.warning:
        return 900;
      case SecurityLogLevel.critical:
        return 1000;
    }
  }
}
