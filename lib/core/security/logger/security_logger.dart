import 'security_log_entry.dart';

abstract class SecurityLogger {
  Future<void> log(SecurityLogEntry entry);
}
