import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Sahely Global Theme Management
/// This class provides the light theme configuration and helper methods
/// to ensure a consistent look and feel across the entire application.
class AppTheme {
  AppTheme._();

  /// Defines the light theme for the application.
  /// Uses Material 3 features and Sahely's brand identity.
  static ThemeData get light => lightTheme;
  
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.cream,
        
        // Configuration of the main color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.navy,
          primary: AppColors.navy,
          onPrimary: AppColors.white,
          secondary: AppColors.gold,
          onSecondary: AppColors.navy,
          surface: AppColors.surface,
          error: AppColors.error,
        ),

        // Applying the default text theme using DM Sans as global fallback
        textTheme: TextTheme(
          bodyLarge: AppTypography.dmBody,
          bodyMedium: AppTypography.dmBody,
          labelLarge: AppTypography.dmLabel,
        ),
        
        // AppBar Styling
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColors.navy,
          iconTheme: IconThemeData(color: AppColors.navy),
        ),

        // Button Theme Global Config
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: AppColors.white,
            textStyle: AppTypography.cairoBodyLarge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        // Default Dividers
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
      );

  /// Helper method for DM Sans styles (Backward Compatibility)
  /// Many existing widgets use AppTheme.dm, so we keep it to prevent breaking.
  static TextStyle dm({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? height,
    double? letterSpacing,
    bool italic = false,
  }) {
    return AppTypography.dmCustom(
      size: size,
      weight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    ).copyWith(
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    );
  }
}
