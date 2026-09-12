import 'dart:typed_data';
import 'storage/secure_storage_manager.dart';
import 'encryption/encryption_manager.dart';
import 'device/device_security_manager.dart';
import 'network/network_security_manager.dart';
import 'logger/security_log_manager.dart';
import 'logger/security_log_entry.dart';

class SecurityManager {
  final SecureStorageManager storage;
  final EncryptionManager encryption;
  final DeviceSecurityManager device;
  final NetworkSecurityManager network;
  final SecurityLogManager logger;

  SecurityManager({
    required this.storage,
    required this.encryption,
    required this.device,
    required this.network,
    required this.logger,
  });

  /// Orchestrated Initialization
  Future<void> initialize() async {
    try {
      await network.initialize();

      final isSecure = await device.isDeviceSecure();
      if (!isSecure) {
        await logger.log(
          eventType: SecurityEventType.suspiciousActivity,
          level: SecurityLogLevel.warning,
          message: 'Application starting on insecure device',
          metadata: {
            'isRooted': await device.isRooted(),
            'isEmulator': await device.isEmulator(),
            'isDeveloperMode': await device.isDeveloperMode(),
          },
        );
      }
    } catch (e) {
      await logger.log(
        eventType: SecurityEventType.suspiciousActivity,
        level: SecurityLogLevel.critical,
        message: 'Security Manager initialization failed',
        metadata: {'error': e.toString()},
      );
    }
  }

  /// High-level Secure Persistence
  Future<void> secureSave<T>({
    required String key,
    required T value,
    Map<String, dynamic> Function(T)? toJson,
  }) async {
    try {
      await storage.write(key: key, value: value, toJson: toJson);
    } catch (e) {
      await logger.log(
        eventType: SecurityEventType.secureStorageFailure,
        level: SecurityLogLevel.critical,
        message: 'Failed to securely save data',
        metadata: {'key': key, 'error': e.toString()},
      );
      rethrow;
    }
  }

  Future<T?> secureRead<T>({
    required String key,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      return await storage.read(key: key, fromJson: fromJson);
    } catch (e) {
      await logger.log(
        eventType: SecurityEventType.secureStorageFailure,
        level: SecurityLogLevel.critical,
        message: 'Failed to securely read data',
        metadata: {'key': key, 'error': e.toString()},
      );
      rethrow;
    }
  }

  /// SSL Pinning Verification
  bool validateNetworkCertificate(Uint8List serverCertificate) {
    final isValid = network.isCertificateValid(serverCertificate);
    if (!isValid) {
      logger.log(
        eventType: SecurityEventType.sslFailure,
        level: SecurityLogLevel.critical,
        message: 'SSL Pinning validation failed for server certificate',
      );
    }
    return isValid;
  }
}
