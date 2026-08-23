import '../../errors/failures.dart';

class SecureStorageFailure extends Failure {
  const SecureStorageFailure(super.message);
}

class SecureStorageException implements Exception {
  final String message;
  const SecureStorageException(this.message);

  @override
  String toString() => 'SecureStorageException: $message';
}
