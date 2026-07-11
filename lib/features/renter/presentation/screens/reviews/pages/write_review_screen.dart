import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import '../../bookings/widgets/stars/stars_earned_dialog.dart';
import '../../mawsem/celebration/pages/level_up_celebration_screen.dart';
import '../widgets/review_property_card.dart';
import '../widgets/star_rating_widget.dart';
import '../widgets/review_text_field.dart';
import '../widgets/submit_review_button.dart';

class WriteReviewScreen extends StatefulWidget {
  final String propertyName;
  final String propertyImage;
  final String stayDates;

  const WriteReviewScreen({
    super.key,
    required this.propertyName,
    required this.propertyImage,
    required this.stayDates,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _reviewController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _onRatingChanged(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  Future<void> _submitReview() async {
    // إذا لم يتم كتابة تعليق، لا تفعل شيئاً
    if (_reviewController.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);

    // TODO: Call API
    // POST /reviews
    // Body: {
    //   property_id: "...",
    //   rating: _selectedRating,
    //   review_text: _reviewController.text,
    // }

    await Future.delayed(const Duration(seconds: 2)); // Mock

    if (mounted) {
      setState(() => _isSubmitting = false);

      final profile = context.read<ProfileProvider>();
      final int previousStars = profile.stars;
      final int? newLevel = profile.addStars(5);
      final nextLevel = profile.nextLevelData;

      // Show stars earned dialog
      showDialog(
        context: context,
        barrierColor: const Color(0xFF1B2744).withValues(alpha: 0.7),
        builder: (context) => StarsEarnedDialog(
          starsEarned: 5,
          reason: 'leaving a review for',
          propertyName: widget.propertyName,
          previousTotal: previousStars,
          newTotal: profile.stars,
          starsToNextLevel: nextLevel != null ? nextLevel['stars'] - profile.stars : 0,
          nextLevelName: nextLevel != null ? nextLevel['name'] : 'Max Level',
          onKeepEarning: () {
            Navigator.pop(context); // Close dialog
            
            if (newLevel != null) {
              _showLevelUpCelebration(context, newLevel);
            } else {
              Navigator.pop(context, true); // Return to previous screen
            }
          },
        ),
      );
    }
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
            // Share achievement logic
          },
          onKeepExploring: () {
            Navigator.pop(context); // Close celebration
            Navigator.pop(context, true); // Return to previous screen
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.chevron_left,
              color: AppColors.navy,
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Write a Review',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Card
                    ReviewPropertyCard(
                      propertyName: widget.propertyName,
                      propertyImage: widget.propertyImage,
                      stayDates: widget.stayDates,
                    ),

                    const SizedBox(height: 24),

                    // Star Rating
                    StarRatingWidget(
                      selectedRating: _selectedRating,
                      onRatingChanged: _onRatingChanged,
                    ),

                    const SizedBox(height: 24),

                    // Review Text
                    ReviewTextField(
                      controller: _reviewController,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Submit Button (pinned)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: SafeArea(
                top: false,
                child: SubmitReviewButton(
                  isLoading: _isSubmitting,
                  onSubmit: _submitReview,
                  hasRating: _selectedRating > 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}