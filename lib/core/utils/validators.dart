import '../constants/validation_constants.dart';

/// Centralized class for all input validation logic.
/// Returns a [String?] representing the error message, or null if valid.
class AppValidators {
  AppValidators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!ValidationConstants.emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < ValidationConstants.minPasswordLength) {
      return 'Password must be at least ${ValidationConstants.minPasswordLength} characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!ValidationConstants.phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < ValidationConstants.minNameLength) {
      return 'Name must be at least ${ValidationConstants.minNameLength} characters';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != ValidationConstants.otpLength) {
      return 'OTP must be exactly ${ValidationConstants.otpLength} digits';
    }
    return null;
  }
}
