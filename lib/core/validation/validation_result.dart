import '../errors/failures.dart';

class ValidationResult {
  final bool isValid;
  final List<ValidationError> errors;

  const ValidationResult._(this.isValid, this.errors);

  factory ValidationResult.success() => const ValidationResult._(true, []);
  factory ValidationResult.failure(List<ValidationError> errors) =>
      ValidationResult._(false, errors);

  String? get firstErrorMessage => errors.isEmpty ? null : errors.first.message;

  ValidationFailure toFailure() {
    final Map<String, String> errorMap = {
      for (var e in errors) e.field: e.message
    };
    return ValidationFailure(
      firstErrorMessage ?? 'Validation failed',
      errors: errorMap,
    );
  }
}

class ValidationError {
  final String field;
  final String message;

  const ValidationError({required this.field, required this.message});
}
