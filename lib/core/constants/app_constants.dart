/// General application constants including storage keys and design values.
class AppConstants {
  AppConstants._();

  static const String appName = 'Sahely';
  
  // Storage Keys
  static const String tokenKey = 'CACHED_AUTH_TOKEN';
  static const String roleKey = 'CACHED_USER_ROLE';
  static const String userKey = 'CACHED_USER_DATA';
  static const String themeKey = 'APP_THEME_MODE';
  static const String localeKey = 'APP_LOCALE';

  // Design Values
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 20.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusSmall = 12.0;
  
  // Animation Settings
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 400);
  static const Duration slowDuration = Duration(milliseconds: 800);
}
