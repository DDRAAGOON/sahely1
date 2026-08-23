import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class AuthSuccessBadge extends StatefulWidget {
  const AuthSuccessBadge({super.key, required this.navy});

  final bool navy;

  @override
  State<AuthSuccessBadge> createState() => _AuthSuccessBadgeState();
}

class _AuthSuccessBadgeState extends State<AuthSuccessBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..forward();

  late final Animation<double> _anim = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOut,
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.navy ? 128.0 : 124.0;
    return SizedBox(
      width: size + 60,
      height: size + 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) {
              final t = _anim.value;
              // ring starts at circle size and expands outward to a fixed halo
              return Container(
                width: size * (1.0 + t * 0.45),
                height: size * (1.0 + t * 0.45),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.45 * (1 - t * 0.5)),
                      width: 3),
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
                  : const RadialGradient(
                      center: Alignment(0, -0.2),
                      colors: [AppColors.goldBright, AppColors.gold]),
              color: widget.navy ? AppColors.navy : null,
              boxShadow: [
                BoxShadow(
                    color: (widget.navy ? AppColors.navy : AppColors.gold)
                        .withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 12)),
              ],
            ),
            child: Icon(
                widget.navy ? Icons.verified_user_outlined : Icons.check,
                color: widget.navy ? AppColors.gold : AppColors.white,
                size: widget.navy ? 60 : 60),
          ),
        ],
      ),
    );
  }
}
