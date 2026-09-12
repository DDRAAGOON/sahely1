/// Central registry of every Sahely **mobile** API endpoint.
///
/// Paths are relative to the API base URL (see `EnvConfig.baseUrl` +
/// `EnvConfig.apiPrefix`), e.g. `https://api.sahely.com/api`.
///
/// Deliberately **excluded** (never called by the app):
///  * every `/admin/*` and `/admin-auth/*` route,
///  * admin-only actions inside shared modules (chat/chatbot moderation,
///    payment holds, security-deposit claim/release, mawsem season admin),
///  * `SERVER-ONLY` webhooks/callbacks (`/payments/webhook`,
///    `/payments/callback`, `/locks/tuya`, `/locks/hardware-callback`,
///    `/auth/google/callback`),
///  * `/internal/test/*` cron triggers.
class ApiEndpoints {
  ApiEndpoints._();

  static const int receiveTimeout = 20000;
  static const int connectionTimeout = 20000;

  /// Default page size used by every paginated list endpoint.
  static const int defaultPageSize = 20;

  /// Server-enforced maximum page size.
  static const int maxPageSize = 100;

  // -- Auth -------------------------------------------------------------------
  static const String googleAuth = '/auth/google';
  static const String googleMobile = '/auth/google/mobile';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout/all';
  static const String otpSend = '/auth/otp/send';
  static const String otpVerify = '/auth/otp/verify';
  static const String passwordChange = '/auth/password/change';
  static const String passwordReset = '/auth/password/reset';
  static const String passwordResetRequest = '/auth/password/reset-request';
  static const String refresh = '/auth/refresh';
  static const String registerStep1 = '/auth/register/step1';
  static const String registerStep2 = '/auth/register/step2';
  static const String registerStep3Verify = '/auth/register/step3/verify';
  static const String registerStep4SendPhoneOtp =
      '/auth/register/step4/send-phone-otp';
  static const String registerStep4VerifyPhone =
      '/auth/register/step4/verify-phone';
  static const String sendOtpOnPhoneNumber = '/auth/send-otp-on-phone-number';
  static const String verifyOtpOnPhoneNumber =
      '/auth/verify-otp-on-phone-number';
  static const String verificationCard = '/auth/verification/card';
  static const String verificationIdentity = '/auth/verification/identity';
  static const String verificationStatus = '/auth/verification/status';

  // -- Verification (KYC session flow) ----------------------------------------
  static const String kycStart = '/verification/start';
  static const String kycDocuments = '/verification/documents';
  static const String kycLivenessStart = '/verification/liveness/start';
  static const String kycLivenessSubmit = '/verification/liveness/submit';
  static const String kycQrScan = '/verification/qr/scan';
  static const String kycRequestReview = '/verification/request-review';
  static String kycStatus(String sessionId) =>
      '/verification/status/$sessionId';

  // -- User / Profile ---------------------------------------------------------
  static const String me = '/users/me';
  static const String avatar = '/users/me/avatar';
  static const String brokerInvitation = '/users/me/broker-invitation';
  static const String emailChangeRequest = '/users/me/email/change-request';
  static const String emailChangeConfirm = '/users/me/email/confirm';
  static const String fcmToken = '/users/me/fcm-token';
  static const String myReferral = '/users/me/referral';
  static String publicUser(String id) => '/users/$id';

  // -- Properties -------------------------------------------------------------
  static const String properties = '/properties/';
  static const String propertyCreate = '/properties/addProperty';
  static const String featuredProperties = '/properties/featured';
  static const String myProperties = '/properties/mine';
  static const String myCalendar = '/properties/mine/calendar';
  static const String myEarnings = '/properties/mine/earnings';
  static const String myPortfolioDashboard =
      '/properties/mine/portfolio/dashboard';
  static const String myRenters = '/properties/mine/renters';

  static String property(String id) => '/properties/$id';
  static String propertyAvailability(String id) =>
      '/properties/$id/availability';
  static String propertyBlockDates(String id) =>
      '/properties/$id/availability/block';
  static String propertyImages(String id) => '/properties/$id/images';
  static String propertyImage(String id, String imageId) =>
      '/properties/$id/images/$imageId';
  static String propertyImageCover(String id, String imageId) =>
      '/properties/$id/images/$imageId/cover';
  static String propertyPhotographyRequest(String id) =>
      '/properties/$id/photography/request';
  static String propertyPhotographyStatus(String id) =>
      '/properties/$id/photography/status';
  static String propertyQuote(String id) => '/properties/$id/quote';
  static String propertyRelist(String id) => '/properties/$id/relist';
  static String propertySubmit(String id) => '/properties/$id/submit';
  static String propertyUnlist(String id) => '/properties/$id/unlist';

  // -- Smart locks (property scoped; hardware webhooks are server-only) --------
  static String smartLock(String propertyId) =>
      '/properties/$propertyId/smart-lock';
  static String smartLockRegister(String propertyId) =>
      '/properties/$propertyId/smart-lock/register';
  static String smartLockAccessLog(String propertyId) =>
      '/properties/$propertyId/smart-lock/access-log';
  static String smartLockEmergencyAccess(String propertyId) =>
      '/properties/$propertyId/smart-lock/emergency-access';
  static String smartLockOnlineStatus(String propertyId) =>
      '/properties/$propertyId/smart-lock/online-status';

  // -- Search -----------------------------------------------------------------
  static const String searchMap = '/search/map';
  static const String searchProperties = '/search/properties';
  static const String searchSuggestions = '/search/suggestions';

  // -- Bookings ---------------------------------------------------------------
  static const String bookings = '/bookings/';
  static const String bookingCalculate = '/bookings/calculate';
  static const String myBookings = '/bookings/my';
  static const String ownerBookings = '/bookings/owner/bookings';
  static const String ownerRequests = '/bookings/owner/requests';
  static const String pendingApprovalBookings = '/bookings/pending-approval';

  static String booking(String id) => '/bookings/$id';
  static String bookingApprove(String id) => '/bookings/$id/approve';
  static String bookingCancel(String id) => '/bookings/$id/cancel';
  static String bookingCheckIn(String id) => '/bookings/$id/check-in';
  static String bookingCheckOut(String id) => '/bookings/$id/check-out';
  static String bookingDispute(String id) => '/bookings/$id/dispute';
  static String bookingLateCheckout(String id) =>
      '/bookings/$id/late-checkout-charge';
  static String bookingLockPin(String id) => '/bookings/$id/lock/pin';
  static String bookingNoShow(String id) => '/bookings/$id/no-show';
  static String bookingReceipt(String id) => '/bookings/$id/receipt';
  static String bookingReject(String id) => '/bookings/$id/reject';

  // -- Checklists -------------------------------------------------------------
  // The written guide lists these as top-level `/arrival/*` and `/departure/*`
  // routes. They are not: the live server 404s those and serves every variant
  // nested under the booking. Verified against the deployed API.
  static String arrivalRenter(String bookingId) =>
      '/bookings/$bookingId/checklist/arrival/renter';
  static String arrivalOwner(String bookingId) =>
      '/bookings/$bookingId/checklist/arrival/owner';
  static String departureRenter(String bookingId) =>
      '/bookings/$bookingId/checklist/departure/renter';
  static String departureOwner(String bookingId) =>
      '/bookings/$bookingId/checklist/departure/owner';
  static String preListingChecklist(String propertyId) =>
      '/properties/$propertyId/checklist/pre-listing';

  // -- Compound (security and cleaning) ---------------------------------------
  static String compoundSecurityCheck(String bookingId) =>
      '/bookings/$bookingId/compound/security-check';
  static String cleaningConfirm(String propertyId) =>
      '/properties/$propertyId/cleaning/confirm';
  static String cleaningLog(String propertyId) =>
      '/properties/$propertyId/cleaning/log';

  // -- Payments ---------------------------------------------------------------
  static const String paymentCards = '/payments/cards';
  static const String currencyRates = '/payments/currency/rates';
  static const String paymentInitiate = '/payments/initiate';
  static const String paymentIntents = '/payments/intents';
  static const String paymentTopUp = '/payments/top-up';
  static const String paymentWalletPay = '/payments/wallet-pay';

  static String payment(String id) => '/payments/$id';
  static String paymentStatus(String id) => '/payments/$id/status';
  static String paymentCard(String cardId) => '/payments/cards/$cardId';
  static String paymentCardDefault(String cardId) =>
      '/payments/cards/$cardId/default';
  static String topUpStatus(String id) => '/payments/top-up/$id';

  // -- Wallets ----------------------------------------------------------------
  static const String wallet = '/wallet/';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletWithdraw = '/wallet/withdraw';
  static String withdrawStatus(String id) => '/wallet/withdraw/$id';

  static const String myWallet = '/wallets/me';
  static const String myWalletDashboard = '/wallets/me/dashboard';
  static const String myWalletTransactions = '/wallets/me/transactions';
  static const String myWalletWithdrawals = '/wallets/me/withdrawals';

  // -- Reviews ----------------------------------------------------------------
  static const String reviews = '/reviews/';
  static const String pendingReviews = '/reviews/pending';

  /// Takes `?propertyId=` as a query parameter.
  static const String reviewSummary = '/reviews/summary';
  static String review(String id) => '/reviews/$id';
  static String reviewResponse(String id) => '/reviews/$id/response';

  // -- Chat (human support) ---------------------------------------------------
  static const String chatConversations = '/chat/conversations';
  static const String chatSearch = '/chat/search';
  static const String chatSos = '/chat/sos';
  static const String chatUnreadCount = '/chat/unread-count';

  static String chatConversation(String id) => '/chat/conversations/$id';
  static String chatClose(String id) => '/chat/conversations/$id/close';
  static String chatMessages(String id) => '/chat/conversations/$id/messages';
  static String chatMessageSearch(String id) =>
      '/chat/conversations/$id/messages/search';
  static String chatRead(String id) => '/chat/conversations/$id/read';
  static String chatMessage(String messageId) => '/chat/messages/$messageId';

  // -- Chatbot ----------------------------------------------------------------
  static const String chatbotConversations = '/chatbot/conversations';
  static const String chatbotUnreadCount = '/chatbot/unread-count';

  static String chatbotConversation(String id) => '/chatbot/conversations/$id';
  static String chatbotClose(String id) => '/chatbot/conversations/$id/close';
  static String chatbotMessages(String id) =>
      '/chatbot/conversations/$id/messages';
  static String chatbotRead(String id) => '/chatbot/conversations/$id/read';
  static String chatbotMessage(String messageId) =>
      '/chatbot/messages/$messageId';

  // -- Concierge --------------------------------------------------------------
  static const String conciergeBookings = '/concierge/bookings';
  static const String conciergeServices = '/concierge/services';
  static String conciergeBooking(String id) => '/concierge/bookings/$id';
  static String conciergeBookingCancel(String id) =>
      '/concierge/bookings/$id/cancel';
  static String conciergeService(String id) => '/concierge/services/$id';

  // -- Notifications ----------------------------------------------------------
  static const String notifications = '/notifications/';
  static const String notificationDeviceToken = '/notifications/device-token';
  static const String notificationPreferences = '/notifications/preferences';
  static const String notificationsReadAll = '/notifications/read-all';
  static String notification(String id) => '/notifications/$id';
  static String notificationRead(String id) => '/notifications/$id/read';

  // -- MAWSEM loyalty program -------------------------------------------------
  static const String mawsemHistory = '/mawsem/history';
  static const String mawsemLeaderboard = '/mawsem/leaderboard';
  static const String mawsemLevelHistory = '/mawsem/level-history';
  static const String mawsemLevels = '/mawsem/levels';
  static const String mawsemMe = '/mawsem/me';
  static const String mawsemPerks = '/mawsem/perks';
  static const String mawsemFreeCleaning = '/mawsem/perks/free-cleaning/use';
  static const String mawsemCurrentSeason = '/mawsem/season/current';
  static const String mawsemTokens = '/mawsem/tokens';
  static const String mawsemUseToken = '/mawsem/tokens/use';

  // -- Referrals --------------------------------------------------------------
  static const String referralCode = '/referrals/code';
  static const String referralMe = '/referrals/me';
  static const String referralResolve = '/referrals/resolve';
  static const String referralStats = '/referrals/stats';

  // -- Broker -----------------------------------------------------------------
  static const String brokerCommissions = '/broker/commissions';
  static const String brokerDashboard = '/broker/dashboard';
  static const String brokerEarningWindows = '/broker/earning-windows';
  static const String brokerPerks = '/broker/perks';
  static const String brokerRedeemStay = '/broker/perks/redeem-stay';
  static const String brokerProfile = '/broker/profile';
  static const String brokerProperties = '/broker/properties';
  static const String brokerReferralLink = '/broker/referral-link';
  static const String brokerReferralStats = '/broker/referral-link/stats';
  static const String brokerTier = '/broker/tier';
  static const String brokerWithdraw = '/broker/withdraw';

  // -- Wishlists (collaborative collections) ----------------------------------
  static const String wishlists = '/wishlists/';
  static const String wishlistJoin = '/wishlists/join';

  static String wishlist(String id) => '/wishlists/$id';
  static String wishlistCompare(String id) => '/wishlists/$id/compare';
  static String wishlistLeave(String id) => '/wishlists/$id/leave';
  static String wishlistMembers(String id) => '/wishlists/$id/members';
  static String wishlistMember(String id, String userId) =>
      '/wishlists/$id/members/$userId';
  static String wishlistMemberReinstate(String id, String userId) =>
      '/wishlists/$id/members/$userId/reinstate';
  static String wishlistMessages(String id) => '/wishlists/$id/messages';
  static String wishlistMessage(String id, String messageId) =>
      '/wishlists/$id/messages/$messageId';
  static String wishlistMessagesRead(String id) =>
      '/wishlists/$id/messages/read';
  static String wishlistUnreadCount(String id) =>
      '/wishlists/$id/messages/unread-count';
  static String wishlistProperties(String id) => '/wishlists/$id/properties';
  static String wishlistProperty(String id, String propertyId) =>
      '/wishlists/$id/properties/$propertyId';
  static String wishlistReports(String id) => '/wishlists/$id/reports/';
  static String wishlistShareLink(String id) => '/wishlists/$id/share-link';
  static String wishlistShareStatus(String id) => '/wishlists/$id/share-status';
  static String wishlistShareRevoke(String id) => '/wishlists/$id/share/revoke';
  static String wishlistShareRotate(String id) => '/wishlists/$id/share/rotate';

  // -- Violations -------------------------------------------------------------
  static const String violationsCompound = '/violations/compound';
  static const String violationsMine = '/violations/mine';
  static const String violationsReport = '/violations/report';

  // -- File uploads (pre-signed S3) -------------------------------------------
  /// Step 1 - ask the backend for a pre-signed PUT URL.
  static const String uploadRequestUrl = '/files/upload/request-url';

  /// Step 2 is a direct PUT to S3 - not a Sahely endpoint.
  /// Step 3 - confirm the upload so the object key is persisted.
  static const String uploadConfirm = '/files/upload/confirm';
}
