import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

import 'package:sahely/features/shared/widgets/mawsem/mawsem_hero_card.dart';
import 'package:sahely/features/shared/widgets/mawsem/referral_code_card.dart';
import 'package:sahely/features/broker/presentation/screens/mawsem/widgets/broker_how_to_earn_section.dart';
import 'package:sahely/features/broker/presentation/screens/mawsem/widgets/broker_mawsem_levels_list.dart';

class BrokerMawsemPage extends StatelessWidget {
  const BrokerMawsemPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mocking Broker loyalty data for now
    const int currentStars = 47;
    const int currentLevel = 3;
    const String levelName = 'Wave Rider';
    const String nextLevelName = 'Coastal Regular';
    const int nextLevelThreshold = 80;
    const int starsToNext = nextLevelThreshold - currentStars;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with Back Button
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
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: MawsemHeroCard(
                  levelName: levelName,
                  levelNumber: currentLevel,
                  totalLevels: 7,
                  currentStars: currentStars,
                  nextLevelName: nextLevelName,
                  nextLevelThreshold: nextLevelThreshold,
                  starsToNext: starsToNext,
                  seasonEndDays: 87,
                ),
              ),
            ),

            // The 7 Levels Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: BrokerMawsemLevelsList(
                  currentLevel: currentLevel,
                  currentStars: currentStars,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // How to Earn Stars Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: BrokerHowToEarnSection(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Referral Code Card
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: ReferralCodeCard(referralCode: 'KARIM-BROKER'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
