import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/about_place_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/ask_sahely_ai_banner.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/booking_hero_image.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/booking_photo_gallery.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/cancel_booking_button.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/check_in_banner.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/location_map_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/price_breakdown_card.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/reservation_details_card.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/whats_included_section.dart';

/// Enum for the user role to customize the upcoming booking detail screen.
enum UpcomingBookingRole { renter, owner }

/// Unified Upcoming Booking Detail Screen shared across Renter and Owner roles.
class UpcomingBookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? bookingData;
  final Property? property;
  final UpcomingBookingRole role;

  const UpcomingBookingDetailScreen({
    super.key,
    this.bookingData,
    this.property,
    this.role = UpcomingBookingRole.renter,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = role == UpcomingBookingRole.owner;
    final prop = property ?? Sample.azure;

    if (isOwner) {
      return _buildOwnerView(context, prop);
    }
    return _buildRenterView(context);
  }

  /// Owner view using original OwnerUpcomingDetailScreen structure
  Widget _buildOwnerView(BuildContext context, Property prop) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                // 1. Hero Image
                SizedBox(
                  height: 280,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SahelyImage(
                          imageUrl: prop.image,
                          enableViewer: true,
                          fadeHeight: 120,
                          fadeColor: AppColors.cream),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x991B2744)],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prop.name,
                                style: AppTheme.dm(
                                    size: 26,
                                    weight: FontWeight.w700,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 14, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text('${prop.area} · North Coast',
                                  style: AppTheme.dm(
                                      size: 13, color: Colors.white70)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Image Grid
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(prop.image,
                                  height: 160, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(Sample.lagoon.image,
                                      height: 76,
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                                ),
                                const SizedBox(height: 8),
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(Sample.dunes.image,
                                          height: 76,
                                          width: double.infinity,
                                          fit: BoxFit.cover),
                                    ),
                                    Container(
                                      height: 76,
                                      decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      alignment: Alignment.center,
                                      child: const Text('+12',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // 3. About
                      Text('About this place',
                          style: AppTheme.dm(
                              size: 20,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 14),
                      Text(
                        'Beachfront villa with a private pool, panoramic sea views and direct beach access. Sleeps 6 across 4 bedrooms over 2 floors.',
                        style: AppTheme.dm(
                            size: 15, color: AppColors.ink, height: 1.55),
                      ),
                      const SizedBox(height: 20),
                      Wrap(spacing: 8, runSpacing: 10, children: [
                        _featurePill('Villa'),
                        _featurePill('320 m²'),
                        _featurePill('4 Beds'),
                        _featurePill('3 Baths'),
                        _featurePill('6 Guests'),
                        _featurePill('2 Floors'),
                        _featurePill('Sea view'),
                      ]),
                      const SizedBox(height: 32),

                      // 4. Location
                      Text('Location',
                          style: AppTheme.dm(
                              size: 19,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 14),
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC5D5E2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.location_on,
                                color: Color(0xFFB22222), size: 40),
                            Positioned(
                              bottom: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                    color:
                                        AppColors.navy.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                    '${prop.area}, Marassi · North Coast',
                                    style: AppTheme.dm(
                                        size: 12,
                                        weight: FontWeight.w600,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFDF9F4),
                            border: Border.all(color: const Color(0xFFEAD9A8)),
                            borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          const Icon(Icons.schedule,
                              size: 15, color: Color(0xFF8A6A1E)),
                          const SizedBox(width: 5),
                          Expanded(
                              child: Text(
                                  'Check-in in 4 days · passcode unlocks within 2 km',
                                  style: AppTheme.dm(
                                      size: 10,
                                      weight: FontWeight.w600,
                                      color: const Color(0xFF8A6A1E)))),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // 5. Reservation
                      Text('Reservation',
                          style: AppTheme.dm(
                              size: 19,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 14),
                      const WhiteCard(
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        child: Column(children: [
                          KeyValueRow('Order no.', 'SHLY-8842'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Check-in', 'Jun 21 · 3:00 PM'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Check-out', 'Jun 25 · 11:00 AM'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Guests', '2 adults'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Nights', '4'),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // 6. What's included
                      Text("What's included",
                          style: AppTheme.dm(
                              size: 19,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 14),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        _includedPill('Pool'),
                        _includedPill('WiFi'),
                        _includedPill('Beach'),
                        _includedPill('Smart Lock'),
                        const Pill('🐾 Pets OK',
                            bg: Color(0xFFD7EEDD),
                            fg: AppColors.success,
                            radius: 10),
                      ]),
                      const SizedBox(height: 32),

                      // 7. Price
                      Text('Price',
                          style: AppTheme.dm(
                              size: 19,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 14),
                      const WhiteCard(
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        child: Column(children: [
                          KeyValueRow('EGP 4,500 × 4', '18,000'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Cleaning + VAT', '3,090'),
                          Divider(height: 1, color: AppColors.border),
                          KeyValueRow('Total paid', 'EGP 21,090', bold: true),
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // 8. AI Banner
                      GestureDetector(
                        onTap: () => AppNavigation.goToAiChat(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: const Color(0xFF1B2744),
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(children: [
                            Container(
                                width: 46,
                                height: 46,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFD8B96A),
                                    borderRadius: BorderRadius.circular(14)),
                                child: const Icon(Icons.auto_awesome,
                                    size: 24, color: Color(0xFF1B2744))),
                            const SizedBox(width: 14),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text('Ask Sahely AI',
                                      style: AppTheme.dm(
                                          size: 15,
                                          weight: FontWeight.w700,
                                          color: Colors.white)),
                                  const SizedBox(height: 2),
                                  Text(
                                      'Questions about this stay — directions, parking, check-in',
                                      style: AppTheme.dm(
                                          size: 11,
                                          color: const Color(0xFFD8B96A))),
                                ])),
                            const Icon(Icons.chat_bubble_outline,
                                color: Color(0xFFD8B96A), size: 22),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      WideButton(
                        label: 'Cancel booking',
                        color: const Color(0xFFB22222),
                        textColor: const Color(0xFFB22222),
                        outline: true,
                        height: 56,
                        radius: 16,
                        onTap: () => _showCancelDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Floating Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4)
                              ]),
                          child: const Icon(Icons.chevron_left,
                              color: AppColors.navy, size: 28),
                        ),
                      ),
                      const StatusBadge('Upcoming', kind: BadgeKind.navy),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Renter view using original UpcomingBookingDetailScreen structure
  Widget _buildRenterView(BuildContext context) {
    final booking = bookingData ?? {};
    final String propertyName =
        (booking['propertyName'] ?? 'Property').toString();
    final String location = (booking['location'] ?? 'Location').toString();
    final String imageUrl = (booking['imageUrl'] ?? '').toString();
    final String orderNumber = (booking['orderNumber'] ?? '').toString();
    final String guests = (booking['guests'] ?? '1 Guest').toString();
    final String description =
        (booking['description'] ?? 'No description available.').toString();
    final int nights =
        (booking['nights'] is num) ? (booking['nights'] as num).toInt() : 1;
    final int daysUntilCheckIn = (booking['daysUntilCheckIn'] is num)
        ? (booking['daysUntilCheckIn'] as num).toInt()
        : 4;
    final int pricePerNight = (booking['pricePerNight'] is num)
        ? (booking['pricePerNight'] as num).toInt()
        : 0;
    final int cleaningVat = (booking['cleaningVat'] is num)
        ? (booking['cleaningVat'] as num).toInt()
        : 0;
    final int total =
        (booking['total'] is num) ? (booking['total'] as num).toInt() : 0;
    final List<String> photos = (booking['photos'] is List)
        ? (booking['photos'] as List).map((e) => e.toString()).toList()
        : [];
    final List<String> amenities = (booking['amenities'] is List)
        ? (booking['amenities'] as List).map((e) => e.toString()).toList()
        : [];
    final List<String> included = (booking['included'] is List)
        ? (booking['included'] as List).map((e) => e.toString()).toList()
        : [];

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
                  Text(propertyName,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontFamily: 'DM Sans')),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(location,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.secondary,
                            fontFamily: 'DM Sans')),
                  ]),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BookingPhotoGallery(photos: photos),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AboutPlaceSection(
                  description: description, amenities: amenities),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: LocationMapSection(location: location),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CheckInBanner(daysUntilCheckIn: daysUntilCheckIn),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reservation',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontFamily: 'DM Sans')),
                  const SizedBox(height: 12),
                  ReservationDetailsCard(
                    orderNumber: orderNumber,
                    checkIn: _formatDate(booking['checkIn']),
                    checkOut: _formatDate(booking['checkOut']),
                    guests: guests,
                    nights: nights,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WhatsIncludedSection(included: included),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontFamily: 'DM Sans')),
                  const SizedBox(height: 12),
                  PriceBreakdownCard(
                    pricePerNight: pricePerNight,
                    nights: nights,
                    cleaningVat: cleaningVat,
                    total: total,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AskSahelyAiBanner(
                onTap: () {
                  AppNavigation.goToAiChat(context);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child:
                  CancelBookingButton(onTap: () => _showCancelDialog(context)),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    try {
      DateTime? parsed;
      if (date is DateTime) {
        parsed = date;
      } else if (date is String) {
        parsed = DateTime.tryParse(date);
      }
      if (parsed != null) {
        return DateFormat('MMM d · h:mm a').format(parsed);
      }
    } catch (e) {
      debugPrint('Error formatting date: $e');
    }
    return date?.toString() ?? 'N/A';
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Booking',
            style: AppTheme.dm(
                size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        content: Text('Are you sure you want to cancel this booking?',
            style: AppTheme.dm(size: 14, color: AppColors.muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep',
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w600, color: AppColors.muted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB22222)),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _featurePill(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
                color: const Color(0xFF22335A).withValues(alpha: .8),
                width: 1.1),
            borderRadius: BorderRadius.circular(10)),
        child: Text(label,
            style: AppTheme.dm(
                size: 10,
                weight: FontWeight.w600,
                color: const Color(0xFF22335A))),
      );

  Widget _includedPill(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
                color: const Color(0xFF22335A).withValues(alpha: .8),
                width: 1.1),
            borderRadius: BorderRadius.circular(10)),
        child: Text(label,
            style: AppTheme.dm(
                size: 10, weight: FontWeight.w600, color: AppColors.navy)),
      );
}
