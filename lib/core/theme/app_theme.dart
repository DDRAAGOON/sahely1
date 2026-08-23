import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sahely/core/theme/app_colors.dart';

/// Global theme. The design uses **DM Sans** throughout.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
        secondary: AppColors.gold,
        surface: AppColors.cream,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.dmSansTextTheme(baseTheme.textTheme).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      primaryTextTheme: GoogleFonts.dmSansTextTheme(baseTheme.primaryTextTheme),
      splashFactory: InkRipple.splashFactory,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: _SmoothPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.navy,
      ),
    );
  }

  /// DM Sans helper so screens can build one-off styles concisely.
  static TextStyle dm({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? height,
    double? letterSpacing,
    bool italic = false,
  }) =>
      GoogleFonts.dmSans(
        textStyle: TextStyle(
          fontSize: size,
          fontWeight: weight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        ),
      );
}

class _SmoothPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(0.0, 0.05),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutQuart)),
        ),
        child: child,
      ),
    );
  }
}
