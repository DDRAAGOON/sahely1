import 'package:flutter/material.dart';

/// Sahely brand palette — Navy · Champagne Gold · Cream.
/// Values are taken directly from the design board (`Sahely.dc.html`).
class AppColors {
  AppColors._();

  // Brand
  static const navy = Color(0xFF1B2744);
  static const gold = Color(0xFFC9A84C);
  static const goldBright = Color(0xFFE4C56A); // medallion highlight
  static const goldLight = Color(0xFFE9D9A8); // text on navy
  static const goldSoft = Color(0xFFFDF9F4); // selected card fill

  // Surfaces
  static const board = Color(0xFFE7E4DE); // gallery board bg
  static const cream = Color(0xFFF5F0E8); // base screen bg
  static const creamTop = Color(0xFFFAF6EF); // gradient top
  static const creamBottom = Color(0xFFEFE7DA); // gradient bottom
  static const white = Color(0xFFFFFFFF);
  static const cardWarm = Color(0xFFEFE9DD); // inactive role icon bg

  // Lines
  static const border = Color(0xFFE0D8CC);
  static const borderCool = Color(0xFFD6D1C8);

  // Text
  static const ink = Color(0xFF2D2D2D);
  static const muted = Color(0xFF717171);
  static const faint = Color(0xFF9A9A9A);
  static const subtle = Color(0xFF5B5B5B);

  // Roles
  static const renter = navy;
  static const owner = Color(0xFF1B6B3A); // green
  static const broker = gold;

  // Status
  static const success = Color(0xFF1B6B3A);
  static const danger = Color(0xFFB3261E);
  static const sea = Color(0xFF2E8B8B); // teal accent

  // Convenience
  static const onNavy = white;
  static const onGold = navy;
}
