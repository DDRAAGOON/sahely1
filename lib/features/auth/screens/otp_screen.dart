import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/cream_background.dart';
import 'package:sahely/l10n/app_localizations.dart';
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
    this.bottomText,
    this.isPhone = false,
    this.onCodeChanged,
    this.onResend,
  });

  final String title;
  final String? email;
  final String? phone;
  final List<InlineSpan>? subtitleSpans;
  final IconData icon;
  final String hint;
  final String cta;
  final VoidCallback onVerify;
  final String? bottomText;
  final bool isPhone;
  final ValueChanged<String>? onCodeChanged;
  final Future<void> Function()? onResend;

  @override
  State<OtpScreen> createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
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

  /// Joined OTP digits — read by parents through a [GlobalKey<OtpScreenState>].
  String get code => _controllers.map((c) => c.text).join();

  void _handlePaste(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    for (var i = 0; i < 6; i++) {
      if (i < digits.length) {
        _controllers[i].text = digits[i];
      } else {
        _controllers[i].clear();
      }
    }
    // Set focus to the appropriate box
    final focusIndex = digits.length >= 6 ? 5 : digits.length;
    _focusNodes[focusIndex].requestFocus();
    
    widget.onCodeChanged?.call(code);
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
                                      ? AppLocalizations.of(context).otpSentTo
                                      : AppLocalizations.of(context).otpEnterCode),
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
                                if (value.length > 1) {
                                  _handlePaste(value);
                                  return;
                                }
                                if (value.isNotEmpty && i < 5) {
                                  _focusNodes[i + 1].requestFocus();
                                }
                                widget.onCodeChanged?.call(code);
                              },
                              onDelete: () {
                                if (i > 0) {
                                  _focusNodes[i - 1].requestFocus();
                                  _controllers[i - 1].clear();
                                  widget.onCodeChanged?.call(code);
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
                      onTap: _secondsRemaining == 0
                          ? () async {
                              _startCountdown();
                              await widget.onResend?.call();
                            }
                          : null,
                      child: RichText(
                        text: TextSpan(
                          text: _secondsRemaining == 0
                              ? AppLocalizations.of(context).resendNow
                              : AppLocalizations.of(context).resendIn,
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
                         widget.bottomText ??
                             AppLocalizations.of(context).wrongEmail,
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

class _OtpInputBox extends StatefulWidget {
  const _OtpInputBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onDelete,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onDelete;

  @override
  State<_OtpInputBox> createState() => _OtpInputBoxState();
}

class _OtpInputBoxState extends State<_OtpInputBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    widget.focusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.backspace &&
          widget.controller.text.isEmpty) {
        widget.onDelete();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
    if (widget.focusNode.hasFocus) {
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused ? AppColors.gold : AppColors.border,
          width: _isFocused ? 2 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
        ],
        style: AppTheme.dm(
            size: 20, weight: FontWeight.w700, color: AppColors.navy),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

