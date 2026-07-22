import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

import 'package:sahely/features/shared/widgets/mawsem/level/level_detail_sheet.dart';
import 'package:sahely/features/shared/widgets/mawsem/level/level_perk.dart';
import 'package:sahely/features/shared/widgets/mawsem/mawsem_level_tile.dart';

class BrokerMawsemLevelsList extends StatelessWidget {
  final int currentLevel;
  final int currentStars;

  const BrokerMawsemLevelsList({
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

  static const List<Map<String, dynamic>> _levels = [
    {
      'number': 1,
      'name': 'Beach Walker',
      'stars': 0,
      'icon': Icons.person_outline,
      'perks': '2% commission & dashboard',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': Color(0xFF717171),
      'detailedPerks': [
        LevelPerk(title: '2% commission on all bookings'),
        LevelPerk(title: 'Standard Broker Dashboard'),
      ],
      'reward': 'Broker Starter Badge',
    },
    {
      'number': 2,
      'name': 'Shore Explorer',
      'stars': 15,
      'icon': Icons.waves,
      'perks': '2.5% commission + Priority WhatsApp',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': AppColors.mawsemTeal,
      'detailedPerks': [
        LevelPerk(title: '2.5% commission on all bookings'),
        LevelPerk(title: 'Priority WhatsApp Support'),
      ],
      'reward': 'Shore Explorer Badge',
    },
    {
      'number': 3,
      'name': 'Wave Rider',
      'stars': 40,
      'icon': Icons.waves,
      'perks': '3% commission + 1 free stay',
      'bgColor': AppColors.mawsemBg,
      'textColor': Colors.white,
      'iconColor': AppColors.mawsemTeal,
      'detailedPerks': [
        LevelPerk(title: '3% commission on all bookings'),
        LevelPerk(title: '1 Free Stay per season', subtitle: 'Off-peak units'),
        LevelPerk(title: 'Exclusive Broker Offers'),
      ],
      'reward': 'Premium Wave Rider Badge',
    },
    {
      'number': 4,
      'name': 'Coastal Regular',
      'stars': 80,
      'icon': Icons.home_outlined,
      'perks': '3.5% commission + Season Beach Pass',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': Color(0xFFBC9B43),
      'detailedPerks': [
        LevelPerk(title: '3.5% commission on all bookings'),
        LevelPerk(title: 'Season Beach Pass for 2'),
        LevelPerk(title: 'Branded Business Cards'),
      ],
      'reward': 'Gift: Broker Welcome Kit',
    },
    {
      'number': 5,
      'name': 'Sand VIP',
      'stars': 140,
      'icon': Icons.star_border,
      'perks': '4% commission + 2 free stays',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': Color(0xFF6B4D8A),
      'detailedPerks': [
        LevelPerk(title: '4% commission on all bookings'),
        LevelPerk(title: '2 Free Stays per season'),
        LevelPerk(title: 'Dedicated Account Manager'),
      ],
      'reward': 'VIP Broker Membership',
    },
    {
      'number': 6,
      'name': 'Elite Coaster',
      'stars': 220,
      'icon': Icons.landscape_outlined,
      'perks': '4.5% commission + Founder Dinner',
      'bgColor': Colors.white,
      'textColor': AppColors.navy,
      'iconColor': Color(0xFFBC9B43),
      'detailedPerks': [
        LevelPerk(title: '4.5% commission on all bookings'),
        LevelPerk(title: 'Founder Dinner Invite'),
        LevelPerk(title: 'Early access to new compounds'),
      ],
      'reward': 'Gift: Luxury Office Set',
    },
    {
      'number': 7,
      'name': 'Sahely Ambassador',
      'stars': 500,
      'icon': Icons.workspace_premium,
      'perks': '5% commission + Advisory Seat',
      'bgColor': AppColors.mawsemBg,
      'textColor': Colors.white,
      'iconColor': AppColors.navy,
      'perksColor': AppColors.gold,
      'iconBgColor': AppColors.gold,
      'hasGoldBorder': true,
      'detailedPerks': [
        LevelPerk(title: '5% commission on all bookings'),
        LevelPerk(title: 'Advisory Board Seat'),
        LevelPerk(title: 'Unlimited Free Weekend Stays'),
        LevelPerk(title: 'VIP Season Party Access'),
      ],
      'reward': 'Ambassador Platinum Card',
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
              'climb for higher commission',
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
        }),
      ],
    );
  }
}
