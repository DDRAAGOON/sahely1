import 'package:flutter/material.dart';
import 'features/auth/auth_screens.dart';
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
  '/create': (_) => const CreateAccountScreen(),
  '/signin': (_) => const SignInScreen(),
  '/verify-email': (ctx) => OtpScreen(
        title: 'Verify Your Email',
        icon: Icons.mail_outline,
        hint: 'Check your inbox — and your spam folder',
        cta: 'Verify Email',
        onVerify: () {
          final args = ModalRoute.of(ctx)?.settings.arguments;
          Navigator.pushNamed(ctx, '/verify-phone', arguments: args);
        },
      ),
  '/verify-phone': (ctx) => OtpScreen(
        title: 'Verify Your Number',
        icon: Icons.phone_iphone,
        hint: 'Check your messages for the SMS code',
        cta: 'Verify Number',
        bottomText: 'Wrong number? Change it',
        isPhone: true,
        onVerify: () {
          final args = ModalRoute.of(ctx)?.settings.arguments;
          Navigator.pushNamed(ctx, '/id-verification', arguments: args);
        },
      ),
  '/forgot': (_) => const ForgotPasswordScreen(),
  '/reset-otp': (ctx) => OtpScreen(
        title: 'Enter the code',
        subtitleSpans: const [
          TextSpan(text: 'Sent to '),
          TextSpan(text: 'mariam@example.com', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2D2D2D))),
        ],
        icon: Icons.mail_outline,
        hint: 'Check your inbox — and your spam folder',
        cta: 'Verify OTP',
        onVerify: () => Navigator.pushNamed(ctx, '/new-password'),
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
  '/notif-banner': (_) => const BannerAnatomyScreen(),
  '/notif-top': (_) => const TopBannerScreen(),
};
