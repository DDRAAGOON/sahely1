import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import '../widgets/animated_checkmark.dart';
import '../widgets/booking_details_card.dart';
import '../widgets/stars_earned_card.dart';
import '../widgets/smart_lock_card.dart';
import '../widgets/booking_action_buttons.dart';
import '../widgets/stars/stars_earned_dialog.dart';
import '../../mawsem/celebration/pages/level_up_celebration_screen.dart';
import 'smart_lock_screen.dart';

class BookingConfirmedScreen extends StatefulWidget {
  final String propertyName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final String unitInfo;
  final String bookingRef;
  final int totalPaid;
  final int starsEarned;

  const BookingConfirmedScreen({
    super.key,
    required this.propertyName,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.unitInfo,
    required this.bookingRef,
    required this.totalPaid,
    required this.starsEarned,
  });

  @override
  State<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends State<BookingConfirmedScreen> {
  @override
  void initState() {
    super.initState();
    // Show stars earned dialog after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStarsEarnedDialog();
    });
  }

  void _showStarsEarnedDialog() {
    final profile = context.read<ProfileProvider>();
    final int previousStars = profile.stars;
    final int? newLevel = profile.addStars(widget.starsEarned);
    final nextLevel = profile.nextLevelData;

    showDialog(
      context: context,
      barrierColor: const Color(0xFF1B2744).withValues(alpha: 0.7),
      builder: (context) => StarsEarnedDialog(
        starsEarned: widget.starsEarned,
        reason: 'confirming your booking at',
        propertyName: widget.propertyName,
        previousTotal: previousStars,
        newTotal: profile.stars,
        starsToNextLevel: nextLevel != null ? nextLevel['stars'] - profile.stars : 0,
        nextLevelName: nextLevel != null ? nextLevel['name'] : 'Max Level',
        onKeepEarning: () {
          Navigator.pop(context); // Close dialog
          if (newLevel != null) {
            _showLevelUpCelebration(context, newLevel);
          }
        },
      ),
    );
  }

  void _showLevelUpCelebration(BuildContext context, int level) {
    final profile = context.read<ProfileProvider>();
    final levelData = profile.levelData;
    final nextLevel = profile.nextLevelData;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelUpCelebrationScreen(
          newLevel: level,
          levelName: levelData['name'],
          levelIcon: levelData['icon'],
          levelColor: levelData['color'],
          unlockBenefit: 'Premium benefits and exclusive access are now yours.',
          unlockRewardTitle: 'Level Reward',
          unlockRewardDescription: 'Exclusive Digital Badge',
          currentSeasonStars: profile.stars,
          starsToNextLevel: nextLevel != null ? nextLevel['stars'] - profile.stars : 0,
          onShare: () {
            // Share achievement
          },
          onKeepExploring: () {
            Navigator.pop(context); // Close celebration
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              
              const Center(child: AnimatedCheckmark()),

              const SizedBox(height: 16),

              const Text(
                "You're All Set!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: 'DM Sans',
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Your booking at ${widget.propertyName}\nis confirmed.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontFamily: 'DM Sans',
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              BookingDetailsCard(
                checkIn: widget.checkIn,
                checkOut: widget.checkOut,
                adults: widget.adults,
                unitInfo: widget.unitInfo,
                bookingRef: widget.bookingRef,
                totalPaid: widget.totalPaid,
              ),

              const SizedBox(height: 12),

              StarsEarnedCard(starsEarned: widget.starsEarned),

              const SizedBox(height: 12),

              SmartLockCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SmartLockScreen(
                        propertyName: widget.propertyName,
                        bookingRef: widget.bookingRef,
                        passcode: '8842', // Mock passcode
                        checkIn: widget.checkIn,
                        checkOut: widget.checkOut,
                        propertyLat: 31.0263, // Mock Lat
                        propertyLng: 28.9402, // Mock Lng
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              BookingActionButtons(
                onViewBookings: () => AppNavigation.goToRenterBookings(context),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
