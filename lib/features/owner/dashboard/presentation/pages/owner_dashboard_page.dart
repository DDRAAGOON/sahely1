import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/buttons/sahely_button.dart';
import '../../../../shared/widgets/inputs/sahely_text_field.dart';
import '../../../../shared/properties/widgets/property_card.dart';
import '../../../../shared/properties/domain/entities/property.dart';
import '../../../../shared/widgets/cards/sahely_card.dart';

class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
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
                  _buildStatsOverview(),
                  const SizedBox(height: 24),
                  _buildActionCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Pending Requests', () {}),
                  const SizedBox(height: 12),
                  _buildPendingRequestPlaceholder(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Your Properties', () {}),
                  const SizedBox(height: 16),
                  PropertyCard(
                    property: const Property(
                      id: '1',
                      name: 'Lagoon Retreat',
                      area: 'Marassi',
                      imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
                      pricePerNight: 6200,
                      rating: 4.9,
                      reviewCount: 86,
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 100),
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
          'Owner Dashboard',
          style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.navy),
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Row(
      children: [
        Expanded(child: _buildStatBox('Properties', '3', AppColors.navy)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatBox('Earnings', '68k', AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatBox('Bookings', '7', AppColors.gold)),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return SahelyCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Text(value, style: AppTheme.dm(size: 20, weight: FontWeight.w800, color: color)),
          const SizedBox(height: 4),
          Text(label, style: AppTheme.dm(size: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.add_home_work, color: AppColors.navy, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('List a new property', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                Text('Reach more verified guests', style: AppTheme.dm(size: 11, color: AppColors.navy.withOpacity(0.6))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.navy),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        TextButton(
          onPressed: onSeeAll,
          child: Text('View All', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.gold)),
        ),
      ],
    );
  }

  Widget _buildPendingRequestPlaceholder() {
    return SahelyCard(
      child: Row(
        children: [
          const Icon(Icons.pending_actions, color: AppColors.gold),
          const SizedBox(width: 12),
          Text('You have 2 pending booking requests', style: AppTheme.dm(size: 14, weight: FontWeight.w600)),
        ],
      ),
    );
  }
}
