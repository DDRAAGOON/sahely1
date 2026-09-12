import 'package:shared_preferences/shared_preferences.dart';

/// The referral code from an invite link (`/join?ref=CODE`), kept until the
/// new account is registered with it.
class ReferralCodeStore {
  ReferralCodeStore._();

  static const _key = 'pending_referral_code';

  static Future<void> save(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, trimmed);
  }

  static Future<String?> read() async =>
      (await SharedPreferences.getInstance()).getString(_key);

  static Future<void> clear() async =>
      (await SharedPreferences.getInstance()).remove(_key);
}
