import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/chips.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/price.dart';
import 'package:sahely/core/widgets/ratings.dart';
import 'package:sahely/data/sample_data.dart';

class BrokerPortfolioPage extends StatelessWidget {
  const BrokerPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      child: Scaffold(
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
                    ChoiceChipPill('All 55', selected: true, height: 38, onTap: () {}),
                    const SizedBox(width: 8),
                    ChoiceChipPill('Active 51', height: 38, onTap: () {}),
                    const SizedBox(width: 8),
                    ChoiceChipPill('Not listed 4', height: 38, onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
          ),
        ),
      ),
    );
  }

  Widget _refCard(BuildContext context, String img, String name, String area,
          double rating, int reviews, int price, List<String> tags) =>
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
                    Image.network(img,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const ColoredBox(color: AppColors.cardWarm)),
                    const DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                          Colors.transparent,
                          Color(0x991B2744)
                        ]))),
                    const Positioned(
                        top: 12,
                        right: 12,
                        child: StatusBadge('Accepted · Live',
                            kind: BadgeKind.green, dot: true)),
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
