import 'dart:async';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/cream_background.dart';
import '../../../widgets/ui.dart';
import '../widgets/auth_success_badge.dart';

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
                      decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
                      child: const Icon(Icons.lock_outline, color: AppColors.gold, size: 30),
                    ),
                    const SizedBox(height: 22),
                    Text('Reset Your Access', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(height: 8),
                    Text("Enter your email and we'll send a 6-digit OTP",
                        style: AppTheme.dm(size: 14, color: AppColors.muted, height: 1.5)),
                    const SizedBox(height: 24),
                    FieldGroup(
                        label: 'Email Address',
                        child: AppTextField(
                          controller: _emailController,
                          hintText: 'mariam.hassan@gmail.com',
                          height: 50,
                          radius: 999,
                        )),
                    const SizedBox(height: 24),
                    NavyButton(label: 'Send OTP', radius: 999, onTap: () => Navigator.pushNamed(context, '/reset-otp')),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: _secondsRemaining == 0 ? _startCountdown : null,
                        child: RichText(
                          text: TextSpan(
                            text: _secondsRemaining == 0 ? "Resend code now" : "Didn't get it? Resend in ",
                            style: AppTheme.dm(size: 13, color: AppColors.muted),
                            children: [
                              if (_secondsRemaining > 0)
                                TextSpan(
                                  text: _formatTime(_secondsRemaining),
                                  style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.ink)
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.popUntil(context, ModalRoute.withName('/signin')),
                        child: Text('Back to Sign In',
                            style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold)),
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

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
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
                decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.lock_outline, color: AppColors.gold, size: 30),
              ),
            ),
            const SizedBox(height: 20),
            Text('Set a new password',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            Text('At least 8 characters with letters, numbers & a symbol',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 13, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 14),
            FieldGroup(
              label: 'New Password',
              child: AppTextField(
                controller: _passController,
                hintText: '••••••••',
                height: 50,
                radius: 999,
                fontSize: 18,
                letterSpacing: 3,
                obscureText: _obscure1,
                trailing: GestureDetector(
                  onTap: () => setState(() => _obscure1 = !_obscure1),
                  child: Icon(
                    _obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20, color: AppColors.muted
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            FieldGroup(
              label: 'Confirm Password',
              child: AppTextField(
                controller: _confirmController,
                hintText: '••••••••',
                height: 50,
                radius: 999,
                fontSize: 18,
                letterSpacing: 3,
                obscureText: _obscure2,
                trailing: GestureDetector(
                  onTap: () => setState(() => _obscure2 = !_obscure2),
                  child: Icon(
                    _obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20, color: AppColors.muted
                  ),
                ),
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
            Text('Strong password', style: AppTheme.dm(size: 11, weight: FontWeight.w600, color: AppColors.success)),
            const SizedBox(height: 30),
            NavyButton(
                label: 'Update Password', radius: 999, onTap: () => Navigator.pushNamed(context, '/password-updated')),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AuthSuccessBadge(navy: false),
            const SizedBox(height: 30),
            Text('Password Updated', style: AppTheme.dm(size: 26, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 10),
            Text('Your password has been reset.\nSign in to continue.',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 15, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 34),
            NavyButton(
                label: 'Sign In Now',
                onTap: () => Navigator.popUntil(context, ModalRoute.withName('/signin'))),
          ],
        ),
      ),
    );
  }
}
