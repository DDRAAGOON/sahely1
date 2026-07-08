import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/buttons/sahely_button.dart';
import '../../../../shared/properties/widgets/property_card.dart';
import '../../../../shared/properties/domain/entities/property.dart';

class BrokerDashboardPage extends StatefulWidget {
  const BrokerDashboardPage({super.key});

  @override
  State<BrokerDashboardPage> createState() => _BrokerDashboardPageState();
}

class _BrokerDashboardPageState extends State<BrokerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        color: AppColors.gold,
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildStatsCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Trending Properties', () {}),
                  const SizedBox(height: 16),
                  // Example using Shared PropertyCard
                  PropertyCard(
                    property: const Property(
                      id: '1',
                      name: 'Azure Beach Villa',
                      area: 'Hacienda Bay',
                      imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
                      pricePerNight: 4500,
                      rating: 4.8,
                      reviewCount: 124,
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 100), // Bottom nav space
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.cream,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        title: Text(
          'Broker Dashboard',
          style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Monthly Earnings', 'EGP 18.2k', AppColors.gold),
              _buildStatItem('Active Referrals', '51', Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          SahelyButton(
            label: 'Refer New Property',
            variant: ButtonVariant.gold,
            height: 46,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.dm(size: 12, color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.dm(size: 20, weight: FontWeight.w800, color: valueColor)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        TextButton(
          onPressed: onSeeAll,
          child: Text('See All', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.gold)),
        ),
      ],
    );
  }
}
