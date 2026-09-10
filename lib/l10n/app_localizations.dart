import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Supported languages must match assets/translations/*.json files.
class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<String> supportedLanguages = [
    'en', 'ar', 'fr', 'de', 'it', 'es', 'ru',
  ];

  static const Locale fallbackLocale = Locale('en');

  final Map<String, String> _localizedStrings;

  AppLocalizations(this._localizedStrings);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Generic accessor — falls back to the key itself when missing.
  String t(String key) => _localizedStrings[key] ?? key;

  /// Like [t] but replaces {placeholder} tokens with the given values.
  String tf(String key, Map<String, String> params) {
    var s = t(key);
    params.forEach((name, value) => s = s.replaceAll('{$name}', value));
    return s;
  }

  bool get isRtl => _localizedStrings['__rtl__'] == 'true';

  // --- Language screen ---
  String get language => t('language');
  String get chooseLanguage => t('chooseLanguage');
  String get save => t('save');
  String get english => t('english');
  String get arabic => t('arabic');
  String get french => t('french');
  String get german => t('german');
  String get italian => t('italian');
  String get spanish => t('spanish');
  String get russian => t('russian');

  // --- App ---
  String get appName => t('appName');
  String get guestFallback => t('guestFallback');
  String get tagline => t('tagline');

  // --- Auth ---
  String get welcome => t('welcome');
  String get signIn => t('signIn');
  String get signUp => t('signUp');
  String get forgotPassword => t('forgotPassword');
  String get email => t('email');
  String get password => t('password');
  String get confirmPassword => t('confirmPassword');
  String get requiredField => t('requiredField');
  String get enterValidEmail => t('enterValidEmail');
  String get enterValidPhone => t('enterValidPhone');
  String get passwordMinChars => t('passwordMinChars');
  String get passwordsDoNotMatch => t('passwordsDoNotMatch');
  String get mustAgreeTerms => t('mustAgreeTerms');
  String get didntGetIt => t('didntGetIt');
  String get networkError => t('networkError');
  String get emailRequired => t('emailRequired');
  String get passwordRequired => t('passwordRequired');
  String get invalidCredentials => t('invalidCredentials');
  String get accountSuspended => t('accountSuspended');
  String accountSuspendedWithDetails(String date, String reason) => 
      tf('accountSuspended', {'date': date, 'reason': reason});
  String get accountBanned => t('accountBanned');
  String get rateLimit => t('rateLimit');
  String get noInternet => t('noInternet');
  String get serverError => t('serverError');
  String get retry => t('retry');
  String get otpRequired => t('otpRequired');
  String get invalidOtp => t('invalidOtp');
  String get otpExpired => t('otpExpired');

  // --- Navigation ---
  String get home => t('home');
  String get wishlist => t('wishlist');
  String get bookings => t('bookings');
  String get profile => t('profile');
  String get services => t('services');

  // --- Property ---
  String get perNight => t('perNight');
  String get reviews => t('reviews');
  String get bookNow => t('bookNow');

  // --- Common ---
  String get search => t('search');
  String get filter => t('filter');
  String get seeAll => t('seeAll');
  String get loading => t('loading');
  String get error => t('error');
  String get cancel => t('cancel');
  String get delete => t('delete');
  String get edit => t('edit');
  String get close => t('close');

  // --- Bottom navigation ---
  String get navHome => t('navHome');
  String get navWishlist => t('navWishlist');
  String get navBookings => t('navBookings');
  String get navServices => t('navServices');
  String get navProfile => t('navProfile');
  String get navManage => t('navManage');
  String get navMyRole => t('navMyRole');
  String get navReferrals => t('navReferrals');
  String get navWallet => t('navWallet');

  // --- Roles & home ---
  String get goodMorning => t('goodMorning');
  String get renter => t('renter');
  String get owner => t('owner');
  String get broker => t('broker');
  String get findYourPerfectStay => t('findYourPerfectStay');
  String get catAll => t('catAll');
  String get catVilla => t('catVilla');
  String get catChalet => t('catChalet');
  String get catPenthouse => t('catPenthouse');
  String get catBeachfront => t('catBeachfront');
  String get catPool => t('catPool');

  // --- Browse/search ---
  String get staysSuffix => t('staysSuffix');
  String get topRatedSection => t('topRatedSection');

  // --- Property card ---
  String get guestFavourite => t('guestFavourite');
  String get petsOk => t('petsOk');
  String get noPets => t('noPets');

  // --- Auth screens ---
  String get welcomeTagline => t('welcomeTagline');
  String get welcomeSubtitle => t('welcomeSubtitle');
  String get getStarted => t('getStarted');
  String get alreadyHaveAccount => t('alreadyHaveAccount');
  String get welcomeBack => t('welcomeBack');
  String get signInSubtitle => t('signInSubtitle');
  String get emailAddress => t('emailAddress');
  String get orContinueWith => t('orContinueWith');
  String get continueGoogle => t('continueGoogle');
  String get continueApple => t('continueApple');
  String get newToSahely => t('newToSahely');
  String get createAccount => t('createAccount');

  // --- Bookings ---
  String get tabUpcoming => t('tabUpcoming');
  String get tabActive => t('tabActive');
  String get tabPast => t('tabPast');
  String get noUpcomingBookings => t('noUpcomingBookings');
  String get noActiveBookings => t('noActiveBookings');
  String get noPastStays => t('noPastStays');

  // --- Onboarding & roles ---
  String get obTitle1 => t('obTitle1');
  String get obSub1 => t('obSub1');
  String get obTitle2 => t('obTitle2');
  String get obSub2 => t('obSub2');
  String get obTitle3 => t('obTitle3');
  String get obSub3 => t('obSub3');
  String get skip => t('skip');
  String get next => t('next');
  String get continueBtn => t('continueBtn');
  String get howUseSahely => t('howUseSahely');
  String get roleSubtitle => t('roleSubtitle');
  String get roleRenterDesc => t('roleRenterDesc');
  String get roleOwnerTitle => t('roleOwnerTitle');
  String get roleOwnerDesc => t('roleOwnerDesc');
  String get roleBrokerDesc => t('roleBrokerDesc');

  // --- Create account ---
  String get registeringAs => t('registeringAs');
  String get fullName => t('fullName');
  String get fullNameHint => t('fullNameHint');
  String get phoneNumber => t('phoneNumber');
  String get dateOfBirth => t('dateOfBirth');
  String get day => t('day');
  String get month => t('month');
  String get year => t('year');

  // --- OTP ---
  String get otpSentTo => t('otpSentTo');
  String get otpEnterCode => t('otpEnterCode');
  String get resendNow => t('resendNow');
  String get resendIn => t('resendIn');
  String get wrongEmail => t('wrongEmail');
  String get verifyEmailTitle => t('verifyEmailTitle');
  String get verifyEmailHint => t('verifyEmailHint');
  String get verifyEmailCta => t('verifyEmailCta');
  String get verifyNumberTitle => t('verifyNumberTitle');
  String get verifyNumberHint => t('verifyNumberHint');
  String get verifyNumberCta => t('verifyNumberCta');
  String get verifyNumberBottom => t('verifyNumberBottom');
  String get enterCodeTitle => t('enterCodeTitle');
  String get sentTo => t('sentTo');

  // --- Forgot password ---
  String get resetAccess => t('resetAccess');
  String get sendOtp => t('sendOtp');
  String get backToSignIn => t('backToSignIn');
  String get setNewPassword => t('setNewPassword');
  String get passwordRule => t('passwordRule');
  String get newPassword => t('newPassword');
  String get strongPassword => t('strongPassword');
  String get updatePassword => t('updatePassword');
  String get passwordUpdated => t('passwordUpdated');
  String get passwordResetMsg => t('passwordResetMsg');
  String get signInNow => t('signInNow');
  String get sendOtpSubtitle => t('sendOtpSubtitle');
  String get verifyOtpCta => t('verifyOtpCta');

  // --- Property detail ---
  String get amenitiesTitle => t('amenitiesTitle');
  String get amenityPool => t('amenityPool');
  String get amenityWifi => t('amenityWifi');
  String get amenityParking => t('amenityParking');
  String get showMore => t('showMore');
  String get showLess => t('showLess');
  String get mixedGroupsOk => t('mixedGroupsOk');
  String get houseRules => t('houseRules');
  String get calmHours => t('calmHours');
  String get partiesLabel => t('partiesLabel');
  String get petsLabel => t('petsLabel');
  String get mixedGroupsLabel => t('mixedGroupsLabel');
  String get allowed => t('allowed');
  String get locationTitle => t('locationTitle');
  String get reviewsSection => t('reviewsSection');
  String get smartLockCode => t('smartLockCode');
  String get smartLockEnabled => t('smartLockEnabled');

  // --- Booking flow ---
  String get selectDate => t('selectDate');
  String get selectFutureDate => t('selectFutureDate');
  String get selectedDatesLabel => t('selectedDatesLabel');
  String get planYourStay => t('planYourStay');
  String get checkInLabel => t('checkInLabel');
  String get checkOutLabel => t('checkOutLabel');
  String get adults => t('adults');
  String get adultsAges => t('adultsAges');
  String get childrenLabel => t('childrenLabel');
  String get childrenAges => t('childrenAges');
  String get infants => t('infants');
  String get infantsAges => t('infantsAges');
  String get cleaningFee => t('cleaningFee');
  String get vatLabel => t('vatLabel');
  String get totalLabel => t('totalLabel');
  String get confirmPay => t('confirmPay');
  String floorsCount(num n) => tf('floorsCount', {'n': '$n'});
  String guestsCount(num n) => tf('guestsCount', {'n': '$n'});
  String bedsCount(num n) => tf('bedsCount', {'n': '$n'});

  // --- Wishlist ---
  String get brokerWishlist => t('brokerWishlist');
  String get newLabel => t('newLabel');

  // --- Profile ---
  String get accountVerification => t('accountVerification');
  String get emailConfirmed => t('emailConfirmed');
  String get phoneVerified => t('phoneVerified');
  String get identityVerified => t('identityVerified');
  String get paymentCard => t('paymentCard');
  String get verifyNow => t('verifyNow');
  String get addCard => t('addCard');
  String get addSocial => t('addSocial');
  String get logOut => t('logOut');
  String get walletCredit => t('walletCredit');
  String get paymentMethods => t('paymentMethods');
  String get notificationsLabel => t('notificationsLabel');
  String get changePassword => t('changePassword');
  String get languageLabel => t('languageLabel');
  String get currencyLabel => t('currencyLabel');

  // --- Notification settings ---
  String get notificationsTitle => t('notificationsTitle');
  String get sectionBookings => t('sectionBookings');
  String get sectionChannels => t('sectionChannels');
  String get bookingUpdates => t('bookingUpdates');
  String get bookingUpdatesSub => t('bookingUpdatesSub');
  String get checkinAccess => t('checkinAccess');
  String get checkinAccessSub => t('checkinAccessSub');
  String get messagesSupport => t('messagesSupport');
  String get messagesSupportSub => t('messagesSupportSub');
  String get starsLevelUps => t('starsLevelUps');
  String get starsLevelUpsSub => t('starsLevelUpsSub');
  String get promotions => t('promotions');
  String get promotionsSub => t('promotionsSub');
  String get pushNotifications => t('pushNotifications');
  String get emailChannel => t('emailChannel');

  // --- Smart lock & checklist ---
  String get passcodeCopied => t('passcodeCopied');
  String get accessExpired => t('accessExpired');
  String get yourDoorPasscode => t('yourDoorPasscode');
  String get passcodeLocked => t('passcodeLocked');
  String get stayEnded => t('stayEnded');
  String get smartLockOnlyActive => t('smartLockOnlyActive');
  String get arrivalChecklist => t('arrivalChecklist');
  String get confirmEverything => t('confirmEverything');
  String get checklistNote => t('checklistNote');
  String get submitChecklist => t('submitChecklist');
  String get issueQ => t('issueQ');
  String get chkPool => t('chkPool');
  String get chkWifi => t('chkWifi');
  String get chkAc => t('chkAc');
  String get chkBeds => t('chkBeds');
  String get chkBeachTags => t('chkBeachTags');
  String get chkKitchen => t('chkKitchen');

  // --- Owner screens ---
  String get ownerWelcomeBack => t('ownerWelcomeBack');
  String get myProperties => t('myProperties');
  String get addLabel => t('addLabel');
  String get noProperties => t('noProperties');
  String get tabPaused => t('tabPaused');
  String get tabUnderReview => t('tabUnderReview');
  String get tabDraft => t('tabDraft');
  String get tabAll => t('tabAll');
  String get continueSetup => t('continueSetup');
  String get viewSubmissionStatus => t('viewSubmissionStatus');
  String get manageGuests => t('manageGuests');
  String get orderNo => t('orderNo');
  String get generatingPdf => t('generatingPdf');
  String get reportSaved => t('reportSaved');
  String get pdfFailed => t('pdfFailed');
  String get statUpcoming => t('statUpcoming');
  String get statPaid => t('statPaid');
  String get statPending => t('statPending');
  String get requestsTitle => t('requestsTitle');
  String get requestDetails => t('requestDetails');
  String get verifiedBadge => t('verifiedBadge');
  String get bookingInfo => t('bookingInfo');
  String get aiInsight => t('aiInsight');
  String get approveRequest => t('approveRequest');
  String get declineRequest => t('declineRequest');
  String get declineReasonPrompt => t('declineReasonPrompt');
  String get confirmDecline => t('confirmDecline');
  String get requestDeclined => t('requestDeclined');
  String get requestApproved => t('requestApproved');
  String get blockRenter => t('blockRenter');
  String get blockThisRenter => t('blockThisRenter');
  String get blockLabel => t('blockLabel');
  String get manageDashboard => t('manageDashboard');
  String get manageSubtitle => t('manageSubtitle');
  String get myReviews => t('myReviews');
  String get payoutBank => t('payoutBank');

  // --- Broker screens ---
  String get trendingNow => t('trendingNow');
  String get statEarnedMo => t('statEarnedMo');
  String get accountNotVerified => t('accountNotVerified');
  String get addCardToWithdraw => t('addCardToWithdraw');
  String get editProfile => t('editProfile');
  String get goldBroker => t('goldBroker');
  String get tierCommissionsPortfolio => t('tierCommissionsPortfolio');
  String get goldTierCommission => t('goldTierCommission');
  String get addPaymentCard => t('addPaymentCard');
  String get forYourAccount => t('forYourAccount');
  String get yourReferralCode => t('yourReferralCode');
  String get copyLabel => t('copyLabel');
  String get reviewsIGave => t('reviewsIGave');

  // --- Booking details & post-booking ---
  String get guestInfo => t('guestInfo');
  String get verifiedRenter => t('verifiedRenter');
  String get yourCommission => t('yourCommission');
  String get manageDoorAccess => t('manageDoorAccess');
  String get viewChecklist => t('viewChecklist');
  String get totalPayment => t('totalPayment');
  String get cancelBooking => t('cancelBooking');
  String get cancelBookingQ => t('cancelBookingQ');
  String get noLabel => t('noLabel');
  String get yesCancel => t('yesCancel');
  String get guestSummary => t('guestSummary');
  String get includedInStay => t('includedInStay');
  String get totalPaid => t('totalPaid');
  String get rebookProperty => t('rebookProperty');
  String get thisMonth => t('thisMonth');
  String get lastMonth => t('lastMonth');
  String get youreAllSet => t('youreAllSet');
  String get guestsLabel => t('guestsLabel');
  String get viewMyBookings => t('viewMyBookings');
  String get starsEarned => t('starsEarned');
  String get forLeavingReview => t('forLeavingReview');
  String get seasonTotal => t('seasonTotal');
  String get keepEarning => t('keepEarning');
  String bookingConfirmedMsg(String name) =>
      tf('bookingConfirmedMsg', {'name': name});

  // --- Reviews & misc ---
  String get writeReview => t('writeReview');
  String get howWasStay => t('howWasStay');
  String get yourReview => t('yourReview');
  String get reviewHint => t('reviewHint');
  String get submitReviewBtn => t('submitReviewBtn');
  String get stayed => t('stayed');
  String get reviewsIGaveTab => t('reviewsIGaveTab');
  String get aboutMe => t('aboutMe');
  String get hostsSayAboutMe => t('hostsSayAboutMe');
  String get maybeLater => t('maybeLater');
  String get establishedHost => t('establishedHost');
  String get statProperties => t('statProperties');
  String get statActiveBookings => t('statActiveBookings');
  String get statEgpMonth => t('statEgpMonth');
  String get pendingRequests => t('pendingRequests');
  String get viewAll => t('viewAll');
  String get brokerPass => t('brokerPass');
  String get the4Tiers => t('the4Tiers');
  String get tiersSubtitle => t('tiersSubtitle');
  String get whatTiersUnlock => t('whatTiersUnlock');
  String get referMore => t('referMore');

  // --- Add property ---
  String get stepBasics => t('stepBasics');
  String get stepLocation => t('stepLocation');
  String get stepFeatures => t('stepFeatures');
  String get stepPhotos => t('stepPhotos');
  String get acAllRooms => t('acAllRooms');
  String get smartTv => t('smartTv');
  String get wifi200 => t('wifi200');
  String get equippedKitchen => t('equippedKitchen');
  String get cleaningArrival => t('cleaningArrival');
  String get safeBox => t('safeBox');
  String get rollerShutters => t('rollerShutters');
  String get microwave => t('microwave');
  String get nespresso => t('nespresso');
  String get addProperty => t('addProperty');
  String stepOf(num step, num total) =>
      tf('stepOf', {'step': '$step', 'total': '$total'});
  String get saveDraft => t('saveDraft');
  String get submitListing => t('submitListing');
  String get newDraftListing => t('newDraftListing');
  String get untitledProperty => t('untitledProperty');
  String get draftSaved => t('draftSaved');
  String get propertyType => t('propertyType');
  String get selectType => t('selectType');
  String get propertyNameLabel => t('propertyNameLabel');
  String get descriptionLabel => t('descriptionLabel');
  String get nameHint => t('nameHint');
  String get describeHint => t('describeHint');
  String get bedrooms => t('bedrooms');
  String get bathrooms => t('bathrooms');
  String get numberOfBeds => t('numberOfBeds');
  String get petsAllowedQ => t('petsAllowedQ');
  String get partyAllowedQ => t('partyAllowedQ');
  String get mixedGroupsAllowedQ => t('mixedGroupsAllowedQ');
  String get referralCodeLabel => t('referralCodeLabel');
  String get dragPin => t('dragPin');
  String get locationSelected => t('locationSelected');
  String get compoundArea => t('compoundArea');
  String get marassiHint => t('marassiHint');
  String get exactAddress => t('exactAddress');
  String get unitStreetHint => t('unitStreetHint');
  String get propertyNo => t('propertyNo');
  String get floorIfApartment => t('floorIfApartment');
  String get areaM2 => t('areaM2');
  String get floorsInUnit => t('floorsInUnit');
  String get metersFromSea => t('metersFromSea');
  String get viewLabel => t('viewLabel');
  String get selectView => t('selectView');
  String get seaView => t('seaView');
  String get poolView => t('poolView');
  String get gardenView => t('gardenView');
  String get streetView => t('streetView');
  String get checklistWarning => t('checklistWarning');
  String get addedLabel => t('addedLabel');
  String get noAmenitiesYet => t('noAmenitiesYet');
  String get suggestedTap => t('suggestedTap');
  String get customFeatures => t('customFeatures');
  String get photoGuidelines => t('photoGuidelines');
  String get readLabel => t('readLabel');
  String get min5Photos => t('min5Photos');
  String get requiredShots => t('requiredShots');
  String get compoundLayoutShot => t('compoundLayoutShot');
  String get balconyViewShot => t('balconyViewShot');
  String get everyToiletShot => t('everyToiletShot');
  String get outsideDoorShot => t('outsideDoorShot');
  String get uploadPhotos => t('uploadPhotos');
  String get dragDrop => t('dragDrop');
  String get coverLabel => t('coverLabel');
  String get yesLabel => t('yesLabel');
  String get noBtn => t('noBtn');
  String get selectLocation => t('selectLocation');
  String get confirmLocation => t('confirmLocation');

  // --- Payout / withdraw / violations ---
  String get payoutAccount => t('payoutAccount');
  String get payoutNote => t('payoutNote');
  String get bankName => t('bankName');
  String get accountHolder => t('accountHolder');
  String get bankAccountNumber => t('bankAccountNumber');
  String get ibanLabel => t('ibanLabel');
  String get swiftBic => t('swiftBic');
  String get bankEncryptedNote => t('bankEncryptedNote');
  String get saveAccount => t('saveAccount');
  String get withdrawToBank => t('withdrawToBank');
  String get availableToWithdraw => t('availableToWithdraw');
  String get amountToWithdraw => t('amountToWithdraw');
  String get toAccount => t('toAccount');
  String get changeLabel => t('changeLabel');
  String get fundsArriveNote => t('fundsArriveNote');
  String get withdrawBtn => t('withdrawBtn');
  String get withdrawalRequested => t('withdrawalRequested');
  String get amountLabel => t('amountLabel');
  String get toLabel => t('toLabel');
  String get referenceLabel => t('referenceLabel');
  String get requestedLabel => t('requestedLabel');
  String get estArrival => t('estArrival');
  String get notifyWhenSent => t('notifyWhenSent');
  String get downloadReceipt => t('downloadReceipt');
  String get doneLabel => t('doneLabel');
  String get violationReport => t('violationReport');
  String get propertyDamage => t('propertyDamage');
  String get openBadge => t('openBadge');
  String get financialImpact => t('financialImpact');
  String get deductionAmount => t('deductionAmount');
  String get dateReported => t('dateReported');
  String get appliedToPayout => t('appliedToPayout');
  String get evidenceProvided => t('evidenceProvided');
  String get timelineTitle => t('timelineTitle');
  String get violationReported => t('violationReported');
  String get evidenceVerified => t('evidenceVerified');
  String get deductionCalculated => t('deductionCalculated');
  String get ownerNotified => t('ownerNotified');
  String get reviewResult => t('reviewResult');
  String get almostThere => t('almostThere');
  String get publishWithinHour => t('publishWithinHour');
  String get whatTeamNeeds => t('whatTeamNeeds');
  String get priceRecommendation => t('priceRecommendation');
  String get useLabel => t('useLabel');
  String get keepMine => t('keepMine');
  String get chatWithReviewer => t('chatWithReviewer');
  String get makeChangesResubmit => t('makeChangesResubmit');

  // --- Terms & Conditions ---
  String get termsOwnerTitle => t('termsOwnerTitle');
  String get termsRenterTitle => t('termsRenterTitle');
  String get termsBrokerTitle => t('termsBrokerTitle');
  String get termsDocRef => t('termsDocRef');
  String get termsIntroOwner => t('termsIntroOwner');
  String get termsIntroRenter => t('termsIntroRenter');
  String get termsIntroBroker => t('termsIntroBroker');
  String get termsAgreeFootnote => t('termsAgreeFootnote');
  String get termsOwnerSection1Title => t('termsOwnerSection1Title');
  String get termsOwnerSection2Title => t('termsOwnerSection2Title');
  String get termsOwnerSection3Title => t('termsOwnerSection3Title');
  String get termsOwnerSection4Title => t('termsOwnerSection4Title');
  String get termsRenterSection1Title => t('termsRenterSection1Title');
  String get termsRenterSection2Title => t('termsRenterSection2Title');
  String get termsRenterSection3Title => t('termsRenterSection3Title');
  String get termsRenterSection4Title => t('termsRenterSection4Title');
  String get termsBrokerSection1Title => t('termsBrokerSection1Title');
  String get termsBrokerSection2Title => t('termsBrokerSection2Title');
  String get termsBrokerSection3Title => t('termsBrokerSection3Title');
  String get termsBrokerSection4Title => t('termsBrokerSection4Title');
  String get termsBrokerSection5Title => t('termsBrokerSection5Title');
  String get termsMasterRulesTitle => t('termsMasterRulesTitle');

  /// Localized label for owner property filter tabs (canonical input).
  static String ownerTabLabel(AppLocalizations l, String tab) {
    switch (tab) {
      case 'All':
        return l.tabAll;
      case 'Active':
        return l.tabActive;
      case 'Paused':
        return l.tabPaused;
      case 'Under Review':
        return l.tabUnderReview;
      case 'Draft':
        return l.tabDraft;
      default:
        return tab;
    }
  }

  /// Maps canonical (English) tab values to localized display labels.
  /// Callbacks must keep receiving the canonical value.
  static String tabLabel(AppLocalizations l, String tab) {
    switch (tab) {
      case 'Upcoming':
        return l.tabUpcoming;
      case 'Active':
        return l.tabActive;
      case 'Past':
        return l.tabPast;
      default:
        return tab;
    }
  }

  /// Native name of a language code (shown in its own language,
  /// independent of the active app language).
  static String nativeLanguageName(String code) {
    switch (code) {
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'es':
        return 'Español';
      case 'ru':
        return 'Русский';
      default:
        return 'English';
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final code = AppLocalizations.supportedLanguages
            .contains(locale.languageCode)
        ? locale.languageCode
        : AppLocalizations.fallbackLocale.languageCode;

    final raw = await rootBundle
        .loadString('assets/translations/$code.json', cache: false);
    final Map<String, dynamic> data = json.decode(raw) as Map<String, dynamic>;

    final strings = data.map((key, value) => MapEntry(key, value.toString()));
    if (code == 'ar') strings['__rtl__'] = 'true';

    return AppLocalizations(strings);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
