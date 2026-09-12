import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('fr'),
    Locale('de'),
    Locale('es'),
    Locale('it'),
    Locale('ru')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your app language'**
  String get chooseLanguage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @newToSahely.
  ///
  /// In en, this message translates to:
  /// **'New to SAHELY?'**
  String get newToSahely;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @continueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueGoogle;

  /// No description provided for @continueApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueApple;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your SAHELY account'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Verified Chalets. Zero Chaos.'**
  String get welcomeTagline;

  /// No description provided for @findYourPerfectStay.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Stay'**
  String get findYourPerfectStay;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @renter.
  ///
  /// In en, this message translates to:
  /// **'Renter'**
  String get renter;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Property Owner'**
  String get owner;

  /// No description provided for @broker.
  ///
  /// In en, this message translates to:
  /// **'Broker'**
  String get broker;

  /// No description provided for @roleOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Owner'**
  String get roleOwnerTitle;

  /// No description provided for @renterWishlist.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get renterWishlist;

  /// No description provided for @brokerWishlist.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get brokerWishlist;

  /// No description provided for @registeringAs.
  ///
  /// In en, this message translates to:
  /// **'Registering as'**
  String get registeringAs;

  /// No description provided for @roleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your role to get started'**
  String get roleSubtitle;

  /// No description provided for @howUseSahely.
  ///
  /// In en, this message translates to:
  /// **'How will you use SAHELY?'**
  String get howUseSahely;

  /// No description provided for @requestAccess.
  ///
  /// In en, this message translates to:
  /// **'Request Access'**
  String get requestAccess;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get enterValidPhone;

  /// No description provided for @passwordMinChars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinChars;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @mustAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the terms to continue'**
  String get mustAgreeTerms;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @sentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to'**
  String get sentTo;

  /// No description provided for @enterCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterCodeTitle;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailHint.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification Code to your email'**
  String get verifyEmailHint;

  /// No description provided for @verifyEmailCta.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyEmailCta;

  /// No description provided for @verifyNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Number'**
  String get verifyNumberTitle;

  /// No description provided for @verifyNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your phone'**
  String get verifyNumberHint;

  /// No description provided for @verifyNumberBottom.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive a code?'**
  String get verifyNumberBottom;

  /// No description provided for @verifyNumberCta.
  ///
  /// In en, this message translates to:
  /// **'Verify Number'**
  String get verifyNumberCta;

  /// No description provided for @verifyOtpCta.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyOtpCta;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to SAHELY'**
  String get signInSubtitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get navWishlist;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get navManage;

  /// No description provided for @navMyRole.
  ///
  /// In en, this message translates to:
  /// **'My Role'**
  String get navMyRole;

  /// No description provided for @navReferrals.
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get navReferrals;

  /// No description provided for @navWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navWallet;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @topRatedSection.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRatedSection;

  /// No description provided for @staysSuffix.
  ///
  /// In en, this message translates to:
  /// **'stays'**
  String get staysSuffix;

  /// No description provided for @staysuffix.
  ///
  /// In en, this message translates to:
  /// **'stays'**
  String get staysuffix;

  /// No description provided for @catAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catAll;

  /// No description provided for @catChalet.
  ///
  /// In en, this message translates to:
  /// **'Chalet'**
  String get catChalet;

  /// No description provided for @catVilla.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get catVilla;

  /// No description provided for @catBeachfront.
  ///
  /// In en, this message translates to:
  /// **'Beachfront'**
  String get catBeachfront;

  /// No description provided for @catPool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get catPool;

  /// No description provided for @catPenthouse.
  ///
  /// In en, this message translates to:
  /// **'Penthouse'**
  String get catPenthouse;

  /// No description provided for @stepBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get stepBasics;

  /// No description provided for @stepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get stepLocation;

  /// No description provided for @stepPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get stepPhotos;

  /// No description provided for @stepFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get stepFeatures;

  /// No description provided for @accountBanned.
  ///
  /// In en, this message translates to:
  /// **'Your account has been permanently banned. Please contact support.'**
  String get accountBanned;

  /// No description provided for @accountSuspendedWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Your account is suspended until {date}'**
  String accountSuspendedWithDetails(String date);

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get noInternet;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get serverError;

  /// No description provided for @rateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment.'**
  String get rateLimit;

  /// No description provided for @termsOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner Terms & Conditions'**
  String get termsOwnerTitle;

  /// No description provided for @termsBrokerTitle.
  ///
  /// In en, this message translates to:
  /// **'Broker Terms & Conditions'**
  String get termsBrokerTitle;

  /// No description provided for @termsRenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Renter Terms & Conditions'**
  String get termsRenterTitle;

  /// No description provided for @termsMasterRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'SAHELY Community Rules'**
  String get termsMasterRulesTitle;

  /// No description provided for @termsDocRef.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to SAHELY\'s Terms of Service and Privacy Policy.'**
  String get termsDocRef;

  /// No description provided for @termsIntroOwner.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SAHELY as a Property Owner. Please read these terms carefully.'**
  String get termsIntroOwner;

  /// No description provided for @termsIntroBroker.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SAHELY as a Broker. Please read these terms carefully.'**
  String get termsIntroBroker;

  /// No description provided for @termsIntroRenter.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SAHELY as a Renter. Please read these terms carefully.'**
  String get termsIntroRenter;

  /// No description provided for @termsOwnerSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Property Listing Standards'**
  String get termsOwnerSection1Title;

  /// No description provided for @termsOwnerSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Payment & Commission'**
  String get termsOwnerSection2Title;

  /// No description provided for @termsOwnerSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy'**
  String get termsOwnerSection3Title;

  /// No description provided for @termsOwnerSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Liability & Insurance'**
  String get termsOwnerSection4Title;

  /// No description provided for @termsBrokerSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Broker Responsibilities'**
  String get termsBrokerSection1Title;

  /// No description provided for @termsBrokerSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Commission Structure'**
  String get termsBrokerSection2Title;

  /// No description provided for @termsBrokerSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Client Relations'**
  String get termsBrokerSection3Title;

  /// No description provided for @termsBrokerSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get termsBrokerSection4Title;

  /// No description provided for @termsBrokerSection5Title.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get termsBrokerSection5Title;

  /// No description provided for @termsRenterSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Booking & Payment'**
  String get termsRenterSection1Title;

  /// No description provided for @termsRenterSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Check-in & Check-out'**
  String get termsRenterSection2Title;

  /// No description provided for @termsRenterSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Property Care'**
  String get termsRenterSection3Title;

  /// No description provided for @termsRenterSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy'**
  String get termsRenterSection4Title;

  /// Shown when login credentials are wrong
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get errorAuthInvalidCredentials;

  /// No description provided for @errorAuthEmailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address before signing in'**
  String get errorAuthEmailNotVerified;

  /// No description provided for @errorAuthPhoneNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Please verify your phone number to continue'**
  String get errorAuthPhoneNotVerified;

  /// Shown when account is suspended
  ///
  /// In en, this message translates to:
  /// **'Your account is suspended until {date}'**
  String errorAuthAccountSuspended(String date);

  /// No description provided for @errorAuthAccountBanned.
  ///
  /// In en, this message translates to:
  /// **'Your account has been permanently banned. Please contact support.'**
  String get errorAuthAccountBanned;

  /// No description provided for @errorAuthTokenExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorAuthTokenExpired;

  /// No description provided for @errorRefreshTokenInvalid.
  ///
  /// In en, this message translates to:
  /// **'Your session is no longer valid. Please sign in again.'**
  String get errorRefreshTokenInvalid;

  /// No description provided for @errorOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. {attempts} attempts remaining'**
  String errorOtpInvalid(int attempts);

  /// No description provided for @errorOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'Your verification code has expired. Please request a new one.'**
  String get errorOtpExpired;

  /// No description provided for @errorOtpMaxAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Please request a new code.'**
  String get errorOtpMaxAttempts;

  /// No description provided for @errorVerificationIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Please complete your identity verification to continue.'**
  String get errorVerificationIncomplete;

  /// No description provided for @errorVerificationKycRejected.
  ///
  /// In en, this message translates to:
  /// **'Your identity verification was rejected. Please resubmit your documents.'**
  String get errorVerificationKycRejected;

  /// No description provided for @errorDatesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The selected dates are no longer available. Please choose different dates.'**
  String get errorDatesUnavailable;

  /// No description provided for @errorInsufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Your wallet balance is insufficient for this transaction.'**
  String get errorInsufficientBalance;

  /// No description provided for @errorPaymentCardRequired.
  ///
  /// In en, this message translates to:
  /// **'Please add a payment card to continue.'**
  String get errorPaymentCardRequired;

  /// No description provided for @errorPropertyNotFound.
  ///
  /// In en, this message translates to:
  /// **'This property is no longer available.'**
  String get errorPropertyNotFound;

  /// No description provided for @errorBookingConflict.
  ///
  /// In en, this message translates to:
  /// **'This booking conflicts with an existing reservation.'**
  String get errorBookingConflict;

  /// No description provided for @errorRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get errorRateLimit;

  /// No description provided for @errorNetworkOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get errorNetworkOffline;

  /// No description provided for @errorNetworkTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please check your connection and try again.'**
  String get errorNetworkTimeout;

  /// No description provided for @errorServerInternal.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later.'**
  String get errorServerInternal;

  /// No description provided for @errorReviewWindowClosed.
  ///
  /// In en, this message translates to:
  /// **'The review window for this booking has closed.'**
  String get errorReviewWindowClosed;

  /// No description provided for @termsRenterSection3Point3.
  ///
  /// In en, this message translates to:
  /// **'Verified damage is deducted from the deposit. If the cost exceeds the deposit you are liable for the balance.'**
  String get termsRenterSection3Point3;

  /// No description provided for @termsRenterSection1Point1.
  ///
  /// In en, this message translates to:
  /// **'Full payment is required to confirm a booking. Sahely does not accept provisional holds or reservations.'**
  String get termsRenterSection1Point1;

  /// No description provided for @termsBrokerSection5Point2.
  ///
  /// In en, this message translates to:
  /// **'A confirmed breach means permanent termination and forfeiture of all accrued commission. Deactivating voluntarily forfeits unpaid commission.'**
  String get termsBrokerSection5Point2;

  /// No description provided for @termsOwnerSection3Point2.
  ///
  /// In en, this message translates to:
  /// **'Cancelling a confirmed booking carries a penalty of 15% of the total amount the renter paid.'**
  String get termsOwnerSection3Point2;

  /// No description provided for @termsBrokerSection1Point2.
  ///
  /// In en, this message translates to:
  /// **'Your referral link is personal and non-transferable. A property counts for you only if the owner registered it through your link.'**
  String get termsBrokerSection1Point2;

  /// No description provided for @termsRenterSection2Point3.
  ///
  /// In en, this message translates to:
  /// **'Late checkout without prior approval in the app is charged at one additional night’s rate.'**
  String get termsRenterSection2Point3;

  /// No description provided for @goldBroker.
  ///
  /// In en, this message translates to:
  /// **'Gold Broker'**
  String get goldBroker;

  /// No description provided for @termsBrokerSection2Point3.
  ///
  /// In en, this message translates to:
  /// **'Commission reaches your wallet within 48 hours of the guest’s check-in. Cash-out starts at EGP 200 and total payout per booking is capped at 5%.'**
  String get termsBrokerSection2Point3;

  /// No description provided for @termsRenterSection1Point4.
  ///
  /// In en, this message translates to:
  /// **'A valid Egyptian national ID or passport is required at booking. Your document is submitted for a security check as required by Egyptian law.'**
  String get termsRenterSection1Point4;

  /// No description provided for @termsOwnerSection1Point3.
  ///
  /// In en, this message translates to:
  /// **'The property must match its listing photos and description at all times. Platform-arranged professional photography is required before the listing is published.'**
  String get termsOwnerSection1Point3;

  /// No description provided for @termsRenterSection4Point2.
  ///
  /// In en, this message translates to:
  /// **'For bookings made 7+ days ahead: 80% refund when cancelling 7 or more days before check-in, 50% from 3 to 6 days before, and no refund under 3 days.'**
  String get termsRenterSection4Point2;

  /// No description provided for @termsBrokerSection4Point2.
  ///
  /// In en, this message translates to:
  /// **'Commission structures, tier thresholds and operational procedures are confidential and may not be disclosed without written consent.'**
  String get termsBrokerSection4Point2;

  /// No description provided for @termsMasterRulesPoint3.
  ///
  /// In en, this message translates to:
  /// **'Sahely is the exclusive payment intermediary. Arranging a rental or a payment outside the platform results in a permanent ban for both parties.'**
  String get termsMasterRulesPoint3;

  /// No description provided for @statEarnedMo.
  ///
  /// In en, this message translates to:
  /// **'Earned / mo'**
  String get statEarnedMo;

  /// No description provided for @trendingNow.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get trendingNow;

  /// No description provided for @termsRenterSection2Point2.
  ///
  /// In en, this message translates to:
  /// **'Complete the Arrival Checklist within 2 hours of check-in. Anything not reported in that window is treated as accepted, so photograph any issue you find.'**
  String get termsRenterSection2Point2;

  /// No description provided for @termsMasterRulesPoint2.
  ///
  /// In en, this message translates to:
  /// **'Raise disputes in the app within 24 hours of the incident. Smart lock data and app activity logs are treated as primary evidence.'**
  String get termsMasterRulesPoint2;

  /// No description provided for @termsBrokerSection3Point3.
  ///
  /// In en, this message translates to:
  /// **'You may use Sahely as a renter from the same account, but you may not refer yourself or claim commission on your own booking.'**
  String get termsBrokerSection3Point3;

  /// No description provided for @nativeLanguageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get nativeLanguageName;

  /// No description provided for @termsOwnerSection1Point2.
  ///
  /// In en, this message translates to:
  /// **'You may declare up to 5 personal-use blackout days per month, booked in advance through the app.'**
  String get termsOwnerSection1Point2;

  /// No description provided for @termsOwnerSection2Point2.
  ///
  /// In en, this message translates to:
  /// **'Your payout is released within 48 hours of the renter’s confirmed check-in.'**
  String get termsOwnerSection2Point2;

  /// No description provided for @otpEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get otpEnterCode;

  /// No description provided for @termsOwnerSection4Point4.
  ///
  /// In en, this message translates to:
  /// **'Sahely bears no financial liability for losses arising from government action, compound authority decisions, or force majeure.'**
  String get termsOwnerSection4Point4;

  /// No description provided for @obTitle2.
  ///
  /// In en, this message translates to:
  /// **'Book With Confidence'**
  String get obTitle2;

  /// No description provided for @termsRenterSection1Point3.
  ///
  /// In en, this message translates to:
  /// **'Your booking is confirmed only once the full payment and the deposit have cleared.'**
  String get termsRenterSection1Point3;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @termsOwnerSection2Point3.
  ///
  /// In en, this message translates to:
  /// **'A platform commission of 15% is deducted automatically from every booking.'**
  String get termsOwnerSection2Point3;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in'**
  String get resendIn;

  /// No description provided for @termsBrokerSection1Point1.
  ///
  /// In en, this message translates to:
  /// **'Each person may hold one broker account only, verified with a valid Egyptian ID or passport. Multiple accounts lead to removal of all of them.'**
  String get termsBrokerSection1Point1;

  /// No description provided for @termsBrokerSection3Point2.
  ///
  /// In en, this message translates to:
  /// **'Side payments from property owners in connection with listings are prohibited.'**
  String get termsBrokerSection3Point2;

  /// No description provided for @termsBrokerSection5Point1.
  ///
  /// In en, this message translates to:
  /// **'Sahely may suspend your account where prohibited conduct or fraud is suspected. Earning windows keep counting down during a suspension.'**
  String get termsBrokerSection5Point1;

  /// No description provided for @the4Tiers.
  ///
  /// In en, this message translates to:
  /// **'The 4 Tiers'**
  String get the4Tiers;

  /// No description provided for @termsBrokerSection3Point1.
  ///
  /// In en, this message translates to:
  /// **'Never quote commission rates, features or terms that differ from this document or from what Sahely has communicated.'**
  String get termsBrokerSection3Point1;

  /// No description provided for @termsOwnerSection1Point4.
  ///
  /// In en, this message translates to:
  /// **'The Pre-Listing Checklist must be submitted and accepted before every rental period. The guest access code stays locked until it is.'**
  String get termsOwnerSection1Point4;

  /// No description provided for @whatTiersUnlock.
  ///
  /// In en, this message translates to:
  /// **'What Tiers Unlock'**
  String get whatTiersUnlock;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @passwordRule.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordRule;

  /// No description provided for @termsRenterSection2Point1.
  ///
  /// In en, this message translates to:
  /// **'Access is provided solely through a unique passcode in the app, activated at check-in and deactivated automatically at checkout.'**
  String get termsRenterSection2Point1;

  /// No description provided for @termsRenterSection1Point2.
  ///
  /// In en, this message translates to:
  /// **'A security deposit equal to one night’s rate is collected at booking, whatever the length of stay.'**
  String get termsRenterSection1Point2;

  /// No description provided for @termsRenterSection4Point1.
  ///
  /// In en, this message translates to:
  /// **'Cancel within 1 hour of confirmation for a full refund, no conditions attached.'**
  String get termsRenterSection4Point1;

  /// No description provided for @yourReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Your Referral Code'**
  String get yourReferralCode;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to'**
  String get otpSentTo;

  /// No description provided for @obSub2.
  ///
  /// In en, this message translates to:
  /// **'Smart locks, digital check-in, no hidden surprises.'**
  String get obSub2;

  /// No description provided for @termsBrokerSection4Point1.
  ///
  /// In en, this message translates to:
  /// **'Only verified properties count toward your tier: owner identity verified, smart lock active, professional photography done, inspection passed, and the listing live.'**
  String get termsBrokerSection4Point1;

  /// No description provided for @obTitle1.
  ///
  /// In en, this message translates to:
  /// **'Egypt’s Premier Chalet Platform'**
  String get obTitle1;

  /// No description provided for @reviewsIGave.
  ///
  /// In en, this message translates to:
  /// **'Reviews I Gave'**
  String get reviewsIGave;

  /// No description provided for @resetAccess.
  ///
  /// In en, this message translates to:
  /// **'Reset Access'**
  String get resetAccess;

  /// No description provided for @termsRenterSection1Point5.
  ///
  /// In en, this message translates to:
  /// **'A fraudulent, falsified or borrowed ID means immediate cancellation, forfeiture of all payments, a permanent ban, and referral to the authorities.'**
  String get termsRenterSection1Point5;

  /// No description provided for @termsOwnerSection2Point1.
  ///
  /// In en, this message translates to:
  /// **'Sahely collects all payments from the renter, including the security deposit. No direct payment between owner and renter is permitted.'**
  String get termsOwnerSection2Point1;

  /// No description provided for @termsOwnerSection4Point1.
  ///
  /// In en, this message translates to:
  /// **'The smart lock remains Sahely property and is held by you in custody. Damage or unauthorised removal is charged at replacement cost.'**
  String get termsOwnerSection4Point1;

  /// No description provided for @termsOwnerSection3Point1.
  ///
  /// In en, this message translates to:
  /// **'Withdrawing a listed property or cancelling a confirmed booking is a chargeable violation.'**
  String get termsOwnerSection3Point1;

  /// No description provided for @termsRenterSection1Point6.
  ///
  /// In en, this message translates to:
  /// **'QR access codes and beach passes are issued once the owner completes the security check, and are personal to you and non-transferable.'**
  String get termsRenterSection1Point6;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @termsBrokerSection3Point4.
  ///
  /// In en, this message translates to:
  /// **'Sharing, selling or assigning your referral link so that someone else claims attribution is prohibited.'**
  String get termsBrokerSection3Point4;

  /// No description provided for @brokerPass.
  ///
  /// In en, this message translates to:
  /// **'Broker Pass'**
  String get brokerPass;

  /// No description provided for @termsMasterRulesPoint4.
  ///
  /// In en, this message translates to:
  /// **'Fraud, false claims, harassment, or violence toward anyone connected with Sahely means immediate permanent removal and possible referral to the Egyptian authorities.'**
  String get termsMasterRulesPoint4;

  /// No description provided for @obSub1.
  ///
  /// In en, this message translates to:
  /// **'Verified chalets, villas and beachfront properties.'**
  String get obSub1;

  /// No description provided for @strongPassword.
  ///
  /// In en, this message translates to:
  /// **'Strong Password'**
  String get strongPassword;

  /// No description provided for @statPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statPending;

  /// No description provided for @termsOwnerSection4Point2.
  ///
  /// In en, this message translates to:
  /// **'Compound violations caused by owner negligence are your sole financial responsibility and are deducted from your next payout.'**
  String get termsOwnerSection4Point2;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password Updated'**
  String get passwordUpdated;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @termsBrokerSection2Point2.
  ///
  /// In en, this message translates to:
  /// **'Your rate depends on verified properties this season: Partner 2% (1-14), Silver 3% (15-39), Gold 4% (40-99), Elite 5% (100+). Upgrades apply to active windows immediately.'**
  String get termsBrokerSection2Point2;

  /// No description provided for @obTitle3.
  ///
  /// In en, this message translates to:
  /// **'Earn As You Share'**
  String get obTitle3;

  /// No description provided for @signInNow.
  ///
  /// In en, this message translates to:
  /// **'Sign In Now'**
  String get signInNow;

  /// No description provided for @termsOwnerSection4Point3.
  ///
  /// In en, this message translates to:
  /// **'Damage claims require the Post-Rental Checklist within 24 hours of checkout, with at least 3 photos per damaged item. After 24 hours the right to claim against the deposit is forfeited.'**
  String get termsOwnerSection4Point3;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @termsRenterSection4Point3.
  ///
  /// In en, this message translates to:
  /// **'Last-minute and same-day bookings are non-refundable after the 1-hour grace period, and a no-show earns no refund. The deposit is always returned in full if you cancel before check-in.'**
  String get termsRenterSection4Point3;

  /// No description provided for @sendOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive an OTP'**
  String get sendOtpSubtitle;

  /// No description provided for @forYourAccount.
  ///
  /// In en, this message translates to:
  /// **'For your account'**
  String get forYourAccount;

  /// No description provided for @wrongEmail.
  ///
  /// In en, this message translates to:
  /// **'Wrong Email?'**
  String get wrongEmail;

  /// No description provided for @resendNow.
  ///
  /// In en, this message translates to:
  /// **'Resend Now'**
  String get resendNow;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @termsOwnerSection3Point3.
  ///
  /// In en, this message translates to:
  /// **'The penalty is deducted from your wallet. If the balance is not enough, future payouts are withheld until it is settled.'**
  String get termsOwnerSection3Point3;

  /// No description provided for @termsRenterSection3Point1.
  ///
  /// In en, this message translates to:
  /// **'Return the property in the condition you received it. The maximum occupancy in the listing must never be exceeded.'**
  String get termsRenterSection3Point1;

  /// No description provided for @obSub3.
  ///
  /// In en, this message translates to:
  /// **'Refer friends and earn real rewards.'**
  String get obSub3;

  /// No description provided for @referMore.
  ///
  /// In en, this message translates to:
  /// **'Refer More'**
  String get referMore;

  /// No description provided for @termsOwnerSection3Point4.
  ///
  /// In en, this message translates to:
  /// **'The renter receives a 100% refund, including the deposit, within 5 to 7 business days. Repeated cancellations may lead to removal.'**
  String get termsOwnerSection3Point4;

  /// No description provided for @termsOwnerSection2Point4.
  ///
  /// In en, this message translates to:
  /// **'Violations and deductions are subtracted from your payout, with a full itemised breakdown shown in the app.'**
  String get termsOwnerSection2Point4;

  /// No description provided for @notificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsLabel;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @copyLabel.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyLabel;

  /// No description provided for @addPaymentCard.
  ///
  /// In en, this message translates to:
  /// **'Add Payment Card'**
  String get addPaymentCard;

  /// No description provided for @passwordResetMsg.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully reset'**
  String get passwordResetMsg;

  /// No description provided for @termsMasterRulesPoint1.
  ///
  /// In en, this message translates to:
  /// **'Sahely has final and binding authority over every dispute between owners and renters.'**
  String get termsMasterRulesPoint1;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @termsRenterSection3Point2.
  ///
  /// In en, this message translates to:
  /// **'Sharing your access code with anyone not on the booking forfeits the full deposit and results in a permanent ban.'**
  String get termsRenterSection3Point2;

  /// No description provided for @termsOwnerSection1Point1.
  ///
  /// In en, this message translates to:
  /// **'The minimum listing period is one full calendar month per season, and the property calendar is managed exclusively through the app during the commitment period.'**
  String get termsOwnerSection1Point1;

  /// No description provided for @didntGetIt.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get it?'**
  String get didntGetIt;

  /// No description provided for @tiersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock more rewards as you refer'**
  String get tiersSubtitle;

  /// No description provided for @termsBrokerSection2Point1.
  ///
  /// In en, this message translates to:
  /// **'Every listing opens a 30-day earning window from activation. You earn commission on each paid booking within that window, which cannot be extended.'**
  String get termsBrokerSection2Point1;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get followSystem;

  /// No description provided for @termsAgreeFootnote.
  ///
  /// In en, this message translates to:
  /// **'I agree to the {role} terms'**
  String termsAgreeFootnote(String role);

  /// No description provided for @roleBrokerDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage multiple clients'**
  String get roleBrokerDesc;

  /// No description provided for @roleRenterDesc.
  ///
  /// In en, this message translates to:
  /// **'Book chalets & villas'**
  String get roleRenterDesc;

  /// No description provided for @roleOwnerDesc.
  ///
  /// In en, this message translates to:
  /// **'List & manage properties'**
  String get roleOwnerDesc;

  /// No description provided for @violationReported.
  ///
  /// In en, this message translates to:
  /// **'Violation Reported'**
  String get violationReported;

  /// No description provided for @evidenceVerified.
  ///
  /// In en, this message translates to:
  /// **'Evidence Verified'**
  String get evidenceVerified;

  /// No description provided for @noBtn.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noBtn;

  /// No description provided for @arrivalChecklist.
  ///
  /// In en, this message translates to:
  /// **'Arrival Checklist'**
  String get arrivalChecklist;

  /// No description provided for @forLeavingReview.
  ///
  /// In en, this message translates to:
  /// **'for leaving a review'**
  String get forLeavingReview;

  /// No description provided for @bedsCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Beds'**
  String get bedsCount;

  /// No description provided for @myReviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get myReviews;

  /// No description provided for @establishedHost.
  ///
  /// In en, this message translates to:
  /// **'Established Host'**
  String get establishedHost;

  /// No description provided for @sectionBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get sectionBookings;

  /// No description provided for @pdfFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF'**
  String get pdfFailed;

  /// No description provided for @submitChecklist.
  ///
  /// In en, this message translates to:
  /// **'Submit Checklist'**
  String get submitChecklist;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @reviewHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience…'**
  String get reviewHint;

  /// No description provided for @walletCredit.
  ///
  /// In en, this message translates to:
  /// **'Wallet Credit'**
  String get walletCredit;

  /// No description provided for @yourCommission.
  ///
  /// In en, this message translates to:
  /// **'Your Commission'**
  String get yourCommission;

  /// No description provided for @rebookProperty.
  ///
  /// In en, this message translates to:
  /// **'Rebook This Property'**
  String get rebookProperty;

  /// No description provided for @manageGuests.
  ///
  /// In en, this message translates to:
  /// **'Manage Guests'**
  String get manageGuests;

  /// No description provided for @guestInfo.
  ///
  /// In en, this message translates to:
  /// **'Guest Info'**
  String get guestInfo;

  /// No description provided for @noActiveBookings.
  ///
  /// In en, this message translates to:
  /// **'No active bookings'**
  String get noActiveBookings;

  /// No description provided for @bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathrooms;

  /// No description provided for @confirmEverything.
  ///
  /// In en, this message translates to:
  /// **'Confirm Everything'**
  String get confirmEverything;

  /// No description provided for @smartLockEnabled.
  ///
  /// In en, this message translates to:
  /// **'Smart Lock Enabled'**
  String get smartLockEnabled;

  /// No description provided for @mixedGroupsLabel.
  ///
  /// In en, this message translates to:
  /// **'Mixed Groups'**
  String get mixedGroupsLabel;

  /// No description provided for @promotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotions;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Payment Card'**
  String get paymentCard;

  /// No description provided for @partyAllowedQ.
  ///
  /// In en, this message translates to:
  /// **'Are parties allowed?'**
  String get partyAllowedQ;

  /// No description provided for @continueSetup.
  ///
  /// In en, this message translates to:
  /// **'Continue Setup'**
  String get continueSetup;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameHint;

  /// No description provided for @bookingUpdates.
  ///
  /// In en, this message translates to:
  /// **'Booking Updates'**
  String get bookingUpdates;

  /// No description provided for @accessExpired.
  ///
  /// In en, this message translates to:
  /// **'Access Expired'**
  String get accessExpired;

  /// No description provided for @childrenLabel.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get childrenLabel;

  /// No description provided for @selectFutureDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a future date'**
  String get selectFutureDate;

  /// No description provided for @calmHours.
  ///
  /// In en, this message translates to:
  /// **'Calm Hours'**
  String get calmHours;

  /// No description provided for @updateMe.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateMe;

  /// No description provided for @estArrival.
  ///
  /// In en, this message translates to:
  /// **'Estimated Arrival'**
  String get estArrival;

  /// No description provided for @blockThisRenter.
  ///
  /// In en, this message translates to:
  /// **'Block This Renter'**
  String get blockThisRenter;

  /// No description provided for @propertyType.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get propertyType;

  /// No description provided for @infantsAges.
  ///
  /// In en, this message translates to:
  /// **'Under 2'**
  String get infantsAges;

  /// No description provided for @managementTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get managementTitle;

  /// No description provided for @stayEnded.
  ///
  /// In en, this message translates to:
  /// **'Stay Ended'**
  String get stayEnded;

  /// No description provided for @selectedDatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected Dates'**
  String get selectedDatesLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @openBadge.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openBadge;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @changeLabel.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeLabel;

  /// No description provided for @keepMine.
  ///
  /// In en, this message translates to:
  /// **'Keep My Account'**
  String get keepMine;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @guestsCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Guests'**
  String get guestsCount;

  /// No description provided for @totalPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get totalPayment;

  /// No description provided for @saveAccount.
  ///
  /// In en, this message translates to:
  /// **'Save Account'**
  String get saveAccount;

  /// No description provided for @requestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requestsTitle;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @noProperties.
  ///
  /// In en, this message translates to:
  /// **'No properties yet'**
  String get noProperties;

  /// No description provided for @viewSubmissionStatus.
  ///
  /// In en, this message translates to:
  /// **'View Submission Status'**
  String get viewSubmissionStatus;

  /// No description provided for @draftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get draftSaved;

  /// No description provided for @submitReviewBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReviewBtn;

  /// No description provided for @statActiveBookings.
  ///
  /// In en, this message translates to:
  /// **'Active Bookings'**
  String get statActiveBookings;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// No description provided for @bookingUpdatesSub.
  ///
  /// In en, this message translates to:
  /// **'Confirmations, cancellations & changes'**
  String get bookingUpdatesSub;

  /// No description provided for @locationSelected.
  ///
  /// In en, this message translates to:
  /// **'Location Selected'**
  String get locationSelected;

  /// No description provided for @min5Photos.
  ///
  /// In en, this message translates to:
  /// **'Minimum 5 photos required'**
  String get min5Photos;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @withdrawBtn.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdrawBtn;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @withdrawToBank.
  ///
  /// In en, this message translates to:
  /// **'Withdraw to Bank'**
  String get withdrawToBank;

  /// No description provided for @manageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your properties and bookings'**
  String get manageSubtitle;

  /// No description provided for @checkinAccess.
  ///
  /// In en, this message translates to:
  /// **'Check-in Access'**
  String get checkinAccess;

  /// No description provided for @keepEarning.
  ///
  /// In en, this message translates to:
  /// **'Keep Earning'**
  String get keepEarning;

  /// No description provided for @violationReport.
  ///
  /// In en, this message translates to:
  /// **'Violation Report'**
  String get violationReport;

  /// No description provided for @checkOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOutLabel;

  /// No description provided for @deductionAmount.
  ///
  /// In en, this message translates to:
  /// **'Deduction Amount'**
  String get deductionAmount;

  /// No description provided for @dateReported.
  ///
  /// In en, this message translates to:
  /// **'Date Reported'**
  String get dateReported;

  /// No description provided for @promotionsSub.
  ///
  /// In en, this message translates to:
  /// **'Special offers and deals'**
  String get promotionsSub;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @numberOfBeds.
  ///
  /// In en, this message translates to:
  /// **'Number of Beds'**
  String get numberOfBeds;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @guestFavourite.
  ///
  /// In en, this message translates to:
  /// **'Guest Favourite'**
  String get guestFavourite;

  /// No description provided for @bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get bedrooms;

  /// No description provided for @whatTeamNeeds.
  ///
  /// In en, this message translates to:
  /// **'What the team needs'**
  String get whatTeamNeeds;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @addedLabel.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get addedLabel;

  /// No description provided for @selectView.
  ///
  /// In en, this message translates to:
  /// **'Select View'**
  String get selectView;

  /// No description provided for @financialImpact.
  ///
  /// In en, this message translates to:
  /// **'Financial Impact'**
  String get financialImpact;

  /// No description provided for @dragPin.
  ///
  /// In en, this message translates to:
  /// **'Drag the pin to your property'**
  String get dragPin;

  /// No description provided for @starsLevelUpsSub.
  ///
  /// In en, this message translates to:
  /// **'Earn stars for actions'**
  String get starsLevelUpsSub;

  /// No description provided for @ownerWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get ownerWelcomeBack;

  /// No description provided for @statEgpMonth.
  ///
  /// In en, this message translates to:
  /// **'EGP / month'**
  String get statEgpMonth;

  /// No description provided for @viewLabel.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewLabel;

  /// No description provided for @emailChannel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailChannel;

  /// No description provided for @fundsArriveNote.
  ///
  /// In en, this message translates to:
  /// **'Funds typically arrive within 3–5 business days'**
  String get fundsArriveNote;

  /// No description provided for @useLabel.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get useLabel;

  /// No description provided for @payoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Payout Account'**
  String get payoutAccount;

  /// No description provided for @referralCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCodeLabel;

  /// No description provided for @requiredShots.
  ///
  /// In en, this message translates to:
  /// **'Required Shots'**
  String get requiredShots;

  /// No description provided for @petsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get petsLabel;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @hostsSayAboutMe.
  ///
  /// In en, this message translates to:
  /// **'What hosts say about me'**
  String get hostsSayAboutMe;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @starsEarned.
  ///
  /// In en, this message translates to:
  /// **'Stars Earned'**
  String get starsEarned;

  /// No description provided for @deductionCalculated.
  ///
  /// In en, this message translates to:
  /// **'Deduction calculated'**
  String get deductionCalculated;

  /// No description provided for @phoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone Verified'**
  String get phoneVerified;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequests;

  /// No description provided for @floorIfApartment.
  ///
  /// In en, this message translates to:
  /// **'Floor (if apartment)'**
  String get floorIfApartment;

  /// No description provided for @downloadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Download Receipt'**
  String get downloadReceipt;

  /// No description provided for @noPastStays.
  ///
  /// In en, this message translates to:
  /// **'No past stays'**
  String get noPastStays;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @messagesSupportSub.
  ///
  /// In en, this message translates to:
  /// **'Chat messages and support replies'**
  String get messagesSupportSub;

  /// No description provided for @exactAddress.
  ///
  /// In en, this message translates to:
  /// **'Exact Address'**
  String get exactAddress;

  /// No description provided for @statPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statPaid;

  /// No description provided for @confirmDecline.
  ///
  /// In en, this message translates to:
  /// **'Confirm Decline'**
  String get confirmDecline;

  /// No description provided for @bankEncryptedNote.
  ///
  /// In en, this message translates to:
  /// **'Your bank details are encrypted and secure'**
  String get bankEncryptedNote;

  /// No description provided for @smartLockOnlyActive.
  ///
  /// In en, this message translates to:
  /// **'Smart lock is only active during the booking period'**
  String get smartLockOnlyActive;

  /// No description provided for @confirmPay.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Pay'**
  String get confirmPay;

  /// No description provided for @guestSummary.
  ///
  /// In en, this message translates to:
  /// **'Guest Summary'**
  String get guestSummary;

  /// No description provided for @checkinAccessSub.
  ///
  /// In en, this message translates to:
  /// **'Smart lock codes and door access'**
  String get checkinAccessSub;

  /// No description provided for @supportedLanguages.
  ///
  /// In en, this message translates to:
  /// **'Supported Languages'**
  String get supportedLanguages;

  /// No description provided for @activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeLabel;

  /// No description provided for @pastLabel.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get pastLabel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @makeChangesResubmit.
  ///
  /// In en, this message translates to:
  /// **'Make Changes & Resubmit'**
  String get makeChangesResubmit;

  /// No description provided for @blockRenter.
  ///
  /// In en, this message translates to:
  /// **'Block Renter'**
  String get blockRenter;

  /// No description provided for @addLabel.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addLabel;

  /// No description provided for @bankAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get bankAccountNumber;

  /// No description provided for @addSocial.
  ///
  /// In en, this message translates to:
  /// **'Add Social'**
  String get addSocial;

  /// No description provided for @seasonTotal.
  ///
  /// In en, this message translates to:
  /// **'Season Total'**
  String get seasonTotal;

  /// No description provided for @priceRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Price Recommendation'**
  String get priceRecommendation;

  /// No description provided for @manageDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get manageDashboard;

  /// No description provided for @compoundLayoutShot.
  ///
  /// In en, this message translates to:
  /// **'Compound Layout'**
  String get compoundLayoutShot;

  /// No description provided for @availableToWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Available to Withdraw'**
  String get availableToWithdraw;

  /// No description provided for @statUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statUpcoming;

  /// No description provided for @doneLabel.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneLabel;

  /// No description provided for @emailConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Email Confirmed'**
  String get emailConfirmed;

  /// No description provided for @myProperties.
  ///
  /// In en, this message translates to:
  /// **'My Properties'**
  String get myProperties;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineTitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @tabLabel.
  ///
  /// In en, this message translates to:
  /// **'Tab'**
  String get tabLabel;

  /// No description provided for @accountVerification.
  ///
  /// In en, this message translates to:
  /// **'Account Verification'**
  String get accountVerification;

  /// No description provided for @metersFromSea.
  ///
  /// In en, this message translates to:
  /// **'Meters from Sea'**
  String get metersFromSea;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noPets.
  ///
  /// In en, this message translates to:
  /// **'No Pets'**
  String get noPets;

  /// No description provided for @noUpcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings'**
  String get noUpcomingBookings;

  /// No description provided for @verifiedRenter.
  ///
  /// In en, this message translates to:
  /// **'Verified Renter'**
  String get verifiedRenter;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @photoGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Photo Guidelines'**
  String get photoGuidelines;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReview;

  /// No description provided for @petsAllowedQ.
  ///
  /// In en, this message translates to:
  /// **'Are pets allowed?'**
  String get petsAllowedQ;

  /// No description provided for @approveRequest.
  ///
  /// In en, this message translates to:
  /// **'Approve Request'**
  String get approveRequest;

  /// No description provided for @addCardToWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Add a card to withdraw'**
  String get addCardToWithdraw;

  /// No description provided for @propertyNo.
  ///
  /// In en, this message translates to:
  /// **'Property No.'**
  String get propertyNo;

  /// No description provided for @includedInStay.
  ///
  /// In en, this message translates to:
  /// **'Included in Stay'**
  String get includedInStay;

  /// No description provided for @chatWithReviewer.
  ///
  /// In en, this message translates to:
  /// **'Chat with Reviewer'**
  String get chatWithReviewer;

  /// No description provided for @swiftBic.
  ///
  /// In en, this message translates to:
  /// **'SWIFT / BIC'**
  String get swiftBic;

  /// No description provided for @accountHolder.
  ///
  /// In en, this message translates to:
  /// **'Account Holder'**
  String get accountHolder;

  /// No description provided for @noAmenitiesYet.
  ///
  /// In en, this message translates to:
  /// **'No amenities listed yet'**
  String get noAmenitiesYet;

  /// No description provided for @aiInsight.
  ///
  /// In en, this message translates to:
  /// **'AI Insight'**
  String get aiInsight;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @amenityPool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get amenityPool;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @withdrawalRequested.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Requested'**
  String get withdrawalRequested;

  /// No description provided for @describeHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the property…'**
  String get describeHint;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @reviewResult.
  ///
  /// In en, this message translates to:
  /// **'Review Submitted'**
  String get reviewResult;

  /// No description provided for @floorsInUnit.
  ///
  /// In en, this message translates to:
  /// **'Floors in Unit'**
  String get floorsInUnit;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @everyToiletShot.
  ///
  /// In en, this message translates to:
  /// **'Every Bathroom'**
  String get everyToiletShot;

  /// No description provided for @amenitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenitiesTitle;

  /// No description provided for @mixedGroupsAllowedQ.
  ///
  /// In en, this message translates to:
  /// **'Are mixed groups allowed?'**
  String get mixedGroupsAllowedQ;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @appliedToPayout.
  ///
  /// In en, this message translates to:
  /// **'Applied to payout'**
  String get appliedToPayout;

  /// No description provided for @upcomingLabel.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingLabel;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepOf(int step, int total);

  /// No description provided for @bookingInfo.
  ///
  /// In en, this message translates to:
  /// **'Booking Info'**
  String get bookingInfo;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF…'**
  String get generatingPdf;

  /// No description provided for @marassiHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Marassi, North Coast'**
  String get marassiHint;

  /// No description provided for @passcodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Passcode Copied'**
  String get passcodeCopied;

  /// No description provided for @guestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guestsLabel;

  /// No description provided for @cancelBookingQ.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelBookingQ;

  /// No description provided for @deleteMe.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteMe;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationTitle;

  /// No description provided for @reviewsSection.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsSection;

  /// No description provided for @requestedLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requestedLabel;

  /// No description provided for @checkInLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkInLabel;

  /// No description provided for @howWasStay.
  ///
  /// In en, this message translates to:
  /// **'How was your stay?'**
  String get howWasStay;

  /// No description provided for @partiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Parties'**
  String get partiesLabel;

  /// No description provided for @identityVerified.
  ///
  /// In en, this message translates to:
  /// **'Identity Verified'**
  String get identityVerified;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @mixedGroupsOk.
  ///
  /// In en, this message translates to:
  /// **'Mixed Groups OK'**
  String get mixedGroupsOk;

  /// No description provided for @ibanLabel.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get ibanLabel;

  /// No description provided for @uploadPhotos.
  ///
  /// In en, this message translates to:
  /// **'Upload Photos'**
  String get uploadPhotos;

  /// No description provided for @payoutNote.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals go to your linked bank account'**
  String get payoutNote;

  /// No description provided for @guestFallback.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestFallback;

  /// No description provided for @evidenceProvided.
  ///
  /// In en, this message translates to:
  /// **'Evidence Provided'**
  String get evidenceProvided;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @petsOk.
  ///
  /// In en, this message translates to:
  /// **'Pets OK'**
  String get petsOk;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @referenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get referenceLabel;

  /// No description provided for @outsideDoorShot.
  ///
  /// In en, this message translates to:
  /// **'Outside Door'**
  String get outsideDoorShot;

  /// No description provided for @sectionChannels.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get sectionChannels;

  /// No description provided for @houseRules.
  ///
  /// In en, this message translates to:
  /// **'House Rules'**
  String get houseRules;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @coverLabel.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get coverLabel;

  /// No description provided for @amenityParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get amenityParking;

  /// No description provided for @notifyWhenSent.
  ///
  /// In en, this message translates to:
  /// **'Notify when sent'**
  String get notifyWhenSent;

  /// No description provided for @toAccount.
  ///
  /// In en, this message translates to:
  /// **'To Account'**
  String get toAccount;

  /// No description provided for @issueQ.
  ///
  /// In en, this message translates to:
  /// **'What is the issue?'**
  String get issueQ;

  /// No description provided for @smartLockCode.
  ///
  /// In en, this message translates to:
  /// **'Smart Lock Code'**
  String get smartLockCode;

  /// No description provided for @passcodeLocked.
  ///
  /// In en, this message translates to:
  /// **'Passcode Locked'**
  String get passcodeLocked;

  /// No description provided for @propertyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Property Name'**
  String get propertyNameLabel;

  /// No description provided for @floorsCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Floors'**
  String get floorsCount;

  /// No description provided for @ownerNotified.
  ///
  /// In en, this message translates to:
  /// **'Owner Notified'**
  String get ownerNotified;

  /// No description provided for @accountNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Account Not Verified'**
  String get accountNotVerified;

  /// No description provided for @starsLevelUps.
  ///
  /// In en, this message translates to:
  /// **'Stars & Level Ups'**
  String get starsLevelUps;

  /// No description provided for @verifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedBadge;

  /// No description provided for @allowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get allowed;

  /// No description provided for @blockLabel.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get blockLabel;

  /// No description provided for @adultsAges.
  ///
  /// In en, this message translates to:
  /// **'Ages 13+'**
  String get adultsAges;

  /// No description provided for @cleaningFee.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Fee'**
  String get cleaningFee;

  /// No description provided for @checklistNote.
  ///
  /// In en, this message translates to:
  /// **'Complete this checklist on arrival'**
  String get checklistNote;

  /// No description provided for @viewChecklist.
  ///
  /// In en, this message translates to:
  /// **'View Checklist'**
  String get viewChecklist;

  /// No description provided for @manageDoorAccess.
  ///
  /// In en, this message translates to:
  /// **'Manage Door Access'**
  String get manageDoorAccess;

  /// No description provided for @planYourStay.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Stay'**
  String get planYourStay;

  /// No description provided for @compoundArea.
  ///
  /// In en, this message translates to:
  /// **'Compound / Area'**
  String get compoundArea;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @declineRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline Request'**
  String get declineRequest;

  /// No description provided for @amenityWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get amenityWifi;

  /// No description provided for @submitListing.
  ///
  /// In en, this message translates to:
  /// **'Submit Listing'**
  String get submitListing;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @balconyViewShot.
  ///
  /// In en, this message translates to:
  /// **'Balcony View'**
  String get balconyViewShot;

  /// No description provided for @infants.
  ///
  /// In en, this message translates to:
  /// **'Infants'**
  String get infants;

  /// No description provided for @reportSaved.
  ///
  /// In en, this message translates to:
  /// **'Report Saved'**
  String get reportSaved;

  /// No description provided for @orderNo.
  ///
  /// In en, this message translates to:
  /// **'Order No.'**
  String get orderNo;

  /// No description provided for @messagesSupport.
  ///
  /// In en, this message translates to:
  /// **'Messages & Support'**
  String get messagesSupport;

  /// No description provided for @statProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get statProperties;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @dragDrop.
  ///
  /// In en, this message translates to:
  /// **'Drag & Drop to reorder'**
  String get dragDrop;

  /// No description provided for @customFeatures.
  ///
  /// In en, this message translates to:
  /// **'Custom Features'**
  String get customFeatures;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @reviewsIGaveTab.
  ///
  /// In en, this message translates to:
  /// **'Reviews I Gave'**
  String get reviewsIGaveTab;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// No description provided for @amountToWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Amount to Withdraw'**
  String get amountToWithdraw;

  /// No description provided for @adults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get adults;

  /// No description provided for @pendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingLabel;

  /// No description provided for @vatLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get vatLabel;

  /// No description provided for @arrivals.
  ///
  /// In en, this message translates to:
  /// **'Arrivals'**
  String get arrivals;

  /// No description provided for @unitStreetHint.
  ///
  /// In en, this message translates to:
  /// **'Unit / Street'**
  String get unitStreetHint;

  /// No description provided for @stayed.
  ///
  /// In en, this message translates to:
  /// **'Stayed'**
  String get stayed;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @cancelledLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledLabel;

  /// No description provided for @viewMyBookings.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get viewMyBookings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'it',
        'ru'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
