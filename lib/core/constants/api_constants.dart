/// Centralized API endpoints and network-related constants.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.sahely.app/v1/';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth Endpoints
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String verifyOtp = 'auth/verify-otp';
  static const String refreshToken = 'auth/refresh';

  // Property Endpoints
  static const String properties = 'properties';
  static const String trendingProperties = 'properties/trending';
  static const String propertyDetails = 'properties/'; // + id

  // Bookings
  static const String bookings = 'bookings';
  static const String myBookings = 'bookings/my';
}
