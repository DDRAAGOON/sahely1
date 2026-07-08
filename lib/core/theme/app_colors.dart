import 'package:flutter/material.dart';

/// Sahely Brand Colors - Single Source of Truth
/// Managed as a part of the Core Layer for consistent UI across all roles (Renter, Owner, Broker).
class AppColors {
  AppColors._();

  // ==================== BRAND COLORS (CORE) ====================
  static const Color navy = Color(0xFF1B2744);
  static const Color gold = Color(0xFFC9A84C);
  static const Color cream = Color(0xFFF5F0E8);
  static const Color goldTint = Color(0xFFFDF9F4);
  static const Color surface = Color(0xFFFFFFFF);

  // ==================== TEXT COLORS ====================
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF717171);
  static const Color textPlaceholder = Color(0xFF9A9A9A);
  static const Color ink = Color(0xFF1B2744);

  // ==================== BORDERS & DIVIDERS ====================
  static const Color borderDefault = Color(0xFFE0D8CC);
  static const Color borderFocus = Color(0xFFC9A84C);
  static const Color divider = Color(0xFFE0D8CC);
  static const Color border = borderDefault;

  // ==================== STATUS COLORS ====================
  static const Color success = Color(0xFF1B6B3A);
  static const Color green = success;
  static const Color warning = Color(0xFFD2760A);
  static const Color error = Color(0xFFB22222);
  static const Color sos = Color(0xFFB22222);
  static const Color red = Color(0xFFFF4848);
  static const Color info = Color(0xFF1565C0);
  static const Color danger = Color(0xFFFF4848);

  // ==================== ROLE SPECIFIC COLORS ====================
  static const Color owner = navy;
  static const Color broker = gold;
  static const Color renter = Color(0xFF1B2744);

  // ==================== RENTER HOME & PROMO ====================
  static const Color renterPillBg = Color(0xFFE6EAF2);
  static const Color guestFavouriteBg = Color(0xFF657086);
  static const Color promoCircleGold = Color(0xFFC1A457);
  static const Color promoBannerGold = Color(0xFFBC9B43);
  
  // ==================== AL MAWSEM & PROGRESS ====================
  static const Color mawsemTeal = Color(0xFF2CB5A0);
  static const Color mawsemDark = Color(0xFF424446);
  static const Color mawsemGold = Color(0xFFB1974C);
  static const Color mawsemBg = Color(0xFF182441);
  static const Color mawsemProgress = Color(0xFFD8B95D);
  static const Color referralBoxBg = Color(0xFF323D57);
  static const Color levelUnlockedText = Color(0xFF5B926C);
  static const Color levelUnlockedBg = Color(0xFFDFEDDE);
  static const Color levelLockedText = Color(0xFF9A7A22);
  static const Color levelLockedBg = Color(0xFFFBF3DE);

  // ==================== GRADIENTS ====================
  static const Gradient goldRadial = RadialGradient(
    colors: [Color(0xFFE4C56A), Color(0xFFC9A84C)],
  );

  static const LinearGradient referralGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF293962), Color(0xFF243256), Color(0xFF1E2B4A)],
  );

  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [navy, Color(0xFF141D33)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFE4C56A), Color(0xFFC9A84C)],
  );

  // ==================== SHADOWS ====================
  static List<BoxShadow> get cardShadow => [_shadow(navy, 0.08, 12, const Offset(0, 2))];
  static List<BoxShadow> get goldButtonShadow => [_shadow(gold, 0.25, 16, const Offset(0, 4))];
  static List<BoxShadow> get bottomNavShadow => [_shadow(navy, 0.10, 12, const Offset(0, -2))];
  static List<BoxShadow> get modalShadow => [_shadow(navy, 0.15, 24, const Offset(0, -4))];
  static List<BoxShadow> get floatingShadow => [_shadow(navy, 0.20, 12, const Offset(0, 4))];

  static BoxShadow _shadow(Color color, double opacity, double blur, Offset offset) {
    return BoxShadow(color: color.withOpacity(opacity), blurRadius: blur, offset: offset);
  }

  // ==================== ALIASES (BACKWARD COMPATIBILITY) ====================
  static const Color primary = gold;
  static const Color background = Color(0xFFf2eadf);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF7a7a7a);
  static const Color faint = Color(0xFFF5F5F5);
  static const Color cardWarm = Color(0xFFFDF9F4);
  static const Color secondary = textSecondary;
  static const Color placeholder = textPlaceholder;
  static const Color dark = textPrimary;
  static const Color board = Color(0xFFE8E8E8);
  static const Color goldSoft = Color(0xFFF5E6C8);
  static const Color goldBright = Color(0xFFE4C56A);
  static const Color goldLight = Color(0xFFE4C56A);
  static const Color textDark = navy;
  static const Color textLight = textPlaceholder;
}
