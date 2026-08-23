import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/data/sample_data.dart';

import '../../../../../../core/utils/currency_formatter.dart';

class ReferredPropertyDetailPage extends StatelessWidget {
  const ReferredPropertyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CreamBackground(
        child: ListView(padding: EdgeInsets.zero, children: [
          Stack(children: [
            SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(Sample.azure.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const ColoredBox(color: AppColors.cardWarm))),
            Positioned(
                top: 44,
                left: 16,
                child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.chevron_left,
                            color: AppColors.navy)))),
            const Positioned(
                top: 50,
                right: 16,
                child: StatusBadge('Live', kind: BadgeKind.green, dot: true)),
            Positioned(
                left: 18,
                bottom: 14,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Azure Beach Villa',
                          style: AppTheme.dm(
                              size: 20,
                              weight: FontWeight.w700,
                              color: Colors.white)),
                      Text('Hacienda Bay · North Coast',
                          style: AppTheme.dm(size: 12, color: Colors.white70)),
                    ])),
          ]),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Wrap(spacing: 7, runSpacing: 7, children: [
                      Pill('Villa', border: AppColors.navy),
                      Pill('320 m²', border: AppColors.navy),
                      Pill('6 Guests', border: AppColors.navy),
                      Pill('Pool', border: AppColors.navy)
                    ]),
                    const SizedBox(height: 16),
                    Text('Owner',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 8),
                    WhiteCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(children: [
                          const AvatarCircle(
                              size: 44,
                              colors: [Color(0xFFC9A84C), Color(0xFF8A7330)]),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('Layla Mansour',
                                    style: AppTheme.dm(
                                        size: 14,
                                        weight: FontWeight.w700,
                                        color: AppColors.navy)),
                                Text('Established Host · joined 2023',
                                    style: AppTheme.dm(
                                        size: 12, color: AppColors.muted)),
                              ])),
                        ])),
                    const SizedBox(height: 16),
                    Text('Availability',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 8),
                    const AvailabilityCalendar(
                        blocked: [4, 5, 6],
                        ongoing: [14, 15, 16, 17, 18],
                        upcoming: [21, 22, 23, 24, 25]),
                    const SizedBox(height: 16),
                    Text('Your earnings from this property',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 8),
                    WhiteCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(children: [
                          const KeyValueRow('Your commission rate', '4%'),
                          const KeyValueRow('Bookings (season)', '24'),
                          const KeyValueRow('Nights rented', '96'),
                          KeyValueRow('Commission earned', CurrencyFormatter.format(41200),
                              valueColor: AppColors.success),
                          KeyValueRow('Pending commission', CurrencyFormatter.format(2400),
                              valueColor: const Color(0xFFD2760A)),
                        ])),
                    const SizedBox(height: 16),
                    Text('Listing performance',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 8),
                    const StatRow(cards: [
                      StatCard(value: '★ 4.8', label: '124 reviews'),
                      StatCard(value: '88%', label: 'Occupancy'),
                      StatCard(value: '1.2k', label: 'Views/wk')
                    ]),
                    const SizedBox(height: 16),
                    NavyButton(
                        label: 'View public listing',
                        radius: 14,
                        onTap: () => AppNavigation.goToPropertyDetail(context,
                            extra: Sample.azure)),
                  ])),
        ]),
      ),
    );
  }
}
