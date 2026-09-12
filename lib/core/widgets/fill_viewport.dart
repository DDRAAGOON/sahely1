import 'package:flutter/material.dart';

/// Lays out a full-height [Column] exactly as designed when it fits, and
/// scrolls it instead of overflowing when it does not.
///
/// Screens built as a fixed-height column - centred content, or a `Spacer`
/// pushing the buttons to the bottom - overflow on short phones (iPhone SE,
/// small Android) and with a large system font. Wrapping the column in a
/// `FillViewport` keeps it at least as tall as the screen, so `Spacer` and
/// `MainAxisAlignment.center` behave as before, while the extra height on a
/// short screen becomes scrollable.
class FillViewport extends StatelessWidget {
  const FillViewport({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final padding = this.padding ?? EdgeInsets.zero;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.hasBoundedHeight
                ? (constraints.maxHeight - padding.vertical)
                    .clamp(0.0, double.infinity)
                : 0,
          ),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
