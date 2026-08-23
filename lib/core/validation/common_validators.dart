import 'validation_result.dart';
import 'validator.dart';

class RequiredValidator<T> extends Validator<T> {
  final String? customMessage;
  RequiredValidator({this.customMessage});

  @override
  ValidationResult validate(T value, {String fieldName = ''}) {
    final bool isEmpty = value == null ||
        (value is String && value.trim().isEmpty) ||
        (value is Iterable && value.isEmpty) ||
        (value is Map && value.isEmpty);

    if (isEmpty) {
      return ValidationResult.failure([
        ValidationError(
          field: fieldName,
          message: customMessage ?? '$fieldName is required',
        )
      ]);
    }
    return ValidationResult.success();
  }
}

class EmailValidator extends Validator<String> {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  @override
  ValidationResult validate(String value, {String fieldName = ''}) {
    if (!_emailRegExp.hasMatch(value)) {
      return ValidationResult.failure([
        ValidationError(
          field: fieldName,
          message: 'Invalid email address',
        )
      ]);
    }
    return ValidationResult.success();
  }
}

class PasswordValidator extends Validator<String> {
  final int minLength;
  final bool requireUppercase;
  final bool requireNumber;
  final bool requireLowercase;
  final bool requireSpecialChar;

  PasswordValidator({
    this.minLength = 8,
    this.requireUppercase = false,
    this.requireNumber = false,
    this.requireLowercase = false,
    this.requireSpecialChar = false,
  });

  static final RegExp uppercaseRegExp = RegExp(r'[A-Z]');
  static final RegExp numberRegExp = RegExp(r'[0-9]');
  static final RegExp lowercaseRegExp = RegExp(r'[a-z]');
  static final RegExp specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  @override
  ValidationResult validate(String value, {String fieldName = ''}) {
    final errors = <ValidationError>[];

    if (value.length < minLength) {
      errors.add(ValidationError(
        field: fieldName,
        message: 'Password must be at least $minLength characters long',
      ));
    }

    if (requireUppercase && !uppercaseRegExp.hasMatch(value)) {
      errors.add(ValidationError(
        field: fieldName,
        message: 'Password must contain at least one uppercase letter',
      ));
    }

    if (requireNumber && !numberRegExp.hasMatch(value)) {
      errors.add(ValidationError(
        field: fieldName,
        message: 'Password must contain at least one number',
      ));
    }

    if (requireLowercase && !lowercaseRegExp.hasMatch(value)) {
      errors.add(ValidationError(
        field: fieldName,
        message: 'Password must contain at least one lowercase letter',
      ));
    }

    if (requireSpecialChar && !specialCharRegExp.hasMatch(value)) {
      errors.add(ValidationError(
        field: fieldName,
        message: 'Password must contain at least one special character',
      ));
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }
}

class PhoneValidator extends Validator<String> {
  @override
  ValidationResult validate(String value, {String fieldName = ''}) {
    if (value.length < 10) {
      return ValidationResult.failure([
        ValidationError(
          field: fieldName,
          message: 'Invalid phone number',
        )
      ]);
    }
    return ValidationResult.success();
  }
}

class NameValidator extends Validator<String> {
  @override
  ValidationResult validate(String value, {String fieldName = ''}) {
    if (value.trim().split(' ').length < 2) {
      return ValidationResult.failure([
        ValidationError(
          field: fieldName,
          message: 'Please enter your full name',
        )
      ]);
    }
    return ValidationResult.success();
  }
}

class NumberValidator extends Validator<String> {
  @override
  ValidationResult validate(String value, {String fieldName = ''}) {
    if (num.tryParse(value) == null) {
      return ValidationResult.failure([
        ValidationError(
          field: fieldName,
          message: '$fieldName must be a valid number',
        )
      ]);
    }
    return ValidationResult.success();
  }
}

class LengthValidator extends Validator<String> {
  final int? min;
  final int? max;

  LengthValidator({this.min, this.max});

  @override
  ValidationResult validate(String value, {String fieldName = ''}) {
    if (min != null && value.length < min!) {
      return ValidationResult.failure([
        ValidationError(
          field: fieldName,
          message: '$fieldName must be at least $min characters long',
        )
      ]);
    }
    if (max != null && value.length > max!) {
      return ValidationResult.failure([
        ValidationError(
          field: fieldName,
          message: '$fieldName must be at most $max characters long',
        )
      ]);
    }
    return ValidationResult.success();
  }
}

class RangeValidator extends Validator<num> {
  final num? min;
  final num? max;

  RangeValidator({this.min, this.max});

  @override
  ValidationResult validate(num value, {String fieldName = ''}) {
    if (min != null && value < min!) {
      return ValidationResult.failure([
        ValidationError(
          field: fieldName,
          message: '$fieldName must be at least $min',
        )
      ]);
    }
    if (max != null && value > max!) {
      return ValidationResult.failure([
        ValidationError(
          field: fieldName,
          message: '$fieldName must be at most $max',
        )
      ]);
    }
    return ValidationResult.success();
  }
}
