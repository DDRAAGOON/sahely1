import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/booking_hero_image.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/booking_details_card.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/lock_info_cards.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/ask_sahely_ai_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/arrival_checklist_section.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import '../../../core/navigation/app_navigation.dart';

enum UpcomingBookingRole { renter, owner, broker }

class UpcomingBookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? bookingData;
  final Property? property;
  final UpcomingBookingRole role;

  const UpcomingBookingDetailScreen({
    super.key,
    this.bookingData,
    this.property,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    if (role == UpcomingBookingRole.owner || role == UpcomingBookingRole.broker) {
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
                TopBar(title: role == UpcomingBookingRole.owner ? 'Booking Details' : 'Referral Detail'),
                const SizedBox(height: 20),
                
                // Property Info
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
                const SizedBox(height: 16),

                // Guest Info
                Text('Guest Information', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 12),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    const AvatarCircle(size: 40, colors: [AppColors.gold, AppColors.goldBright]),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(guestName, style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                        Text('Verified Renter · 5★', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                      ],
                    )),
                    const IconCircleButton(icon: Icons.chat_bubble_outline, size: 36, bg: AppColors.cream),
                  ]),
                ),
                const SizedBox(height: 24),

                // Booking Stats
                Row(children: [
                  Expanded(child: _stat('Check-in', 'Jun 19, 2:00 PM')),
                  const SizedBox(width: 12),
                  Expanded(child: _stat('Check-out', 'Jun 23, 11:00 AM')),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _stat('Guests', '2 Adults, 1 Child')),
                  const SizedBox(width: 12),
                  Expanded(child: _stat('Total Payout', 'EGP $amount')),
                ]),
                const SizedBox(height: 24),

                // Commission if Broker
                if (role == UpcomingBookingRole.broker) ...[
                  Text('Your Commission', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 12),
                  WhiteCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Text('4% Commission', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.muted)),
                      const Spacer(),
                      Text('EGP 216', style: AppTheme.dm(size: 16, weight: FontWeight.w800, color: AppColors.success)),
                    ]),
                  ),
                  const SizedBox(height: 24),
                ],

                // Actions
                if (role == UpcomingBookingRole.owner) ...[
                  NavyButton(label: 'Manage Door Access', onTap: () {}),
                  const SizedBox(height: 12),
                  NavyButton(label: 'View Checklist', outline: true, onTap: () {}),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String l, String v) => WhiteCard(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l, style: AppTheme.dm(size: 11, color: AppColors.muted)),
        const SizedBox(height: 4),
        Text(v, style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.navy)),
      ],
    ),
  );

  Widget _buildRenterView(BuildContext context) {
    final booking = bookingData ?? {};
    final String propertyName = (booking['propertyName'] ?? 'Property').toString();
    final String location = (booking['location'] ?? 'Location').toString();
    final String imageUrl = (booking['imageUrl'] ?? '').toString();
    final String guests = (booking['guests'] ?? '1 Guest').toString();
    final int total = (booking['total'] is num) ? (booking['total'] as num).toInt() : 0;
    final List<String> photos = (booking['photos'] is List)
        ? (booking['photos'] as List).map((e) => e.toString()).toList() : [];
    final List<String> amenities = (booking['amenities'] is List)
        ? (booking['amenities'] as List).map((e) => e.toString()).toList() : [];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BookingHeroImage(
              imageUrl: imageUrl,
              allPhotos: photos,
              onBackTap: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(propertyName, style: AppTheme.dm(size: 24, weight: FontWeight.w800, color: AppColors.navy)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Text(location, style: AppTheme.dm(size: 14, color: AppColors.muted)),
                  ]),
                  const SizedBox(height: 24),
                  BookingDetailsCard(
                    checkIn: DateTime.now().add(const Duration(days: 4)),
                    checkOut: DateTime.now().add(const Duration(days: 8)),
                    adults: int.tryParse(guests.split(' ').first) ?? 1,
                    unitInfo: 'Standard Unit',
                    bookingRef: 'SH-99281',
                    totalPaid: total,
                  ),
                  const SizedBox(height: 24),
                  LockInfoCards(
                    isInRange: true,
                    distance: 1.5,
                    checkOut: DateTime.now().add(const Duration(days: 8)),
                  ),
                  const SizedBox(height: 32),
                  const AskSahelyAiSection(),
                  const SizedBox(height: 32),
                  const ArrivalChecklistSection(),
                  const SizedBox(height: 32),
                  Text('Amenities', style: AppTheme.dm(size: 18, weight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: amenities.map((a) => _featurePill(a)).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total Payment', style: AppTheme.dm(size: 16, weight: FontWeight.w600)),
                    Text('EGP $total', style: AppTheme.dm(size: 18, weight: FontWeight.w800, color: AppColors.navy)),
                  ]),
                  const SizedBox(height: 40),
                  NavyButton(label: 'Cancel Booking', outline: true, onTap: () => _showCancelDialog(context)),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Booking', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        content: Text('Are you sure you want to cancel this booking?', style: AppTheme.dm(size: 14, color: AppColors.muted)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Yes, Cancel')),
        ],
      ),
    );
  }

  Widget _featurePill(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.borderDefault),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(label, style: AppTheme.dm(size: 12, weight: FontWeight.w600)),
  );
}
