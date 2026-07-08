import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AuthSuccessBadge extends StatefulWidget {
  const AuthSuccessBadge({super.key, required this.navy});
  final bool navy;
  @override
  State<AuthSuccessBadge> createState() => _AuthSuccessBadgeState();
}

class _AuthSuccessBadgeState extends State<AuthSuccessBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.navy ? 108.0 : 104.0;
    return SizedBox(
      width: size + 30,
      height: size + 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _c,
            builder: (_, __) {
              final t = _c.value;
              return Container(
                width: size * (0.7 + t * 1.4),
                height: size * (0.7 + t * 1.4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.55 * (1 - t)), width: 3),
                ),
              );
            },
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.navy
                  ? null
                  : const RadialGradient(center: Alignment(0, -0.2), colors: [AppColors.goldBright, AppColors.gold]),
              color: widget.navy ? AppColors.navy : null,
              boxShadow: [
                BoxShadow(
                    color: (widget.navy ? AppColors.navy : AppColors.gold).withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 12)),
              ],
            ),
            child: Icon(widget.navy ? Icons.verified_user_outlined : Icons.check,
                color: widget.navy ? AppColors.gold : AppColors.white, size: widget.navy ? 50 : 50),
          ),
        ],
      ),
    );
  }
}
