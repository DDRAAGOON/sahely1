import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A wrapper that adds a "Instagram-like" scale effect and haptic feedback on tap.
class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  const BouncyButton({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.96,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isDown = false;

  void _onPointerDown(PointerDownEvent event) {
    if (widget.onTap != null) {
      _isDown = true;
      _controller.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onPointerUp(PointerUpEvent event) async {
    _isDown = false;
    if (widget.onTap != null) {
      if (_controller.status != AnimationStatus.completed) {
        await _controller.forward();
      }
      if (!_isDown) {
        _controller.reverse();
      }
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _isDown = false;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: GestureDetector(
        onTap: () async {
          if (widget.onTap != null) {
            // Give enough delay for the bounce down animation to become visible 
            // before the main thread potentially blocks to build a new screen.
            await Future.delayed(const Duration(milliseconds: 120));
            if (mounted) widget.onTap!();
          }
        },
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: RepaintBoundary(child: widget.child),
        ),
      ),
    );
  }
}
