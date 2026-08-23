import '../../errors/failures.dart';

class RequestCacheFailure extends Failure {
  const RequestCacheFailure(super.message);
}

class RequestCacheException implements Exception {
  final String message;
  const RequestCacheException(this.message);
}
