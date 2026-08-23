import '../../errors/failures.dart';

class InfiniteScrollFailure extends Failure {
  const InfiniteScrollFailure(super.message);
}

class InfiniteScrollException implements Exception {
  final String message;
  const InfiniteScrollException(this.message);

  @override
  String toString() => message;
}
