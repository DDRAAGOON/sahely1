import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'mawsem_level_tile.dart';
import '../../profile/widgets/level/level_detail_sheet.dart';
import '../../profile/widgets/level/level_perk.dart';

class MawsemLevelsList extends StatelessWidget {
  final int currentLevel;
  final int currentStars;

  const MawsemLevelsList({
    super.key,
    required this.currentLevel,
    required this.currentStars,
  });

  void _showLevelDetail(BuildContext context, Map<String, dynamic> level) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LevelDetailSheet(
        levelName: level['name'],
        levelIcon: level['icon'],
        levelColor: level['iconColor'],
        starsRequired: level['stars'],
        currentStars: currentStars,
        seasonPerks: (level['detailedPerks'] as List<LevelPerk>? ?? []),
        unlockReward: level['reward'],
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  // Level data updated to match image colors and added detailed perks
  static const List<Map<String, dynamic>> _levels = [
    {
      'number': 1,
      'name': 'Beach Walker',
      'stars': 0,
      'icon': Icons.person_outline,
      'perks': 'Standard booking & dashboard',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': Color(0xFF717171),
      'detailedPerks': [
        LevelPerk(title: 'Standard booking access'),
        LevelPerk(title: 'Basic Mawsem dashboard'),
      ],
      'reward': 'Coastal Starter Badge',
    },
    {
      'number': 2,
      'name': 'Shore Explorer',
      'stars': 15,
      'icon': Icons.waves,
      'perks': 'Late checkout + early check-in',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': AppColors.mawsemTeal,
      'detailedPerks': [
        LevelPerk(title: 'Late checkout (2 hours)', subtitle: 'Subject to availability'),
        LevelPerk(title: 'Early check-in (2 hours)', subtitle: 'Subject to availability'),
      ],
      'reward': 'Shore Explorer Badge',
    },
    {
      'number': 3,
      'name': 'Wave Rider',
      'stars': 40,
      'icon': Icons.waves,
      'perks': '15% off concierge + priority support',
      'bgColor': AppColors.mawsemBg,
      'textColor': Colors.white,
      'iconColor': AppColors.mawsemTeal,
      'detailedPerks': [
        LevelPerk(title: '15% off concierge services'),
        LevelPerk(title: 'Priority customer support'),
        LevelPerk(title: 'Exclusive Wave Rider offers'),
      ],
      'reward': 'Premium Wave Rider Badge',
    },
    {
      'number': 4,
      'name': 'Coastal Regular',
      'stars': 80,
      'icon': Icons.home_outlined,
      'perks': 'Welcome basket + 200 EGP credit',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': Color(0xFFBC9B43),
      'detailedPerks': [
        LevelPerk(title: 'Complimentary welcome basket'),
        LevelPerk(title: '200 EGP credit on next booking'),
        LevelPerk(title: 'Free early access to new units'),
      ],
      'reward': 'Gift: Local Artisan Soap Set',
    },
    {
      'number': 5,
      'name': 'Sand VIP',
      'stars': 140,
      'icon': Icons.star_border,
      'perks': 'Free cleaning + airport pickup',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': Color(0xFF6B4D8A),
      'detailedPerks': [
        LevelPerk(title: 'Free Professional Cleaning', subtitle: 'Once per stay'),
        LevelPerk(title: 'Early access (48h)', subtitle: 'For all season promos'),
        LevelPerk(title: 'Everything from Coastal Regular'),
      ],
      'reward': 'Free Airport Pickup (Cairo to compound)',
    },
    {
      'number': 6,
      'name': 'Elite Coaster',
      'stars': 220,
      'icon': Icons.landscape_outlined,
      'perks': 'Free concierge + 3 cancel tokens',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': Color(0xFFBC9B43),
      'detailedPerks': [
        LevelPerk(title: 'Free Concierge Service', subtitle: 'Unlimited bookings'),
        LevelPerk(title: '3 Cancellation tokens', subtitle: 'No penalties apply'),
        LevelPerk(title: 'Dedicated Account Manager'),
      ],
      'reward': 'Gift: Luxury Beach Towel Set',
    },
    {
      'number': 7,
      'name': 'Sahely Ambassador',
      'stars': 500,
      'icon': Icons.workspace_premium, 
      'perks': 'Free weekend + season party invite',
      'bgColor': AppColors.mawsemBg,
      'textColor': Colors.white,
      'iconColor': AppColors.navy,
      'perksColor': AppColors.gold,
      'iconBgColor': AppColors.gold,
      'hasGoldBorder': true,
      'detailedPerks': [
        LevelPerk(title: 'Free Weekend Stay', subtitle: 'Any unit of your choice'),
        LevelPerk(title: 'Season Party Invite', subtitle: 'VIP access for two'),
        LevelPerk(title: 'Ambassador Level Support', subtitle: 'Instant 24/7 help'),
      ],
      'reward': 'Ambassador Membership Card',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'The 7 Levels',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'Cairo',
              ),
            ),
            Text(
              'climb the levels for perks',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Levels List
        ..._levels.map((level) {
          final isCurrent = level['number'] == currentLevel;
          final isUnlocked = currentStars >= level['stars'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MawsemLevelTile(
              number: level['number'],
              name: level['name'],
              stars: level['stars'],
              icon: level['icon'],
              perks: level['perks'],
              bgColor: level['bgColor'],
              textColor: level['textColor'],
              iconColor: level['iconColor'],
              iconBgColor: level['iconBgColor'],
              perksColor: level['perksColor'],
              isCurrent: isCurrent,
              isUnlocked: isUnlocked,
              hasGoldBorder: level['hasGoldBorder'] ?? false,
              onTap: () => _showLevelDetail(context, level),
            ),
          );
        }).toList(),
      ],
    );
  }
}
