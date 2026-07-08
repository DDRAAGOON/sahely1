import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// The background used on almost every light screen.
/// Simplified to a solid color to remove gradients as per user request.
class CreamBackground extends StatelessWidget {
  const CreamBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: child,
    );
  }
}

/// Full-screen cream scaffold with the background color.
class SahelyPhoneScaffold extends StatelessWidget {
  const SahelyPhoneScaffold({
    super.key,
    required this.child,
    this.dark = false,
  });

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CreamBackground(
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}

/// Alias so existing code using [PhoneScaffold] continues to work.
typedef PhoneScaffold = SahelyPhoneScaffold;
