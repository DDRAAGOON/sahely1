import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/brand.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const SahelyImage(
            imageUrl:
                'https://images.unsplash.com/photo-1777919541977-16d7271ac96e?w=1200&q=72&auto=format&fit=crop',
            fadeColor: Color(0xC71B2744),
            fadeHeight: 500,
            enableViewer: false,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 44),
              child: Column(
                children: [
                  const Column(
                    children: [
                      SahelyLogo(size: 56),
                      SizedBox(height: 2),
                      Wordmark(size: 24)
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l.welcomeTagline,
                        style: AppTheme.dm(
                            size: 30,
                            weight: FontWeight.w700,
                            color: AppColors.white,
                            height: 1.15)),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l.welcomeSubtitle,
                        style:
                            AppTheme.dm(size: 15, color: AppColors.goldLight)),
                  ),
                  const SizedBox(height: 26),
                  GoldButton(
                    label: l.getStarted,
                    onTap: () => AppNavigation.goToOnboarding(context),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () => AppNavigation.goToSignIn(context),
                    child: RichText(
                      text: TextSpan(
                        text: l.alreadyHaveAccount,
                        style:
                            AppTheme.dm(size: 13, color: AppColors.goldLight),
                        children: [
                          TextSpan(
                              text: l.signIn,
                              style: AppTheme.dm(
                                  size: 13,
                                  weight: FontWeight.w700,
                                  color: AppColors.white)),
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
