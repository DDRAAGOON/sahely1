import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

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
    this.bottom = true,
    this.top = true,
  });

  final Widget child;
  final bool dark;
  final bool bottom;
  final bool top;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CreamBackground(
        child: SafeArea(
          top: top,
          bottom: bottom,
          child: child,
        ),
      ),
    );
  }
}

/// Alias so existing code using [PhoneScaffold] continues to work.
typedef PhoneScaffold = SahelyPhoneScaffold;
