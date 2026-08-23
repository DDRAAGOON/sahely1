import '../../errors/failures.dart';

class EncryptionFailure extends Failure {
  const EncryptionFailure(super.message);
}

class EncryptionException implements Exception {
  final String message;
  const EncryptionException(this.message);

  @override
  String toString() => 'EncryptionException: $message';
}
