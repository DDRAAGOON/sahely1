import 'package:flutter/material.dart';

/// Central responsive-layout helpers (phone · tablet · desktop).
///
/// Breakpoints follow Material convention:
///   compact  < 600  → phone
///   medium   600–904 → small tablet / foldable
///   expanded ≥ 905  → tablet landscape / desktop
class Responsive {
  Responsive._();

  static bool isCompact(BuildContext c) => MediaQuery.widthOf(c) < 600;
  static bool isMedium(BuildContext c) {
    final w = MediaQuery.widthOf(c);
    return w >= 600 && w < 905;
  }

  static bool isExpanded(BuildContext c) => MediaQuery.widthOf(c) >= 905;

  /// Tablets & up.
  static bool isWide(BuildContext c) => !isCompact(c);

  /// Sensible column count for card grids at the given width.
  static int gridColumns(double width,
      {int phone = 1, int tablet = 2, int desktop = 3}) {
    if (width >= 905) return desktop;
    if (width >= 600) return tablet;
    return phone;
  }
}

/// Centers and caps content width on wide screens so forms, detail pages and
/// lists never stretch edge-to-edge across a tablet.
///
/// Wrap anything whose design target is a phone layout:
///   ConstrainedContent(child: ...)
class ConstrainedContent extends StatelessWidget {
  const ConstrainedContent({
    super.key,
    required this.child,
    this.maxWidth = 640,
    this.center = true,
  });

  final Widget child;
  final double maxWidth;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      if (w <= maxWidth + 24) return child;
      final capped = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      );
      return center ? Center(child: capped) : capped;
    });
  }
}
