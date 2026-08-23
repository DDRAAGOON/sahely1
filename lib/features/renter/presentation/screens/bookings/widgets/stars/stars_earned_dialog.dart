import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/stars/animated_star_icon.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/stars/stars_progress_bar.dart';

class StarsEarnedDialog extends StatefulWidget {
  final int starsEarned;
  final String reason;
  final String propertyName;
  final int previousTotal;
  final int newTotal;
  final int starsToNextLevel;
  final String nextLevelName;
  final VoidCallback onKeepEarning;

  const StarsEarnedDialog({
    super.key,
    required this.starsEarned,
    required this.reason,
    required this.propertyName,
    required this.previousTotal,
    required this.newTotal,
    required this.starsToNextLevel,
    required this.nextLevelName,
    required this.onKeepEarning,
  });

  @override
  State<StarsEarnedDialog> createState() => _StarsEarnedDialogState();
}

class _StarsEarnedDialogState extends State<StarsEarnedDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _counterController;
  late AnimationController _progressController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _counterAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    );

    _counterController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _counterAnimation = Tween<double>(
      begin: 0,
      end: widget.starsEarned.toDouble(),
    ).animate(CurvedAnimation(
      parent: _counterController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    ));

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: widget.previousTotal.toDouble(),
      end: widget.newTotal.toDouble(),
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    ));

    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _counterController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _progressController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _counterController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(_slideAnimation),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: const AnimatedStarIcon(),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _counterAnimation,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+${_counterAnimation.value.toInt()}',
                          style: AppTheme.dm(
                            size: 36,
                            weight: FontWeight.w700,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.star,
                          color: AppColors.gold,
                          size: 32,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Stars earned!',
                  style: AppTheme.dm(
                    size: 22,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'For ${widget.reason}\n${widget.propertyName}',
                  textAlign: TextAlign.center,
                  style: AppTheme.dm(
                    size: 14,
                    color: AppColors.secondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return StarsProgressBar(
                      previousTotal: widget.previousTotal,
                      currentTotal: _progressAnimation.value.toInt(),
                      starsToNextLevel: widget.starsToNextLevel,
                      nextLevelName: widget.nextLevelName,
                    );
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: widget.onKeepEarning,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Keep earning',
                      style: AppTheme.dm(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
