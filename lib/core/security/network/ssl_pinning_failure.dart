import '../../errors/failures.dart';

class SSLPinningFailure extends Failure {
  const SSLPinningFailure(super.message);
}

class SSLPinningException implements Exception {
  final String message;
  const SSLPinningException(this.message);

  @override
  String toString() => 'SSLPinningException: $message';
}
