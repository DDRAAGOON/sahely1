class ApiEndpoints {
  ApiEndpoints._();

  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 15000;

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String logout = '/auth/logout';

  // Profile Endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/update';

  // Property Endpoints
  static const String properties = '/properties';
  static const String propertyDetails = '/properties/'; // Append ID

  // Booking Endpoints
  static const String bookings = '/bookings';
}
