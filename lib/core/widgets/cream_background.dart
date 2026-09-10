import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/utils/responsive.dart';

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
///
/// Responsive by default: on phones content runs full-bleed; on tablets /
/// desktop the body is centered and capped at [contentMaxWidth] so screens
/// designed for phones never stretch awkwardly. Pass a larger value (or
/// `double.infinity`) for feeds that expand into multi-column layouts.
class SahelyPhoneScaffold extends StatelessWidget {
  const SahelyPhoneScaffold({
    super.key,
    required this.child,
    this.dark = false,
    this.bottom = true,
    this.top = true,
    this.contentMaxWidth = 640,
  });

  final Widget child;
  final bool dark;
  final bool bottom;
  final bool top;
  final double? contentMaxWidth;

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    // Tablet / desktop: center & cap the width for phone-first designs.
    if (contentMaxWidth != null) {
      content = ConstrainedContent(maxWidth: contentMaxWidth!, child: content);
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CreamBackground(
        child: SafeArea(
          top: top,
          bottom: bottom,
          child: content,
        ),
      ),
    );
  }
}

/// Alias so existing code using [PhoneScaffold] continues to work.
typedef PhoneScaffold = SahelyPhoneScaffold;
