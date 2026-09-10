import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:sahely/core/navigation/app_routes.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/auth/data/auth_api.dart';
import 'package:sahely/features/auth/screens/otp_screen.dart';
import 'package:sahely/l10n/app_localizations.dart';

/// Shared helper that surfaces backend errors to the user.
void showAuthError(BuildContext context, Object e) {
  final message = e is AuthApiException ? e.message : e.toString();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: AppColors.error),
  );
}

/// Step 3 of registration — verifies the code emailed to the user, then
/// triggers the phone OTP (step 4) and moves on.
class RegisterEmailOtpScreen extends StatefulWidget {
  const RegisterEmailOtpScreen({super.key, this.extra});

  final Map<String, dynamic>? extra;

  @override
  State<RegisterEmailOtpScreen> createState() => _RegisterEmailOtpScreenState();
}

class _RegisterEmailOtpScreenState extends State<RegisterEmailOtpScreen> {
  final _api = AuthApiService();
  final _otpKey = GlobalKey<OtpScreenState>();
  bool _busy = false;

  Future<void> _verify() async {
    if (_busy) return;
    final code = _otpKey.currentState?.code ?? '';
    if (code.length < 6) {
      showAuthError(context, AuthApiException('Enter the 6-digit code'));
      return;
    }
    setState(() => _busy = true);
    try {
      final sessionId = '${widget.extra?['sessionId'] ?? ''}';
      await _api.verifyEmailOtp(sessionId, code);

      // Auto-send the phone OTP before moving to the phone step.
      await _api.sendPhoneOtp(sessionId);

      if (!mounted) return;
      context.push(AppRoutes.verifyPhone, extra: widget.extra);
    } catch (e) {
      if (mounted) showAuthError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    // Re-running step2 re-sends the email OTP for the same session.
    try {
      final sessionId = '${widget.extra?['sessionId'] ?? ''}';
      await _api.registerStep2(
        sessionId: sessionId,
        fullName: '${widget.extra?['name'] ?? ''}',
        email: '${widget.extra?['email'] ?? ''}',
        phone: '${widget.extra?['phone'] ?? ''}',
        dateOfBirth:
            '${widget.extra?['dateOfBirth'] ?? DateTime(1995, 1, 1).toIso8601String().substring(0, 10)}',
        password: '${widget.extra?['password'] ?? ''}',
        confirmPassword: '${widget.extra?['password'] ?? ''}',
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return OtpScreen(
      key: _otpKey,
      title: l.verifyEmailTitle,
      email: widget.extra?['email'] as String?,
      icon: Icons.mail_outline,
      hint: l.verifyEmailHint,
      cta: l.verifyEmailCta,
      onVerify: _verify,
      onResend: _resend,
    );
  }
}

/// Step 4 — verify the SMS code sent to the phone, then sign the fresh
/// account in automatically and land on the KYC / home flow.
class RegisterPhoneOtpScreen extends StatefulWidget {
  const RegisterPhoneOtpScreen({super.key, this.extra});

  final Map<String, dynamic>? extra;

  @override
  State<RegisterPhoneOtpScreen> createState() =>
      _RegisterPhoneOtpScreenState();
}

class _RegisterPhoneOtpScreenState extends State<RegisterPhoneOtpScreen> {
  final _api = AuthApiService();
  final _otpKey = GlobalKey<OtpScreenState>();
  bool _busy = false;

  Future<void> _verify() async {
    if (_busy) return;
    final code = _otpKey.currentState?.code ?? '';
    if (code.length < 6) {
      showAuthError(context, AuthApiException('Enter the 6-digit code'));
      return;
    }
    setState(() => _busy = true);
    try {
      final sessionId = '${widget.extra?['sessionId'] ?? ''}';
      await _api.verifyPhoneOtp(sessionId, code);

      // Phone verified → the account exists in all but name. Sign in with the
      // credentials captured at step 2 so the session uses REAL tokens.
      final email = '${widget.extra?['email'] ?? ''}';
      final password = '${widget.extra?['password'] ?? ''}';
      final roleStr = '${widget.extra?['role'] ?? 'Renter'}';
      final resp = await _api.login(email, password);

      if (!mounted) return;
      await context.read<AuthProvider>().login(
            token: resp.token,
            role: resp.role,
          );

      if (!mounted) return;
      context.pushReplacement(
        AppRoutes.idVerification,
        extra: {
          'name': widget.extra?['name'],
          'email': email,
          'phone': widget.extra?['phone'],
          'role': roleStr,
        },
      );
    } catch (e) {
      if (mounted) showAuthError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    try {
      await _api.sendPhoneOtp('${widget.extra?['sessionId'] ?? ''}');
    } catch (e) {
      if (mounted) showAuthError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Stack(
      children: [
        OtpScreen(
          key: _otpKey,
          title: l.verifyNumberTitle,
          phone: widget.extra?['phone'] as String?,
          icon: Icons.phone_iphone,
          hint: l.verifyNumberHint,
          cta: l.verifyNumberCta,
          bottomText: l.verifyNumberBottom,
          isPhone: true,
          onVerify: _verify,
          onResend: _resend,
        ),
        if (_busy)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x66000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
