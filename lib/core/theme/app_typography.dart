import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Sahely Typography System
/// Centralizes all text styles to ensure consistency across the app.
/// We use 'Cairo' as the primary font for a modern feel and 'DM Sans' for UI elements.
class AppTypography {
  AppTypography._();

  // ==================== CAIRO STYLES (Primary) ====================
  
  static TextStyle get cairoHeading1 => GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
      );

  static TextStyle get cairoHeading2 => GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      );

  static TextStyle get cairoBodyLarge => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get cairoBodyMedium => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  // ==================== DM SANS STYLES (UI & Secondary) ====================

  static TextStyle get dmHeading => GoogleFonts.dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      );

  static TextStyle get dmBody => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
      );

  static TextStyle get dmLabel => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
      );

  // ==================== CUSTOM HELPER ====================

  /// Custom DM Sans helper for quick styles while keeping the brand font.
  static TextStyle dmCustom({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? height,
    double? letterSpacing,
  }) =>
      GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
}
