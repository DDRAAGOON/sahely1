import '../../errors/failures.dart';

class ImageCacheFailure extends Failure {
  const ImageCacheFailure(super.message);
}

class ImageCacheException implements Exception {
  final String message;
  const ImageCacheException(this.message);
}
