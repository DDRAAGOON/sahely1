import 'package:flutter/material.dart';
import 'package:sahely/features/shared/auth/presentation/pages/sign_in_page.dart';
import 'package:sahely/features/shared/auth/presentation/pages/create_account_page.dart';
import 'package:sahely/features/shared/auth/presentation/pages/otp_page.dart';
import 'package:sahely/features/shared/auth/presentation/pages/splash_screen.dart';
import 'package:sahely/features/shared/auth/presentation/pages/welcome_screen.dart';
import 'package:sahely/features/shared/auth/presentation/pages/onboarding_screen.dart';
import 'package:sahely/features/shared/auth/presentation/pages/role_selection_screen.dart';
import 'package:sahely/features/shared/auth/presentation/pages/auth_placeholders.dart';

import 'features/owner/owner_screens.dart';
import 'features/broker/broker_screens.dart';
import 'features/renter/renter_screens.dart';
import 'features/shared/shared_routes.dart';
import 'features/notifications/notifications_screen.dart';

/// Master route table. Grouped by section to mirror the design board.
final Map<String, WidgetBuilder> appRoutes = {
  // ---- Auth ----
  '/splash': (_) => const SplashScreen(),
  '/welcome': (_) => const WelcomeScreen(),
  '/onboarding': (_) => const OnboardingScreen(),
  '/role': (_) => const RoleSelectionScreen(),
  '/create': (_) => const CreateAccountPage(),
  '/signin': (_) => const SignInPage(),
  '/verify-email': (ctx) => const OtpPage(
        title: 'Verify Your Email',
        icon: Icons.mail_outline,
        hint: 'Check your inbox — and your spam folder',
        cta: 'Verify Email',
      ),
  '/verify-phone': (ctx) => const OtpPage(
        title: 'Verify Your Number',
        icon: Icons.phone_iphone,
        hint: 'Check your messages for the SMS code',
        cta: 'Verify Number',
        bottomText: 'Wrong number? Change it',
        isPhone: true,
      ),
  '/forgot': (_) => const ForgotPasswordScreen(),
  '/reset-otp': (ctx) => const OtpPage(
        title: 'Enter the code',
        subtitleSpans: [
          TextSpan(text: 'Sent to '),
          TextSpan(text: 'mariam@example.com', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2D2D2D))),
        ],
        icon: Icons.mail_outline,
        hint: 'Check your inbox — and your spam folder',
        cta: 'Verify OTP',
      ),
  '/new-password': (_) => const NewPasswordScreen(),
  '/password-updated': (_) => const PasswordUpdatedScreen(),
  '/id-verification': (_) => const IdVerificationScreen(),
  '/facial-scan': (_) => const FacialScanScreen(),
  '/verification-complete': (_) => const VerificationCompleteScreen(),

  // ---- Shared (browse, booking, wishlist, services, AL MAWSEM, account) ----
  ...sharedRoutes,

  // ---- Renter ----
  ...renterRoutes,

  // ---- Owner ----
  ...ownerRoutes,

  // ---- Broker ----
  ...brokerRoutes,

  // ---- Notifications ----
  '/notifications': (_) => const NotificationsScreen(),
  // '/notif-banner': (_) => const BannerAnatomyScreen(), // Placeholder if needed
  // '/notif-top': (_) => const TopBannerScreen(), // Placeholder if needed
};
