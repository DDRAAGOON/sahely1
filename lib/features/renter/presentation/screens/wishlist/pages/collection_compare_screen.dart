import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/property_comparison_bar.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

class CollectionCompareScreen extends StatelessWidget {
  final String collectionName;
  final List<String> participantNames;

  const CollectionCompareScreen({
    super.key,
    required this.collectionName,
    required this.participantNames,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Share Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Compare',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.gold, fontFamily: 'DM Sans'),
                        ),
                        Text(
                          collectionName,
                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6), fontFamily: 'DM Sans'),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => AppNavigation.goToShareCollection(
                      context,
                      collectionName: 'Comparison',
                      shareableLink: 'sahely.app/compare/azure-vs-dunes',
                    ),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.link, size: 14, color: AppColors.navy),
                          SizedBox(width: 4),
                          Text('Share', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Content Table
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // VS Bar
                    const PropertyComparisonBar(
                      property1: PropertyCompareData(
                        name: 'Azure Villa',
                        rating: 4.8,
                        price: 4500,
                        imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=400',
                      ),
                      property2: PropertyCompareData(
                        name: 'Lagoon Retreat',
                        rating: 4.9,
                        price: 6200,
                        imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Comparison Data
                    WhiteCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      radius: 20,
                      child: Column(
                        children: [
                          _row('Location', 'Marassi · N.Coast', 'Hacienda Bay', 0),
                          _divider(),
                          _row('Type', 'Villa', 'Chalet', -1),
                          _divider(),
                          _row('Rating', '★ 4.8', '★ 4.7', 0),
                          _divider(),
                          _row('Bedrooms', '4 bdr · 6 beds', '3 bdr · 5 beds', 0),
                          _divider(),
                          _row('Bathrooms', '3', '2', -1),
                          _divider(),
                          _row('View', 'Sea view', 'Dune view', 0),
                          _divider(),
                          _row('Beach', 'Marina Beach', 'Lagoon Beach', -1),
                          _divider(),
                          _row('Pool', '✓', '×', 0, check: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(child: WideButton(label: 'Book Azure', color: AppColors.navy, height: 48, radius: 14)),
                        SizedBox(width: 12),
                        Expanded(child: WideButton(label: 'Book Lagoon', color: AppColors.gold, textColor: AppColors.navy, height: 48, radius: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String a, String b, int win, {bool check = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: AppTheme.dm(size: 13, color: AppColors.textSecondary))),
          Expanded(flex: 2, child: Center(child: _val(a, win == 0, check))),
          Expanded(flex: 2, child: Center(child: _val(b, win == -1, check))),
        ],
      ),
    );
  }

  Widget _val(String v, bool winner, bool check) {
    if (check) {
      return Text(v, style: AppTheme.dm(size: 15, weight: FontWeight.w800, color: v == '✓' ? AppColors.success : AppColors.border));
    }
    return Text(v, style: AppTheme.dm(size: 13, weight: winner ? FontWeight.w700 : FontWeight.w400, color: winner ? AppColors.gold : AppColors.navy));
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFF0EBE2));
}
