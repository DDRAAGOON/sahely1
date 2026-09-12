import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sahely/core/theme/app_colors.dart';

/// Sahely Typography System
///
/// Base font: DM Sans
/// This class defines the complete text scale according to the design system.
class AppTypography {
  AppTypography._();

  // ── Headers ─────────────────────────────────────────────────────────────

  /// H1: 32px, Bold, Navy
  /// Used for major screen titles (e.g., Onboarding, Main Dashboard)
  static TextStyle get h1 => GoogleFonts.dmSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        height: 1.2,
      );

  /// H2: 24px, Bold, Navy
  /// Used for section titles
  static TextStyle get h2 => GoogleFonts.dmSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        height: 1.3,
      );

  /// H3: 20px, SemiBold, Navy
  /// Used for card titles and sub-sections
  static TextStyle get h3 => GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
        height: 1.3,
      );

  /// H4: 18px, SemiBold, Navy
  /// Used for minor section headers
  static TextStyle get h4 => GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
        height: 1.4,
      );

  // ── Body ────────────────────────────────────────────────────────────────

  /// Body Large: 16px, Regular, Ink
  /// Used for primary body text
  static TextStyle get bodyLarge => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
        height: 1.5,
      );

  /// Body Medium: 14px, Regular, Ink
  /// Used for secondary body text, lists
  static TextStyle get bodyMedium => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
        height: 1.5,
      );

  /// Body Small: 12px, Regular, Muted
  /// Used for captions, hints, timestamps
  static TextStyle get bodySmall => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
        height: 1.5,
      );

  // ── Labels & Buttons ────────────────────────────────────────────────────

  /// Button Large: 16px, Bold, White
  /// Used for primary action buttons
  static TextStyle get buttonLarge => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 0.5,
      );

  /// Button Medium: 14px, SemiBold, White
  /// Used for secondary buttons
  static TextStyle get buttonMedium => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.5,
      );

  /// Label: 12px, SemiBold, Ink
  /// Used for input labels, badges, chips
  static TextStyle get label => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
        letterSpacing: 0.5,
      );

  /// Caption: 10px, Medium, Muted
  /// Used for tiny tertiary text
  static TextStyle get caption => GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
      );
}
