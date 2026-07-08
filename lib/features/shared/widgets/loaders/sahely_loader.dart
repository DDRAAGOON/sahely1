import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class SahelyLoader extends StatelessWidget {
  final double size;
  final Color color;

  const SahelyLoader({
    super.key, 
    this.size = 30, 
    this.color = AppColors.gold
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class SahelyShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SahelyShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    // Basic Shimmer placeholder
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.3),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
