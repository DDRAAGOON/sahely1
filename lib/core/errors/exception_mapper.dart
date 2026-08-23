import 'exceptions.dart';
import 'failures.dart';

class ExceptionMapper {
  static Failure map(Object exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message, statusCode: exception.statusCode);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message, errors: exception.errors);
    } else if (exception is UnauthorizedException) {
      return UnauthorizedFailure(exception.message);
    } else if (exception is ForbiddenException) {
      return ForbiddenFailure(exception.message);
    } else if (exception is NotFoundException) {
      return NotFoundFailure(exception.message);
    } else if (exception is TimeoutException) {
      return TimeoutFailure(exception.message);
    } else if (exception is UnknownException) {
      return UnknownFailure(exception.message);
    } else {
      return UnknownFailure(exception.toString());
    }
  }
}
