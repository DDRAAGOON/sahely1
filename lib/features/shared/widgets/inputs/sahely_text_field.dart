import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class SahelyTextField extends StatefulWidget {
  const SahelyTextField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.height = 50,
    this.radius = 12,
    this.leading,
    this.trailing,
    this.fontSize = 14,
    this.letterSpacing,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.onChanged,
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
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  State<SahelyTextField> createState() => _SahelyTextFieldState();
}

class _SahelyTextFieldState extends State<SahelyTextField> {
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
    final bool hasText = widget.controller?.text.isNotEmpty ?? false;
    Color borderCol = widget.borderColor ?? AppColors.border;
    
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
        onChanged: (val) {
          setState(() {});
          if (widget.onChanged != null) widget.onChanged!(val);
        },
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        textAlign: widget.textAlign,
        cursorColor: AppColors.navy,
        inputFormatters: widget.inputFormatters,
        textAlignVertical: isMultiline ? TextAlignVertical.top : TextAlignVertical.center,
        maxLines: isMultiline ? null : 1,
        style: AppTheme.dm(size: widget.fontSize, color: Colors.black, letterSpacing: widget.letterSpacing),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTheme.dm(size: widget.fontSize, color: const Color(0xFFA0A2A0)),
          contentPadding: EdgeInsets.fromLTRB(
            widget.leading != null ? 0 : 14, 
            isMultiline ? 12 : 0, 
            widget.trailing != null ? 0 : 14,
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
