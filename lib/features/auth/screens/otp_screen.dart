import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/cream_background.dart';
import '../../../widgets/ui.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.title,
    this.subtitleSpans,
    required this.icon,
    required this.hint,
    required this.cta,
    this.code = '',
    this.bottomText = 'Wrong email? Change it',
    this.onVerify,
    this.isPhone = false,
  });

  final String title;
  final List<TextSpan>? subtitleSpans;
  final IconData icon;
  final String hint;
  final String cta;
  final String code;
  final String bottomText;
  final VoidCallback? onVerify;
  final bool isPhone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  Timer? _timer;
  int _secondsRemaining = 120; // 2 minutes

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // Pre-filled code removal: we won't pre-fill from widget.code if it's empty, 
    // and we ensure the controllers are cleared.
    for (var c in _controllers) {
      c.clear();
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsRemaining = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
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
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final dynamicEmail = args?['email'] as String?;
    final dynamicPhone = args?['phone'] as String?;

    return PhoneScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 34),
                  child: Column(
                    children: [
                      const Align(alignment: Alignment.centerLeft, child: BackChip()),
                      const SizedBox(height: 28),
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Color(0x4D1B2744), blurRadius: 26, offset: Offset(0, 10))],
                        ),
                        child: Icon(widget.icon, color: AppColors.gold, size: 36),
                      ),
                      const SizedBox(height: 22),
                      Text(widget.title, style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 8),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTheme.dm(size: 14, color: AppColors.muted, height: 1.5),
                          children: widget.subtitleSpans ??
                              [
                                TextSpan(
                                  text: widget.isPhone 
                                    ? 'We sent a 6-digit code to\n' 
                                    : 'Enter the 6-digit code we emailed to\n'
                                ),
                                TextSpan(
                                  text: widget.isPhone 
                                    ? (dynamicPhone != null ? '+20 $dynamicPhone' : '+20 100 ••• ••42')
                                    : (dynamicEmail ?? 'mariam.hassan@gmail.com'),
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2D2D2D)),
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
                          const Icon(Icons.mail_outline, size: 15, color: AppColors.gold),
                          const SizedBox(width: 8),
                          Flexible(child: Text(widget.hint, style: AppTheme.dm(size: 13, color: AppColors.muted))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      NavyButton(label: widget.cta, onTap: widget.onVerify),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: _secondsRemaining == 0 ? _startCountdown : null,
                        child: RichText(
                          text: TextSpan(
                            text: _secondsRemaining == 0 ? 'Resend code now' : 'Resend code in ',
                            style: AppTheme.dm(size: 13, color: AppColors.muted),
                            children: [
                              if (_secondsRemaining > 0)
                                TextSpan(
                                  text: _formatTime(_secondsRemaining),
                                  style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.ink),
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
                          style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OtpInputBox extends StatelessWidget {
  const _OtpInputBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}
