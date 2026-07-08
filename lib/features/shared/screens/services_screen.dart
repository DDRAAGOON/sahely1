import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/cream_background.dart';
import '../../../widgets/floating_nav.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.04),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt_outlined, size: 40, color: AppColors.gold),
                ),
                const SizedBox(height: 32),
                Text(
                  'Coming Soon',
                  textAlign: TextAlign.center,
                  style: AppTheme.dm(size: 24, weight: FontWeight.w700, color: AppColors.navy),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'We are working hard to bring you the best premium services. Stay tuned!',
                    textAlign: TextAlign.center,
                    style: AppTheme.dm(size: 15, color: AppColors.muted, height: 1.4),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          const FloatingNav(active: 3),
        ],
      ),
    );
  }
}
