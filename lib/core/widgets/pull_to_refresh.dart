import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

/// Wraps a scrolling screen so pulling down reloads it.
///
/// The child keeps its own scroll view; this only adds the gesture and the
/// spinner, in the app's colours.
class PullToRefresh extends StatelessWidget {
  const PullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.gold,
      backgroundColor: AppColors.white,
      child: child,
    );
  }
}
