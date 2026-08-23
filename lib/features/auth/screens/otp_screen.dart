import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/cream_background.dart';
import 'package:sahely/core/widgets/ui.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.title,
    this.email,
    this.phone,
    this.subtitleSpans,
    required this.icon,
    required this.hint,
    required this.cta,
    required this.onVerify,
    this.bottomText = 'Wrong email? Change it',
    this.isPhone = false,
  });

  final String title;
  final String? email;
  final String? phone;
  final List<InlineSpan>? subtitleSpans;
  final IconData icon;
  final String hint;
  final String cta;
  final VoidCallback onVerify;
  final String bottomText;
  final bool isPhone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsRemaining = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _secondsRemaining = 59);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatPhone(String? phone) {
    if (phone == null) return '';
    if (phone.length < 10) return phone;
    return '${phone.substring(0, 3)} *** *** ${phone.substring(phone.length - 2)}';
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
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Align(
                        alignment: Alignment.centerLeft, child: BackChip()),
                    const SizedBox(height: 28),
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x4D1B2744),
                              blurRadius: 26,
                              offset: Offset(0, 10))
                        ],
                      ),
                      child: Icon(widget.icon, color: AppColors.gold, size: 36),
                    ),
                    const SizedBox(height: 22),
                    Text(widget.title,
                        style: AppTheme.dm(
                            size: 22,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTheme.dm(
                            size: 14, color: AppColors.muted, height: 1.5),
                        children: widget.subtitleSpans ??
                            [
                              TextSpan(
                                  text: widget.isPhone
                                      ? 'We sent a 6-digit code to\n'
                                      : 'Enter the 6-digit code we emailed to\n'),
                              TextSpan(
                                text: widget.isPhone
                                    ? _formatPhone(widget.phone)
                                    : (widget.email ?? ''),
                                style: AppTheme.dm(
                                    weight: FontWeight.w700,
                                    color: const Color(0xFF2D2D2D)),
                              ),
                            ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        for (var i = 0; i < 6; i++) ...[
                          Expanded(
                            child: _OtpInputBox(
                              controller: _controllers[i],
                              focusNode: _focusNodes[i],
                              onChanged: (value) {
                                if (value.isNotEmpty && i < 5) {
                                  _focusNodes[i + 1].requestFocus();
                                } else if (value.isEmpty && i > 0) {
                                  _focusNodes[i - 1].requestFocus();
                                }
                              },
                            ),
                          ),
                          if (i < 5) const SizedBox(width: 9),
                        ],
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.mail_outline,
                            size: 15, color: AppColors.gold),
                        const SizedBox(width: 8),
                        Flexible(
                            child: Text(widget.hint,
                                style: AppTheme.dm(
                                    size: 13, color: AppColors.muted))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    NavyButton(label: widget.cta, onTap: widget.onVerify),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: _secondsRemaining == 0 ? _startCountdown : null,
                      child: RichText(
                        text: TextSpan(
                          text: _secondsRemaining == 0
                              ? 'Resend code now'
                              : 'Resend code in ',
                          style: AppTheme.dm(size: 13, color: AppColors.muted),
                          children: [
                            if (_secondsRemaining > 0)
                              TextSpan(
                                text: _formatTime(_secondsRemaining),
                                style: AppTheme.dm(
                                    size: 13,
                                    weight: FontWeight.w700,
                                    color: AppColors.ink),
                              )
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        widget.bottomText,
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w600,
                            color: AppColors.gold),
                      ),
                    ),
                    const SizedBox(height: 24),
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

class _OtpInputBox extends StatelessWidget {
  const _OtpInputBox({required this.controller, required this.focusNode, required this.onChanged});
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
