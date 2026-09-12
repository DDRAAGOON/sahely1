class AppRoutes {
  AppRoutes._();

  // --------------------------------------------------------------------------
  // Auth Routes
  // --------------------------------------------------------------------------
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role';
  static const String createAccount = '/create';
  static const String signIn = '/signin';
  static const String verifyEmail = '/verify-email';
  static const String verifyPhone = '/verify-phone';
  static const String forgotPassword = '/forgot';
  static const String resetOtp = '/reset-otp';
  static const String newPassword = '/new-password';
  static const String passwordUpdated = '/password-updated';
  static const String idVerification = '/id-verification';
  static const String facialScan = '/facial-scan';
  static const String verificationComplete = '/verification-complete';

  // --------------------------------------------------------------------------
  // Renter Routes
  // --------------------------------------------------------------------------
  static const String renterHome = '/renter/home';
  static const String renterWishlist = '/renter/wishlist';
  static const String renterBookings = '/renter/bookings';
  static const String renterServices = '/renter/services';
  static const String renterProfile = '/renter/profile';

  // --------------------------------------------------------------------------
  // Broker Routes
  // --------------------------------------------------------------------------
  static const String brokerHome = '/broker/home';
  static const String brokerWishlist = '/broker/wishlist';
  static const String brokerBookings = '/broker/bookings';
  static const String brokerServices = '/broker/services';
  static const String brokerProfile = '/broker/profile';
  static const String brokerDashboard = '/broker/dashboard';
  static const String brokerPortfolio = '/broker/portfolio';
  static const String brokerWallet = '/broker/wallet';

  static const String brokerReferredDetail = '/broker/referred-detail';
  static const String brokerReferralIssue = '/broker/referral-issue';
  static const String brokerRefer = '/broker/refer';
  static const String brokerHistory = '/broker/history';
  static const String brokerTier = '/broker/tier';
  static const String brokerMawsem = '/broker/mawsem';
  static const String brokerTierUpgrade = '/broker/tier-upgrade';
  static const String brokerSos = '/broker/sos';
  static const String brokerBookingDetails = '/broker/booking-details';
  static const String brokerSmartLock = '/broker/smart-lock';
  static const String brokerWithdraw = '/broker/withdraw';
  static const String brokerWithdrawReceipt = '/broker/withdraw-receipt';
  static const String brokerPayout = '/broker/payout';

  // --------------------------------------------------------------------------
  // Owner Routes
  // --------------------------------------------------------------------------
  static const String ownerHome = '/owner/home';
  static const String ownerWishlist = '/owner/wishlist';
  static const String ownerBookings = '/owner/bookings';
  static const String ownerServices = '/owner/services';
  static const String ownerProfile = '/owner/profile';
  static const String ownerListings = '/owner/listings';
  static const String ownerListingNew = '/owner/listings/new';
  static const String ownerManage = '/owner/manage';
  static const String ownerEdit = '/owner/edit';
  static const String ownerPreview = '/owner/preview';
  static const String ownerSmartLock = '/owner/smart-lock';
  static const String ownerHistory = '/owner/history';
  static const String ownerPortfolio = '/owner/portfolio';
  static const String ownerAiChat = '/owner/ai-chat';
  static const String ownerNotifications = '/owner/notifications';
  static const String ownerEditBio = '/owner/edit-bio';
  static const String ownerBookingUpcoming = '/owner/booking-upcoming';
  static const String ownerBookingActive = '/owner/booking-active';
  static const String ownerBookingPast = '/owner/booking-past';
  static const String ownerRequestDetail = '/owner/request-detail';
  static const String ownerEarnings = '/owner/earnings';
  static const String ownerInsights = '/owner/insights';
  static const String ownerViolations = '/owner/violations';
  static const String ownerViolationReport = '/owner/violation-report';
  static const String ownerListingSubmitted = '/owner/listing-submitted';
  static const String ownerTeamReview = '/owner/team-review';
  static const String ownerRateGuest = '/owner/rate-guest';
  static const String ownerRequests = '/owner/requests';
  static const String ownerAllTrending = '/owner/all-trending';
  static const String ownerProperties = '/owner/properties';
  static const String ownerWithdraw = '/owner/withdraw';
  static const String ownerWithdrawReceipt = '/owner/withdraw-receipt';
  static const String ownerPayout = '/owner/payout';
  static const String sosOwner = '/sos-owner';

  // --------------------------------------------------------------------------
  // Shared Routes
  // --------------------------------------------------------------------------
  static const String browse = '/browse';
  static const String filters = '/filters';
  static const String allProperties = '/all-properties';
  static const String propertyDetail = '/property';
  static const String propertyReviews = '/property-reviews';

  // Shared links, opened from App Links, universal links or sahely://app.
  // The paths match the share URLs the API generates.
  static const String joinCollectionLink = '/wishlists/join/:token';
  static const String referralLink = '/join';
  static const String propertyLink = '/properties/:id';
  static const String booking = '/booking';
  static const String bookingConfirmed = '/booking-confirmed';
  static const String bookings = '/bookings';
  static const String bookingDetail = '/booked-property';
  static const String bookingUpcoming = '/booking-upcoming';
  static const String bookingPast = '/booking-past';
  static const String smartLock = '/smart-lock';
  static const String doorOut = '/door-out';
  static const String arrivalChecklist = '/arrival-checklist';
  static const String writeReview = '/write-review';
  static const String wishlist = '/wishlist';
  static const String collection = '/collection';
  static const String collectionChat = '/collection-chat';
  static const String compare = '/compare';
  static const String shareCollection = '/share-collection';
  static const String shareEarn = '/share-earn';
  static const String services = '/services';
  static const String mawsem = '/mawsem';
  static const String mawsemLevel = '/mawsem-level';
  static const String starsEarned = '/stars-earned';
  static const String starNudges = '/star-nudges';
  static const String levelUp = '/level-up';
  static const String levelUpCelebration = '/level-up-celebration';
  static const String addCard = '/add-card';
  static const String changePassword = '/change-password';
  static const String sos = '/sos';
  static const String aiChat = '/ai-chat';
  static const String currency = '/currency';
  static const String language = '/language';
  static const String wallet = '/wallet';
  static const String transactionHistory = '/transaction-history';
  static const String myReviews = '/my-reviews';
  static const String notificationsSettings = '/notifications-settings';
  static const String editProfile = '/edit-profile';
  static const String notifications = '/notifications';
  static const String notifBanner = '/notif-banner';
  static const String notifTop = '/notif-top';

  // --------------------------------------------------------------------------
  // Dynamic Routes (with parameters)
  // --------------------------------------------------------------------------
  static String propertyDetailById(String id) => '/property/$id';
  static String bookingDetailById(String id) => '/bookings/$id';
  static String ownerListingEdit(String id) => '/owner/listings/$id/edit';
}
