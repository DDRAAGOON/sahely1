import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class AnimatedCheckmark extends StatefulWidget {
  const AnimatedCheckmark({super.key});

  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  late Animation<double> _ripple1Animation;
  late Animation<double> _ripple2Animation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _ripple1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _ripple2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _mainController.forward();
    _rippleController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripples with increased visibility
          AnimatedBuilder(
            animation: _ripple1Animation,
            builder: (context, child) {
              return Opacity(
                opacity: (1.0 - _ripple1Animation.value) * 0.6,
                child: Transform.scale(
                  scale: 1.0 + (_ripple1Animation.value * 0.6),
                  child: Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _ripple2Animation,
            builder: (context, child) {
              return Opacity(
                opacity: (1.0 - _ripple2Animation.value) * 0.4,
                child: Transform.scale(
                  scale: 1.0 + (_ripple2Animation.value * 0.6),
                  child: Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Main Circle
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _checkAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: CheckmarkPainter(_checkAnimation.value),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;
  CheckmarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.5 // Bolder stroke for better visibility
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Adjusted coordinates for better centering in smaller circle
    final startX = size.width * 0.32;
    final startY = size.height * 0.52;
    final midX = size.width * 0.46;
    final midY = size.height * 0.66;
    final endX = size.width * 0.70;
    final endY = size.height * 0.36;

    path.moveTo(startX, startY);
    path.lineTo(midX, midY);
    path.lineTo(endX, endY);

    final metrics = path.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      final metric = metrics.first;
      final extractPath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) => oldDelegate.progress != progress;
}
