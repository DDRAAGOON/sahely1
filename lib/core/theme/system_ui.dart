import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Status-bar styles.
///
/// The app draws behind a transparent status bar (including the camera
/// cutout), so every screen decides whether the icons above it are dark or
/// light. Without this the bar fell back to solid black on devices such as
/// Realme / ColorOS phones and the clock and notification icons disappeared.
class SystemUi {
  SystemUi._();

  /// Dark icons for the cream screens - the app-wide default.
  static const darkIcons = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android
    statusBarBrightness: Brightness.light, // iOS
  );

  /// Light icons for screens whose top edge is navy or a photo.
  static const lightIcons = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light, // Android
    statusBarBrightness: Brightness.dark, // iOS
  );
}

/// Marks a screen whose top edge is dark (navy or a photo) so the status-bar
/// icons turn white. Wrap the screen's [Scaffold] in it.
///
/// It overrides the dark-icon default set once for the whole app in
/// `SahelyApp`, and only while this screen is the one under the status bar.
class LightStatusBar extends StatelessWidget {
  const LightStatusBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUi.lightIcons,
      child: child,
    );
  }
}
