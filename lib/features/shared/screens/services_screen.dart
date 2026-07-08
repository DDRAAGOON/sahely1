import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/cream_background.dart';
import '../widgets/floating_nav.dart';


class ServicesScreen extends StatelessWidget {
  final bool showNav;
  const ServicesScreen({super.key, this.showNav = true});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            children: [
              Text('Services', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                  ],
                ),
              ),
            ],
          ),
          if (showNav) const FloatingNav(active: 3),
        ],
      ),
    );
  }
}
