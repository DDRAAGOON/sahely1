import '../../errors/failures.dart';

class UploadFailure extends Failure {
  final dynamic originalError;
  const UploadFailure(super.message, {this.originalError});
}

class UploadException implements Exception {
  final String message;
  const UploadException(this.message);

  @override
  String toString() => 'UploadException: $message';
}
