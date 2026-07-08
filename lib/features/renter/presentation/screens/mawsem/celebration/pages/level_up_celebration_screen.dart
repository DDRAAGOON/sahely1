import 'package:flutter/material.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../widgets/celebration_icon.dart';
import '../widgets/level_unlocked_text.dart';
import '../widgets/unlock_reward_card.dart';
import '../widgets/level_stats_row.dart';
import '../widgets/share_achievement_button.dart';

class LevelUpCelebrationScreen extends StatefulWidget {
  final int newLevel;
  final String levelName;
  final IconData levelIcon;
  final Color levelColor;
  final String unlockBenefit;
  final String unlockRewardTitle;
  final String unlockRewardDescription;
  final int currentSeasonStars;
  final int starsToNextLevel;
  final VoidCallback onShare;
  final VoidCallback onKeepExploring;

  const LevelUpCelebrationScreen({
    super.key,
    required this.newLevel,
    required this.levelName,
    required this.levelIcon,
    required this.levelColor,
    required this.unlockBenefit,
    required this.unlockRewardTitle,
    required this.unlockRewardDescription,
    required this.currentSeasonStars,
    required this.starsToNextLevel,
    required this.onShare,
    required this.onKeepExploring,
  });

  @override
  State<LevelUpCelebrationScreen> createState() =>
      _LevelUpCelebrationScreenState();
}

class _LevelUpCelebrationScreenState extends State<LevelUpCelebrationScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _cardController;

  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotateAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _cardFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Icon animation
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _iconRotateAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    // Card animation
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    ));

    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    // Start animations in sequence
    _iconController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Celebration Icon
              ScaleTransition(
                scale: _iconScaleAnimation,
                child: RotationTransition(
                  turns: _iconRotateAnimation,
                  child: CelebrationIcon(
                    icon: widget.levelIcon,
                    color: widget.levelColor,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Level Unlocked Text
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Column(
                    children: [
                      LevelUnlockedText(
                        levelNumber: widget.newLevel,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You're a ${widget.levelName}!",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.unlockBenefit,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                          fontFamily: 'DM Sans',
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Unlock Reward Card
              SlideTransition(
                position: _cardSlideAnimation,
                child: FadeTransition(
                  opacity: _cardFadeAnimation,
                  child: UnlockRewardCard(
                    title: widget.unlockRewardTitle,
                    description: widget.unlockRewardDescription,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Level Stats
              SlideTransition(
                position: _cardSlideAnimation,
                child: FadeTransition(
                  opacity: _cardFadeAnimation,
                  child: LevelStatsRow(
                    currentStars: widget.currentSeasonStars,
                    starsToNextLevel: widget.starsToNextLevel,
                    nextLevel: widget.newLevel + 1,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Share Achievement Button
              ShareAchievementButton(
                onTap: widget.onShare,
              ),

              const SizedBox(height: 16),

              // Keep Exploring
              GestureDetector(
                onTap: widget.onKeepExploring,
                child: const Text(
                  'Keep exploring',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
