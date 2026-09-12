import 'package:sahely/l10n/app_localizations.dart';

/// Extension on [AppLocalizations] providing dynamic key lookup helpers
/// used by screens that reference localization keys as strings at runtime.
///
/// These helpers prevent the need for giant switch statements in every screen.
extension AppLocalizationsX on AppLocalizations {
  // ── Dynamic lookup ─────────────────────────────────────────────────────────

  /// Look up a localization string by its [key] name.
  ///
  /// Returns the localized string for the key, or [key] itself if not found.
  /// This supports the legacy `l.t('someKey')` call pattern.
  String t(String key) {
    switch (key) {
      // Onboarding
      case 'obTitle1':
        return obTitle1;
      case 'obSub1':
        return obSub1;
      case 'obTitle2':
        return obTitle2;
      case 'obSub2':
        return obSub2;
      case 'obTitle3':
        return obTitle3;
      case 'obSub3':
        return obSub3;

      // Role descriptions
      case 'roleRenterDesc':
        return roleRenterDesc;
      case 'roleOwnerDesc':
        return roleOwnerDesc;
      case 'roleBrokerDesc':
        return roleBrokerDesc;

      // Terms — Owner
      case 'termsOwnerSection1Point1':
        return termsOwnerSection1Point1;
      case 'termsOwnerSection1Point2':
        return termsOwnerSection1Point2;
      case 'termsOwnerSection1Point3':
        return termsOwnerSection1Point3;
      case 'termsOwnerSection1Point4':
        return termsOwnerSection1Point4;
      case 'termsOwnerSection2Point1':
        return termsOwnerSection2Point1;
      case 'termsOwnerSection2Point2':
        return termsOwnerSection2Point2;
      case 'termsOwnerSection2Point3':
        return termsOwnerSection2Point3;
      case 'termsOwnerSection2Point4':
        return termsOwnerSection2Point4;
      case 'termsOwnerSection3Point1':
        return termsOwnerSection3Point1;
      case 'termsOwnerSection3Point2':
        return termsOwnerSection3Point2;
      case 'termsOwnerSection3Point3':
        return termsOwnerSection3Point3;
      case 'termsOwnerSection3Point4':
        return termsOwnerSection3Point4;
      case 'termsOwnerSection4Point1':
        return termsOwnerSection4Point1;
      case 'termsOwnerSection4Point2':
        return termsOwnerSection4Point2;
      case 'termsOwnerSection4Point3':
        return termsOwnerSection4Point3;
      case 'termsOwnerSection4Point4':
        return termsOwnerSection4Point4;

      // Terms — Broker
      case 'termsBrokerSection1Point1':
        return termsBrokerSection1Point1;
      case 'termsBrokerSection1Point2':
        return termsBrokerSection1Point2;
      case 'termsBrokerSection2Point1':
        return termsBrokerSection2Point1;
      case 'termsBrokerSection2Point2':
        return termsBrokerSection2Point2;
      case 'termsBrokerSection2Point3':
        return termsBrokerSection2Point3;
      case 'termsBrokerSection3Point1':
        return termsBrokerSection3Point1;
      case 'termsBrokerSection3Point2':
        return termsBrokerSection3Point2;
      case 'termsBrokerSection3Point3':
        return termsBrokerSection3Point3;
      case 'termsBrokerSection3Point4':
        return termsBrokerSection3Point4;
      case 'termsBrokerSection4Point1':
        return termsBrokerSection4Point1;
      case 'termsBrokerSection4Point2':
        return termsBrokerSection4Point2;
      case 'termsBrokerSection5Point1':
        return termsBrokerSection5Point1;
      case 'termsBrokerSection5Point2':
        return termsBrokerSection5Point2;

      // Terms — Renter
      case 'termsRenterSection1Point1':
        return termsRenterSection1Point1;
      case 'termsRenterSection1Point2':
        return termsRenterSection1Point2;
      case 'termsRenterSection1Point3':
        return termsRenterSection1Point3;
      case 'termsRenterSection1Point4':
        return termsRenterSection1Point4;
      case 'termsRenterSection1Point5':
        return termsRenterSection1Point5;
      case 'termsRenterSection1Point6':
        return termsRenterSection1Point6;
      case 'termsRenterSection2Point1':
        return termsRenterSection2Point1;
      case 'termsRenterSection2Point2':
        return termsRenterSection2Point2;
      case 'termsRenterSection2Point3':
        return termsRenterSection2Point3;
      case 'termsRenterSection3Point1':
        return termsRenterSection3Point1;
      case 'termsRenterSection3Point2':
        return termsRenterSection3Point2;
      case 'termsRenterSection3Point3':
        return termsRenterSection3Point3;
      case 'termsRenterSection4Point1':
        return termsRenterSection4Point1;
      case 'termsRenterSection4Point2':
        return termsRenterSection4Point2;
      case 'termsRenterSection4Point3':
        return termsRenterSection4Point3;

      // Terms — Master rules
      case 'termsMasterRulesPoint1':
        return termsMasterRulesPoint1;
      case 'termsMasterRulesPoint2':
        return termsMasterRulesPoint2;
      case 'termsMasterRulesPoint3':
        return termsMasterRulesPoint3;
      case 'termsMasterRulesPoint4':
        return termsMasterRulesPoint4;

      // Language screen
      case 'followSystem':
        return followSystem;

      default:
        // Fallback: return the key itself so nothing crashes at runtime
        return key;
    }
  }

  /// Template-format lookup with named [args] substitution.
  ///
  /// Supports the legacy `l.tf('termsAgreeFootnote', {'role': roleStr})` pattern.
  String tf(String key, Map<String, String> args) {
    String value = t(key);
    args.forEach((k, v) => value = value.replaceAll('{$k}', v));
    return value;
  }

  // ── Language helpers ────────────────────────────────────────────────────────

  /// Returns the native display name of the current locale's language.
  ///
  /// This is what non-English speakers will read in the language picker.
  String languageNameFor(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
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
        return languageCode;
    }
  }
}
