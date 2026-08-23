import '../../errors/failures.dart';

class RetryFailure extends Failure {
  final dynamic originalError;
  const RetryFailure(super.message, {this.originalError});
}

class RetryException implements Exception {
  final String message;
  final dynamic originalError;
  const RetryException(this.message, {this.originalError});

  @override
  String toString() => 'RetryException: $message (Original: $originalError)';
}
