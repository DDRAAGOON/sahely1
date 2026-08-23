import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/past_booking_hero_image.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import '../../../core/navigation/app_navigation.dart';

enum PastBookingRole { renter, owner, broker }

class PastBookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? bookingData;
  final Property? property;
  final PastBookingRole role;

  const PastBookingDetailScreen({
    super.key,
    this.bookingData,
    this.property,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    if (role == PastBookingRole.owner || role == PastBookingRole.broker) {
      return _buildBusinessView(context);
    }
    return _buildRenterView(context);
  }

  Widget _buildBusinessView(BuildContext context) {
    final name = property?.name ?? bookingData?['propertyName'] ?? 'Property';
    final loc = property?.area ?? bookingData?['location'] ?? 'Location';
    final img = property?.image ?? bookingData?['imageUrl'] ?? '';
    final guestName = bookingData?['guestName'] ?? 'Mariam Hassan';
    final amount = bookingData?['total'] ?? '5,400';

    return PhoneScaffold(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                TopBar(title: role == PastBookingRole.owner ? 'Booking History' : 'Past Referral'),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => AppNavigation.goToPropertyDetail(context, extra: {
                    'name': name,
                    'location': loc,
                    'imageUrl': img,
                  }),
                  child: WhiteCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(img, width: 64, height: 64, fit: BoxFit.cover,
                          errorBuilder: (_,__,___) => Container(width: 64, height: 64, color: AppColors.cardWarm)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
                          Text(loc, style: AppTheme.dm(size: 13, color: AppColors.muted)),
                        ],
                      )),
                      const Icon(Icons.chevron_right, size: 18, color: AppColors.faint),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Guest Summary', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 12),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(children: [
                      const AvatarCircle(size: 40, colors: [AppColors.gold, AppColors.goldBright]),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(guestName, style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                          Text('Stayed · May 12 - May 16', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                        ],
                      )),
                    ]),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(child: _stat('Payout', 'EGP $amount')),
                      const SizedBox(width: 12),
                      Expanded(child: _stat('Rating', '5.0 ★')),
                    ]),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String l, String v) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(10)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l, style: AppTheme.dm(size: 10, color: AppColors.muted)),
      Text(v, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
    ]),
  );

  Widget _buildRenterView(BuildContext context) {
    final booking = bookingData ?? {};
    final String propertyName = (booking['propertyName'] ?? 'Property').toString();
    final String location = (booking['location'] ?? 'Location').toString();
    final String imageUrl = (booking['imageUrl'] ?? '').toString();
    final int total = (booking['total'] is num) ? (booking['total'] as num).toInt() : 0;
    final List<String> photos = (booking['photos'] is List)
        ? (booking['photos'] as List).map((e) => e.toString()).toList() : [];
    final List<String> included = (booking['included'] is List)
        ? (booking['included'] as List).map((e) => e.toString()).toList() : ['Pool', 'Wi-Fi', 'Beach'];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PastBookingHeroImage(
              imageUrl: imageUrl,
              propertyName: propertyName,
              location: location,
              allPhotos: photos,
              onBackTap: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Included in your stay', style: AppTheme.dm(size: 18, weight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: included.map((a) => _includedPill(a)).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total Paid', style: AppTheme.dm(size: 16, weight: FontWeight.w600)),
                    Text('EGP $total', style: AppTheme.dm(size: 18, weight: FontWeight.w800, color: AppColors.navy)),
                  ]),
                  const SizedBox(height: 32),
                  NavyButton(label: 'Rebook Property', onTap: () {}),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _includedPill(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.borderDefault),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(label, style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.navy)),
  );
}
