import '../../errors/failures.dart';

class DeepLinkFailure extends Failure {
  const DeepLinkFailure(super.message);
}

class DeepLinkParseException implements Exception {
  final String message;
  const DeepLinkParseException(this.message);

  @override
  String toString() => 'DeepLinkParseException: $message';
}
