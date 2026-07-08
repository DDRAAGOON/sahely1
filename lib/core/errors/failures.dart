import 'package:equatable/equatable.dart';

/// [Failure] objects are used in the [Domain Layer] (Repositories) to represent
/// errors that occurred in the Data Layer.
/// This prevents throwing raw exceptions in the UI/Bloc layer.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Represents a general server-side error.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents an error related to local storage or caching.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents an error due to lack of internet connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Represents an error related to login/signup or token expiration.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Represents form or input validation errors from the backend.
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure(super.message, {this.errors});

  @override
  List<Object?> get props => [message, errors];
}
