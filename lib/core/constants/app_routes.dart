class AppRoutes {
  // Auth Routes
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  
  // Renter Routes
  static const String renterHome = '/renter/home';
  static const String renterProfile = '/renter/profile';
  static const String renterBookings = '/renter/bookings';
  static const String renterWishlist = '/renter/wishlist';
  
  // Owner Routes
  static const String ownerHome = '/owner/home';
  static const String ownerProperties = '/owner/properties';
  
  // Broker Routes
  static const String brokerHome = '/broker/home';
  
  // Shared Routes
  static const String propertyDetails = '/property/details';
  static const String booking = '/booking';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
}
