import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';

import '../../widgets/mawsem/how_to_earn_section.dart';
import '../../widgets/mawsem/mawsem_hero_card.dart';
import '../../widgets/mawsem/mawsem_levels_list.dart';
import '../../widgets/mawsem/referral_code_card.dart';

class MawsemDashboardScreen extends StatelessWidget {
  const MawsemDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final levelData = profile.levelData;
    final nextLevel = profile.nextLevelData;
    final int starsToNext =
        nextLevel != null ? nextLevel['stars'] - profile.stars : 0;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with Back Button only
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: AppColors.navy,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Hero Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: MawsemHeroCard(
                  levelName: levelData['name'],
                  levelNumber: levelData['level'],
                  totalLevels: 7,
                  currentStars: profile.stars,
                  nextLevelName:
                      nextLevel != null ? nextLevel['name'] : 'Max Level',
                  nextLevelThreshold:
                      nextLevel != null ? nextLevel['stars'] : profile.stars,
                  starsToNext: starsToNext,
                  seasonEndDays: 87,
                ),
              ),
            ),

            // The 7 Levels Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MawsemLevelsList(
                  currentLevel: profile.currentLevel,
                  currentStars: profile.stars,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // How to Earn Stars Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: HowToEarnSection(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Referral Code Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                // Added padding for floating bottom nav
                child: ReferralCodeCard(referralCode: profile.referralCode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
