import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/cream_background.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/features/auth/widgets/auth_success_badge.dart';
import 'package:sahely/core/widgets/fill_viewport.dart';

// ========================================================= 08 · Forgot Password
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 120; // 2 minutes
  bool _hasAttemptedSubmit = false;
  String? _emailError;
  bool _submitting = false;

  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 120);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String value) {
    final l = AppLocalizations.of(context);
    if (value.isEmpty) {
      return l.emailRequired;
    }
    if (!_emailRegex.hasMatch(value)) {
      return l.enterValidEmail;
    }
    return null;
  }

  void _clearEmailError() {
    if (_emailError != null) {
      setState(() => _emailError = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 30, 28, 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackChip(),
                    const SizedBox(height: 30),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(18)),
                      child: const Icon(Icons.lock_outline,
                          color: AppColors.gold, size: 30),
                    ),
                    const SizedBox(height: 22),
                    Text(AppLocalizations.of(context).resetAccess,
                        style: AppTheme.dm(
                            size: 22,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context).sendOtpSubtitle,
                        style: AppTheme.dm(
                            size: 14, color: AppColors.muted, height: 1.5)),
                    const SizedBox(height: 24),
                    FieldGroup(
                        label: AppLocalizations.of(context).emailAddress,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              controller: _emailController,
                              hintText: 'mariam.hassan@gmail.com',
                              height: 50,
                              radius: 999,
                              borderColor:
                                  _emailError != null ? AppColors.error : null,
                              onChanged: _hasAttemptedSubmit
                                  ? (value) {
                                      _clearEmailError();
                                    }
                                  : null,
                            ),
                            if (_emailError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6, left: 4),
                                child: Text(_emailError!,
                                    style: AppTheme.dm(
                                        size: 12, color: AppColors.error)),
                              ),
                          ],
                        )),
                    const SizedBox(height: 24),
                    NavyButton(
                        label: _submitting
                            ? AppLocalizations.of(context).loading
                            : AppLocalizations.of(context).sendOtp,
                        radius: 999,
                        onTap: _submitting
                            ? null
                            : () async {
                                setState(() => _hasAttemptedSubmit = true);

                                final email = _emailController.text.trim();
                                final emailError = _validateEmail(email);

                                if (emailError != null) {
                                  setState(() => _emailError = emailError);
                                  return;
                                }

                                setState(() => _submitting = true);

                                // Simulate API call
                                await Future.delayed(
                                    const Duration(seconds: 1));

                                if (!mounted) return;
                                setState(() => _submitting = false);
                                if (context.mounted) {
                                  AppNavigation.goToResetOtp(context);
                                }
                              }),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: _secondsRemaining == 0 ? _startCountdown : null,
                        behavior: HitTestBehavior.opaque,
                        child: RichText(
                          text: TextSpan(
                            text: _secondsRemaining == 0
                                ? AppLocalizations.of(context).resendNow
                                : "${AppLocalizations.of(context).didntGetIt} ${AppLocalizations.of(context).resendIn}",
                            style:
                                AppTheme.dm(size: 13, color: AppColors.muted),
                            children: [
                              if (_secondsRemaining > 0)
                                TextSpan(
                                    text: _formatTime(_secondsRemaining),
                                    style: AppTheme.dm(
                                        size: 13,
                                        weight: FontWeight.w700,
                                        color: AppColors.ink))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: GestureDetector(
                        onTap: () => AppNavigation.safeGo(context, '/signin'),
                        behavior: HitTestBehavior.opaque,
                        child: Text(AppLocalizations.of(context).backToSignIn,
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w600,
                                color: AppColors.gold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ========================================================= 09 · New Password
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _hasAttemptedSubmit = false;
  String? _passwordError;
  String? _confirmError;
  bool _submitting = false;

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validatePassword(String value) {
    final l = AppLocalizations.of(context);
    if (value.isEmpty) {
      return l.passwordRequired;
    }
    if (value.length < 8 ||
        !value.contains(RegExp(r'[a-zA-Z]')) ||
        !value.contains(RegExp(r'[0-9]'))) {
      return l.passwordMinChars;
    }
    return null;
  }

  String? _validateConfirmPassword(String value) {
    final l = AppLocalizations.of(context);
    if (value.isEmpty || value != _passController.text) {
      return l.passwordsDoNotMatch;
    }
    return null;
  }

  void _clearPasswordError() {
    if (_passwordError != null) {
      setState(() => _passwordError = null);
    }
  }

  void _clearConfirmError() {
    if (_confirmError != null) {
      setState(() => _confirmError = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(alignment: Alignment.centerLeft, child: BackChip()),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.lock_outline,
                    color: AppColors.gold, size: 30),
              ),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).setNewPassword,
                textAlign: TextAlign.center,
                style: AppTheme.dm(
                    size: 22, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).passwordRule,
                textAlign: TextAlign.center,
                style:
                    AppTheme.dm(size: 13, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 14),
            FieldGroup(
              label: AppLocalizations.of(context).newPassword,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _passController,
                    hintText: '••••••••',
                    height: 50,
                    radius: 999,
                    fontSize: 18,
                    letterSpacing: 3,
                    obscureText: _obscure1,
                    borderColor:
                        _passwordError != null ? AppColors.error : null,
                    trailing: GestureDetector(
                      onTap: () => setState(() => _obscure1 = !_obscure1),
                      child: Icon(
                          _obscure1
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.muted),
                    ),
                    onChanged: _hasAttemptedSubmit
                        ? (value) {
                            _clearPasswordError();
                            _clearConfirmError();
                          }
                        : null,
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(_passwordError!,
                          style: AppTheme.dm(size: 12, color: AppColors.error)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            FieldGroup(
              label: AppLocalizations.of(context).confirmPassword,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _confirmController,
                    hintText: '••••••••',
                    height: 50,
                    radius: 999,
                    fontSize: 18,
                    letterSpacing: 3,
                    obscureText: _obscure2,
                    borderColor: _confirmError != null ? AppColors.error : null,
                    trailing: GestureDetector(
                      onTap: () => setState(() => _obscure2 = !_obscure2),
                      child: Icon(
                          _obscure2
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.muted),
                    ),
                    onChanged: _hasAttemptedSubmit
                        ? (value) {
                            _clearConfirmError();
                          }
                        : null,
                  ),
                  if (_confirmError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(_confirmError!,
                          style: AppTheme.dm(size: 12, color: AppColors.error)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: _StrengthBar(on: true)),
                SizedBox(width: 6),
                Expanded(child: _StrengthBar(on: true)),
                SizedBox(width: 6),
                Expanded(child: _StrengthBar(on: true)),
                SizedBox(width: 6),
                Expanded(child: _StrengthBar(on: false)),
              ],
            ),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(context).strongPassword,
                style: AppTheme.dm(
                    size: 11,
                    weight: FontWeight.w600,
                    color: AppColors.success)),
            const SizedBox(height: 30),
            NavyButton(
                label: _submitting
                    ? AppLocalizations.of(context).loading
                    : AppLocalizations.of(context).updatePassword,
                radius: 999,
                onTap: _submitting
                    ? null
                    : () async {
                        setState(() => _hasAttemptedSubmit = true);

                        final password = _passController.text;
                        final confirm = _confirmController.text;

                        final passwordError = _validatePassword(password);
                        final confirmError = _validateConfirmPassword(confirm);

                        if (passwordError != null || confirmError != null) {
                          setState(() {
                            _passwordError = passwordError;
                            _confirmError = confirmError;
                          });
                          return;
                        }

                        setState(() => _submitting = true);

                        // Simulate API call
                        await Future.delayed(const Duration(seconds: 1));

                        if (!mounted) return;
                        setState(() => _submitting = false);
                        if (context.mounted) {
                          AppNavigation.goToPasswordUpdated(context);
                        }
                      }),
          ],
        ),
      ),
    );
  }
}

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) => Container(
        height: 5,
        decoration: BoxDecoration(
          color: on ? AppColors.success : AppColors.border,
          borderRadius: BorderRadius.circular(3),
        ),
      );
}

// =================================================== 09b · Password Updated
class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: FillViewport(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AuthSuccessBadge(navy: false),
            const SizedBox(height: 30),
            Text(AppLocalizations.of(context).passwordUpdated,
                style: AppTheme.dm(
                    size: 26, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context).passwordResetMsg,
                textAlign: TextAlign.center,
                style:
                    AppTheme.dm(size: 15, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 34),
            NavyButton(
                label: AppLocalizations.of(context).signInNow,
                onTap: () => AppNavigation.safeGo(context, '/signin')),
          ],
        ),
      ),
    );
  }
}
