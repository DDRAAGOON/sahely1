class ApiEndpoints {
  ApiEndpoints._();

  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 15000;

  // ── Auth ────────────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String otpSend = '/auth/otp/send';
  static const String otpVerify = '/auth/otp/verify';
  static const String registerStep1 = '/auth/register/step1';
  static const String registerStep2 = '/auth/register/step2';
  static const String registerStep3Verify = '/auth/register/step3/verify';
  static const String registerStep4SendPhoneOtp =
      '/auth/register/step4/send-phone-otp';
  static const String registerStep4VerifyPhone =
      '/auth/register/step4/verify-phone';
  static const String passwordResetRequest = '/auth/password/reset-request';
  static const String passwordReset = '/auth/password/reset';
  static const String appleMobile = '/auth/apple/mobile';
  static const String googleMobile = '/auth/google/mobile';

  // ── User / profile ──────────────────────────────────────────────────────
  static const String me = '/users/me';
  static const String updateMe = '/users/me';
  static const String deleteMe = '/users/me';
  static const String avatar = '/users/me/avatar';
  static const String fcmToken = '/users/me/fcm-token';

  // ── Properties ──────────────────────────────────────────────────────────
  static const String properties = '/properties';
  static const String trending = '/properties/trending';
  static const String offers = '/properties/offers';
  static String propertyDetails(String id) => '/properties/$id';
  static String propertyQuote(String id) => '/properties/$id/quote';
  static String propertyReviewsSummary(String id) =>
      '/properties/$id/reviews/summary';
  static String propertyAvailability(String id) => '/properties/$id/availability';

  // ── Search ───────────────────────────────────────────────────────────────
  static const String searchProperties = '/search/properties';
  static const String searchSuggestions = '/search/suggestions';
  static const String recentSearches = '/search/recent';

  // ── Bookings ────────────────────────────────────────────────────────────
  static const String bookings = '/bookings';
  static const String myBookings = '/bookings/my';
  static String bookingExtend(String id) => '/bookings/$id/extend';
  static String bookingCancel(String id) => '/bookings/$id/cancel';
  static String bookingReceipt(String id) => '/bookings/$id/receipt';
  static String bookingLockPin(String id) => '/bookings/$id/lock/pin';
  static const String ownerBookings = '/bookings/owner/bookings';
  static const String ownerCalendar = '/bookings/owner/calendar';
  static const String ownerRequests = '/bookings/owner/requests';

  // ── Wallet ──────────────────────────────────────────────────────────────
  static const String wallet = '/wallet';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletWithdraw = '/wallet/withdraw';
  static String withdrawStatus(String id) => '/wallet/withdraw/$id';
  static String withdrawReceipt(String id) => '/wallet/withdraw/$id/receipt';

  // ── Reviews ─────────────────────────────────────────────────────────────
  static const String reviews = '/reviews';
  static String reviewLike(String id) => '/reviews/$id/like';
  static String reviewReport(String id) => '/reviews/$id/report';
  static String reviewDelete(String id) => '/reviews/$id';

  // ── Wishlists (collections) ─────────────────────────────────────────────
  static const String wishlists = '/wishlists';
  static String wishlistItems(String id) => '/wishlists/$id/properties';
  static String wishlistDetail(String id) => '/wishlists/$id';

  // ── Notifications ───────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String notificationsReadAll = '/notifications/read-all';
  static const String notificationPreferences = '/notifications/preferences';
}
