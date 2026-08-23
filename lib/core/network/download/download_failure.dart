import '../../errors/failures.dart';

class DownloadFailure extends Failure {
  final dynamic originalError;
  const DownloadFailure(super.message, {this.originalError});
}

class DownloadException implements Exception {
  final String message;
  const DownloadException(this.message);

  @override
  String toString() => 'DownloadException: $message';
}
