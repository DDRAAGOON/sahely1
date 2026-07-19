import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'level/level_detail_sheet.dart';
import 'level/level_perk.dart';

/// Hero card for AL MAWSEM dashboard.
/// Displays current level, stars, and progress to next tier.
/// TODO: Hook up real-time progress from backend API.
class MawsemHeroCard extends StatelessWidget {
  final String levelName;
  final int levelNumber;
  final int totalLevels;
  final int currentStars;
  final String nextLevelName;
  final int nextLevelThreshold;
  final int starsToNext;
  final int seasonEndDays;

  const MawsemHeroCard({
    super.key,
    required this.levelName,
    required this.levelNumber,
    required this.totalLevels,
    required this.currentStars,
    required this.nextLevelName,
    required this.nextLevelThreshold,
    required this.starsToNext,
    required this.seasonEndDays,
  });

  void _showNextLevelDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LevelDetailSheet(
        levelName: nextLevelName,
        levelIcon: Icons.home_outlined,
        levelColor: const Color(0xFFBC9B43),
        starsRequired: nextLevelThreshold,
        currentStars: currentStars,
        seasonPerks: const [
          LevelPerk(title: 'Complimentary welcome basket'),
          LevelPerk(title: '200 EGP credit on next booking'),
          LevelPerk(title: 'Free early access to new units'),
        ],
        unlockReward: 'Gift: Local Artisan Soap Set',
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = currentStars / nextLevelThreshold;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.mawsemBg, // Updated Background Color #182441
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Glow Circle - Restored to Old Golden Style
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20), // Reduced horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: AL MAWSEM + Season Badge - Fixed Visibility
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AL MAWSEM',
                      style: TextStyle(
                        fontSize: 20, // Restored original size
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                        fontFamily: 'Cairo',
                        letterSpacing: 3, // Balanced spacing
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.mawsemDark, // Background #424446
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Season 2026 · Battle Pass',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mawsemGold, // Text #B1974C
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Level Info Row
                Row(
                  children: [
                    // Teal Medallion with Reduced Glow
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: AppColors.mawsemTeal,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mawsemTeal.withValues(alpha: 0.3), // Toned down glow
                            blurRadius: 12,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.waves,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 12), // Reduced spacing

                    // Level Name + Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level $levelNumber of $totalLevels',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB8C4E0),
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            levelName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stars Count
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$currentStars',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.gold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: AppColors.gold, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Sahel Stars',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.gold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Progress Bar Section - Clickable
                GestureDetector(
                  onTap: () => _showNextLevelDetail(context),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mawsemProgress),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Progress Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Cairo'),
                              children: [
                                TextSpan(text: '$starsToNext', style: const TextStyle(fontWeight: FontWeight.w900)),
                                const TextSpan(text: ' ★', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                                const TextSpan(text: ' to ', style: TextStyle(color: Color(0xFFB8C4E0))),
                                TextSpan(text: nextLevelName, style: const TextStyle(color: Color(0xFFB8C4E0))),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13, color: Color(0xFFB8C4E0), fontFamily: 'Cairo'),
                              children: [
                                TextSpan(text: '$nextLevelThreshold', style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                                const TextSpan(text: ' ★', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Bottom Chips Row
                Row(
                  children: [
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.access_time,
                        label: 'Ends in $seasonEndDays days',
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: _InfoChip(
                        icon: Icons.refresh,
                        label: 'Resets each season',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.mawsemDark.withValues(alpha: 0.3), // Background #424446
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.gold),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Cairo',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
