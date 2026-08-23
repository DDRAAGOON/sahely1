import 'package:equatable/equatable.dart';

enum SecurityEventType {
  loginAttempt,
  rootDetected,
  jailbreakDetected,
  debugDetected,
  sslFailure,
  encryptionFailure,
  secureStorageFailure,
  suspiciousActivity,
}

enum SecurityLogLevel {
  info,
  warning,
  critical,
}

class SecurityLogEntry extends Equatable {
  final String id;
  final DateTime timestamp;
  final SecurityEventType eventType;
  final SecurityLogLevel level;
  final String message;
  final Map<String, dynamic>? metadata;
  final String? userId;

  const SecurityLogEntry({
    required this.id,
    required this.timestamp,
    required this.eventType,
    required this.level,
    required this.message,
    this.metadata,
    this.userId,
  });

  @override
  List<Object?> get props => [id, timestamp, eventType, level, message, metadata, userId];
}
