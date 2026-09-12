import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

import 'package:sahely/features/shared/widgets/mawsem/level/level_detail_sheet.dart';
import 'package:sahely/features/shared/widgets/mawsem/mawsem_scene_background.dart';

/// Hero card for AL MAWSEM dashboard.
/// Displays current level, stars, and progress to next tier.
class MawsemHeroCard extends StatelessWidget {
  final String levelName;
  final int levelNumber;
  final int totalLevels;
  final int currentStars;
  final String nextLevelName;
  final int nextLevelThreshold;
  final int starsToNext;

  /// Days left in the running season, or null when no season is running.
  final int? seasonEndDays;

  /// The season name the backend reports, if any.
  final String seasonName;

  const MawsemHeroCard({
    super.key,
    required this.levelName,
    required this.levelNumber,
    required this.totalLevels,
    required this.currentStars,
    required this.nextLevelName,
    required this.nextLevelThreshold,
    required this.starsToNext,
    this.seasonEndDays,
    this.seasonName = '',
  });

  /// The next level, with no perk list: `GET /mawsem/perks` only answers for
  /// the level the account is on, so the perks of a level above it are not
  /// known to the app.
  void _showNextLevelDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LevelDetailSheet(
        levelName: nextLevelName,
        levelIcon: Icons.star_outline,
        levelColor: const Color(0xFFBC9B43),
        starsRequired: nextLevelThreshold,
        currentStars: currentStars,
        seasonPerks: const [],
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = currentStars / nextLevelThreshold;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.mawsemBg,
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
          const Positioned.fill(child: MawsemSceneBackground()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: AL MAWSEM + Season Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'AL MAWSEM',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                              fontFamily: 'DM Sans',
                              letterSpacing: 2,
                            ),
                          )),
                    ),
                    const SizedBox(width: 8),
                    // The season badge only appears when a season is running.
                    if (seasonName.isNotEmpty)
                      Flexible(
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerEnd,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.mawsemDark,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                seasonName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mawsemGold,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                            )),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Level Info Row
                Row(
                  children: [
                    // Teal Medallion
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.mawsemTealStart,
                            AppColors.mawsemTealEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.waves,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Level Name + Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level $levelNumber of $totalLevels',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mawsemTextMuted,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            levelName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'DM Sans',
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
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.mawsemGoldBright,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star,
                                color: AppColors.mawsemGoldBright, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Sahel Stars',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mawsemGoldBright,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Progress Bar Section
                GestureDetector(
                  onTap: () => _showNextLevelDetail(context),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: AppColors.mawsemProgressTrack,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.mawsemGoldBright),
                          minHeight: 7,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Progress Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: 'DM Sans'),
                              children: [
                                TextSpan(
                                    text: '$starsToNext',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800)),
                                const TextSpan(
                                    text: '★',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800)),
                                const TextSpan(
                                    text: ' to ',
                                    style: TextStyle(
                                        color: AppColors.mawsemTextMuted)),
                                TextSpan(
                                    text: nextLevelName,
                                    style: const TextStyle(
                                        color: AppColors.mawsemTextMuted,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: 'DM Sans'),
                              children: [
                                TextSpan(
                                    text: '$nextLevelThreshold',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800)),
                                const TextSpan(
                                    text: ' ★',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Bottom Chips Row
                Row(
                  children: [
                    if (seasonEndDays != null) ...[
                      Expanded(
                        child: _InfoChip(
                          icon: Icons.access_time,
                          label: 'Ends in $seasonEndDays days',
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.mawsemDark.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.mawsemGoldBright),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'DM Sans',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
