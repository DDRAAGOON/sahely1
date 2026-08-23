import 'feature_flag.dart';

class FeatureFlags {
  static const newSearchUI = FeatureFlag(
    key: 'new_search_ui',
    defaultValue: false,
    group: FeatureGroup.renter,
    description: 'Enables the new search results interface',
  );

  static const socialLogin = FeatureFlag(
    key: 'social_login',
    defaultValue: true,
    group: FeatureGroup.auth,
    description: 'Enables social login providers',
  );

  static const experimentalBooking = FeatureFlag(
    key: 'experimental_booking',
    defaultValue: false,
    group: FeatureGroup.experimental,
    description: 'Enables the experimental booking flow',
  );

  static const allFlags = [
    newSearchUI,
    socialLogin,
    experimentalBooking,
  ];
}
