import '../../errors/failures.dart';

class LazyLoadFailure extends Failure {
  const LazyLoadFailure(super.message);
}

class LazyLoadException implements Exception {
  final String message;
  const LazyLoadException(this.message);

  @override
  String toString() => message;
}
