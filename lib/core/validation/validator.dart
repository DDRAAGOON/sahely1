import 'validation_result.dart';

abstract class Validator<T> {
  ValidationResult validate(T value, {String fieldName = ''});
}

class CompositeValidator<T> extends Validator<T> {
  final List<Validator<T>> validators;

  CompositeValidator(this.validators);

  @override
  ValidationResult validate(T value, {String fieldName = ''}) {
    final errors = <ValidationError>[];
    for (final validator in validators) {
      final result = validator.validate(value, fieldName: fieldName);
      if (!result.isValid) {
        errors.addAll(result.errors);
      }
    }
    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }
}
