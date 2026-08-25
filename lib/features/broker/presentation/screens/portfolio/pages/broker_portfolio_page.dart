import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/price.dart';
import 'package:sahely/core/widgets/ratings.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/core/widgets/image.dart';

class BrokerPortfolioPage extends StatefulWidget {
  const BrokerPortfolioPage({super.key});

  @override
  State<BrokerPortfolioPage> createState() => _BrokerPortfolioPageState();
}

class _BrokerPortfolioPageState extends State<BrokerPortfolioPage> {
  int _selectedTab = 0; // 0: All, 1: Active, 2: Not listed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            TopBar(
              title: 'Referred Properties',
              subtitle: '51 accepted · guest-ready',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            Text(
                'Only properties accepted by Sahely and live for guests appear here — with the details renters see.',
                style: AppTheme.dm(size: 12, color: AppColors.muted)),
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChipPill(
                    'All 55',
                    selected: _selectedTab == 0,
                    height: 38,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChipPill(
                    'Active 51',
                    selected: _selectedTab == 1,
                    height: 38,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChipPill(
                    'Not listed 4',
                    selected: _selectedTab == 2,
                    height: 38,
                    onTap: () => setState(() => _selectedTab = 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Filtered Content
            if (_selectedTab == 0 || _selectedTab == 1) ...[
              _refCard(
                  context,
                  Sample.azure.image,
                  'Azure Beach Villa',
                  'Hacienda Bay',
                  4.8,
                  124,
                  4500,
                  const ['Villa', '6 Guests', 'Pool', '🐾 Pets OK']),
              const SizedBox(height: 16),
              _refCard(context, Sample.lagoon.image, 'Lagoon Retreat', 'Marassi',
                  4.9, 86, 6200, const ['Chalet', '8 Guests', 'Sea view']),
              const SizedBox(height: 16),
              _refCard(context, Sample.dunes.image, 'Golden Dunes', 'Marassi', 4.7,
                  53, 3800, const ['Villa', '4 Guests', 'Beach']),
            ],
            
            if (_selectedTab == 2) ...[
              _refCard(
                  context,
                  'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
                  'Sunset Loft',
                  'Amwaj',
                  0.0,
                  0,
                  2900,
                  const ['Apartment', 'Review Pending'],
                  isLive: false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _refCard(BuildContext context, String img, String name, String area,
          double rating, int reviews, int price, List<String> tags,
          {bool isLive = true}) =>
      GestureDetector(
        onTap: () => AppNavigation.goToBrokerReferredDetail(context),
        behavior: HitTestBehavior.opaque,
        child: WhiteCard(
          padding: EdgeInsets.zero,
          radius: 18,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Stack(fit: StackFit.expand, children: [
                    AppNetworkImage(url: img, errorWidget: (_, __, ___) =>
                            const ColoredBox(color: AppColors.cardWarm)),
                    DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6)
                        ]))),
                    Positioned(
                        top: 12,
                        right: 12,
                        child: StatusBadge(
                            isLive ? 'Accepted · Live' : 'Review Pending',
                            kind: isLive ? BadgeKind.green : BadgeKind.orange,
                            dot: isLive)),
                    Positioned(
                        left: 14,
                        bottom: 12,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: AppTheme.dm(
                                      size: 16,
                                      weight: FontWeight.w700,
                                      color: Colors.white)),
                              Text(area,
                                  style: AppTheme.dm(
                                      size: 11, color: Colors.white70)),
                            ])),
                  ])),
              Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: RatingRow(
                                    rating: rating, reviews: reviews),
                              ),
                              const SizedBox(width: 8),
                              PriceTag(price: price)
                            ]),
                        const SizedBox(height: 12),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          for (final t in tags)
                            Pill(t,
                                border: AppColors.border, fg: AppColors.muted)
                        ]),
                      ])),
            ]),
          ),
        ),
      );
}

