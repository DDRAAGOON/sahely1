import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../widgets/brand.dart';
import '../../../widgets/branding.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/image.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const SahelyImage(
            imageUrl: 'https://images.unsplash.com/photo-1777919541977-16d7271ac96e?w=1200&q=72&auto=format&fit=crop',
            fadeColor: Color(0xC71B2744),
            fadeHeight: 500,
            enableViewer: false,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 44),
              child: Column(
                children: [
                  Column(
                    children: [const SahelyLogo(size: 56), const SizedBox(height: 2), Wordmark(size: 24)],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Verified Chalets.\nZero Chaos.',
                        style: AppTheme.dm(
                            size: 30, weight: FontWeight.w700, color: AppColors.white, height: 1.15)),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Discover and book premium properties',
                        style: AppTheme.dm(size: 15, color: AppColors.goldLight)),
                  ),
                  const SizedBox(height: 26),
                  GoldButton(
                    label: 'Get Started',
                    onTap: () => Navigator.pushNamed(context, '/onboarding'),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signin'),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: AppTheme.dm(size: 13, color: AppColors.goldLight),
                        children: [
                          TextSpan(
                              text: 'Sign In',
                              style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
