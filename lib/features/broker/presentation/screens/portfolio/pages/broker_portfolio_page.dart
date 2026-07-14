import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../data/sample_data.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/chips.dart';
import '../../../../../../core/widgets/common.dart';
import '../../../../../../core/widgets/kit.dart';

class BrokerPortfolioPage extends StatelessWidget {
  const BrokerPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
        children: [
          const TopBar(title: 'Referred Properties', subtitle: '51 accepted & live · guest-ready'),
          const SizedBox(height: 12),
          Text('Only properties accepted by Sahely and live for guests appear here — with the details renters see.', style: AppTheme.dm(size: 12, color: AppColors.muted)),
          const SizedBox(height: 12),
          SizedBox(height: 32, child: ListView(scrollDirection: Axis.horizontal, children: const [
            ChoiceChipPill('All 55', selected: true, height: 32), SizedBox(width: 8),
            ChoiceChipPill('Active 51', height: 32), SizedBox(width: 8),
            ChoiceChipPill('Not listed 4', height: 32),
          ])),
          const SizedBox(height: 14),
          _refCard(context, Sample.azure.image, 'Azure Beach Villa', 'Hacienda Bay', 4.8, 124, 4500, const ['Villa', '6 Guests', 'Pool', '🐾 Pets']),
          const SizedBox(height: 12),
          _refCard(context, Sample.lagoon.image, 'Lagoon Retreat', 'Marassi', 4.9, 86, 6200, const ['Chalet', '8 Guests', 'Sea view']),
          const SizedBox(height: 12),
          _refCard(context, Sample.dunes.image, 'Golden Dunes', 'Marassi', 4.7, 53, 3800, const ['Villa', '4 Guests', 'Beach']),
        ],
      ),
    );
  }

  Widget _refCard(BuildContext context, String img, String name, String area, double rating, int reviews, int price, List<String> tags) => GestureDetector(
        onTap: () => context.push('/broker/referred-detail'),
        behavior: HitTestBehavior.opaque,
        child: WhiteCard(
          padding: EdgeInsets.zero,
          radius: 18,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 140, width: double.infinity, child: Stack(fit: StackFit.expand, children: [
                Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.cardWarm)),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0x991B2744)]))),
                const Positioned(top: 10, right: 10, child: StatusBadge('Accepted · Live', kind: BadgeKind.green, dot: true)),
                Positioned(left: 14, bottom: 12, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: Colors.white)),
                  Text(area, style: AppTheme.dm(size: 11, color: Colors.white70)),
                ])),
              ])),
              Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [RatingRow(rating: rating, reviews: reviews), PriceTag(price: price)]),
                const SizedBox(height: 10),
                Wrap(spacing: 7, runSpacing: 7, children: [for (final t in tags) Pill(t, border: AppColors.border, fg: AppColors.subtle)]),
              ])),
            ]),
          ),
        ),
      );
}
