import '../../errors/failures.dart';

class DeviceSecurityFailure extends Failure {
  const DeviceSecurityFailure(super.message);
}

class DeviceSecurityException implements Exception {
  final String message;
  const DeviceSecurityException(this.message);

  @override
  String toString() => 'DeviceSecurityException: $message';
}
