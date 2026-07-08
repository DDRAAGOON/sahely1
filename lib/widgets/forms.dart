import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// A real text field for user input.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.height = 50,
    this.radius = 10,
    this.leading,
    this.trailing,
    this.fontSize = 14,
    this.letterSpacing,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double height;
  final double radius;
  final Widget? leading;
  final Widget? trailing;
  final double fontSize;
  final double? letterSpacing;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final TextAlign textAlign;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = widget.height > 60;
    
    // Logic: use gold if focused or has text, unless a specific borderColor was forced
    final bool hasText = widget.controller?.text.isNotEmpty ?? false;
    Color borderCol = widget.borderColor ?? AppColors.border;
    
    // If user didn't force a color, we apply the logic
    if (widget.borderColor == null) {
      if (_isFocused || hasText) {
        borderCol = AppColors.gold;
      }
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: borderCol, width: _isFocused ? 1.5 : widget.borderWidth),
      ),
      alignment: isMultiline ? Alignment.topLeft : Alignment.center,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: (_) => setState(() {}), // Trigger rebuild to update border if text is empty/full
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        textAlign: widget.textAlign,
        cursorColor: AppColors.navy,
        textAlignVertical: isMultiline ? TextAlignVertical.top : TextAlignVertical.center,
        maxLines: isMultiline ? null : 1,
        style: AppTheme.dm(size: widget.fontSize, color: AppColors.ink, letterSpacing: widget.letterSpacing),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTheme.dm(size: widget.fontSize, color: AppColors.faint),
          contentPadding: EdgeInsets.fromLTRB(
            widget.leading != null ? 0 : (widget.radius >= 999 ? 18 : 14), 
            isMultiline ? 12 : 0, 
            widget.trailing != null ? 0 : (widget.radius >= 999 ? 18 : 14),
            isMultiline ? 12 : 0
          ),
          border: InputBorder.none,
          isDense: true,
          prefixIcon: widget.leading,
          suffixIcon: widget.trailing,
        ),
      ),
    );
  }
}

/// A non-editable rounded box that looks like a text field.
class FakeField extends StatelessWidget {
  const FakeField({
    super.key,
    required this.value,
    this.hint = false,
    this.focused = false,
    this.height = 50,
    this.radius = 10,
    this.trailing,
    this.letterSpacing,
    this.fontSize = 14,
  });

  final String value;
  final bool hint;
  final bool focused;
  final double height;
  final double radius;
  final Widget? trailing;
  final double? letterSpacing;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: radius >= 999 ? 18 : 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: focused ? AppColors.gold : AppColors.border, width: focused ? 2 : 1),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: AppTheme.dm(
                size: fontSize,
                color: hint ? AppColors.faint : AppColors.ink,
                letterSpacing: letterSpacing,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Labelled field group: small bold label above a child widget.
class FieldGroup extends StatelessWidget {
  const FieldGroup({super.key, this.label, required this.child, this.trailingLabel, this.labelWidget});
  final String? label;
  final Widget child;
  final Widget? trailingLabel;
  final Widget? labelWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (labelWidget != null)
                labelWidget!
              else
                Text(label ?? '', style: AppTheme.dm(size: 13, weight: FontWeight.w600)),
              if (trailingLabel != null) trailingLabel!,
            ],
          ),
        ),
        child,
      ],
    );
  }
}

/// Lightweight dashed-border wrapper.
class DottedBorder extends StatelessWidget {
  const DottedBorder({super.key, required this.child, required this.color, this.radius = 14});
  final Widget child;
  final Color color;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DashPainter(color: color, radius: radius), child: child);
  }
}

class _DashPainter extends CustomPainter {
  _DashPainter({required this.color, required this.radius});
  final Color color;
  final double radius;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    const dash = 6.0, gap = 5.0;
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        canvas.drawPath(metric.extractPath(dist, dist + dash), paint);
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter old) => old.color != color;
}
