import 'package:equatable/equatable.dart';

/// Domain-layer representation of an error.
///
/// [code] carries the backend's machine-readable `error.code` (e.g.
/// `ERR_KYC_REQUIRED`) so blocs can branch on it, and [field] the offending
/// form field so screens can highlight the right input.
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final String? field;

  const Failure(this.message, {this.code, this.field});

  @override
  List<Object?> get props => [message, code, field];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(
    super.message, {
    this.statusCode,
    super.code,
    super.field,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure(
    super.message, {
    this.errors,
    super.code,
    super.field,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code, super.field});
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message, {super.code, super.field});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, {super.code});
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}
