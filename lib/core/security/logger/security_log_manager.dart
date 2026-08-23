import 'package:uuid/uuid.dart';
import 'security_log_entry.dart';
import 'security_logger.dart';

class SecurityLogManager {
  final List<SecurityLogger> _loggers = [];
  final _uuid = const Uuid();

  void addLogger(SecurityLogger logger) {
    _loggers.add(logger);
  }

  Future<void> log({
    required SecurityEventType eventType,
    required SecurityLogLevel level,
    required String message,
    Map<String, dynamic>? metadata,
    String? userId,
  }) async {
    // Sanitize metadata to ensure no sensitive data is logged
    final sanitizedMetadata = _sanitizeMetadata(metadata);

    final entry = SecurityLogEntry(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      eventType: eventType,
      level: level,
      message: message,
      metadata: sanitizedMetadata,
      userId: userId,
    );

    await Future.wait(_loggers.map((logger) => logger.log(entry)));
  }

  Map<String, dynamic>? _sanitizeMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return null;

    final sensitiveKeys = {
      'password', 'token', 'apiKey', 'api_key', 'secret', 'cvv', 'pin', 
      'access_token', 'refresh_token', 'auth', 'authorization'
    };

    final sanitized = Map<String, dynamic>.from(metadata);
    
    for (final key in sanitized.keys.toList()) {
      if (sensitiveKeys.any((s) => key.toLowerCase().contains(s))) {
        sanitized[key] = '[REDACTED]';
      } else if (sanitized[key] is Map<String, dynamic>) {
        sanitized[key] = _sanitizeMetadata(sanitized[key] as Map<String, dynamic>);
      }
    }

    return sanitized;
  }
}
