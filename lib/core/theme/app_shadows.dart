import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

/// Sahely Shadow System
///
/// Defines standard box shadows for cards, buttons, and modals.
class AppShadows {
  AppShadows._();

  static BoxShadow _shadow(
      Color color, double opacity, double blur, Offset offset) {
    return BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: blur,
      offset: offset,
    );
  }

  /// Standard card shadow (light and subtle)
  static List<BoxShadow> get card =>
      [_shadow(AppColors.navy, 0.08, 12, const Offset(0, 2))];

  /// Gold button shadow (glowing effect)
  static List<BoxShadow> get goldButton =>
      [_shadow(AppColors.gold, 0.25, 16, const Offset(0, 4))];

  /// Bottom navigation bar shadow (casts upwards)
  static List<BoxShadow> get bottomNav =>
      [_shadow(AppColors.navy, 0.10, 12, const Offset(0, -2))];

  /// Modal / Bottom sheet shadow (large and diffuse)
  static List<BoxShadow> get modal =>
      [_shadow(AppColors.navy, 0.15, 24, const Offset(0, -4))];

  /// Floating Action Button / Floating elements shadow
  static List<BoxShadow> get floating =>
      [_shadow(AppColors.navy, 0.20, 12, const Offset(0, 4))];

  /// Input focus shadow (glow around input)
  static List<BoxShadow> get inputFocus => [
        BoxShadow(
          color: AppColors.gold.withValues(alpha: 0.30),
          blurRadius: 0,
          spreadRadius: 3,
        ),
      ];
}
