/// Constants used for input validation logic.
class ValidationConstants {
  ValidationConstants._();

  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  
  static final RegExp phoneRegex = RegExp(
    r"^\+?[0-9]{10,14}$",
  );

  // Length Constraints
  static const int minPasswordLength = 8;
  static const int minNameLength = 3;
  static const int otpLength = 6;
  static const int nationalIdLength = 14;
}
