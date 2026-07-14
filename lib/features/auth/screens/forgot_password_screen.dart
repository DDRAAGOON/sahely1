import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';

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
