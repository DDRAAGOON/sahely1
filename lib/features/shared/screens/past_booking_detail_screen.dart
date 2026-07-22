import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/screens/property_detail_screen.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/pages/write_review_screen.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/book_again_button.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/past_booking_hero_image.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/price_breakdown_card.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/reservation_details_card.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/review_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/whats_included_section.dart';

/// Enum for the user role to customize the past booking detail screen.
enum PastBookingRole { renter, owner }

/// Unified Past Booking Detail Screen shared across Renter and Owner roles.
class PastBookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? bookingData;
  final Property? property;
  final PastBookingRole role;

  const PastBookingDetailScreen({
    super.key,
    this.bookingData,
    this.property,
    this.role = PastBookingRole.renter,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = role == PastBookingRole.owner;
    final prop = property ?? Sample.dunes;

    if (isOwner) {
      return _buildOwnerView(context, prop);
    }
    return _buildRenterView(context);
  }

  /// Owner view using original OwnerPastDetailScreen structure
  Widget _buildOwnerView(BuildContext context, Property prop) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
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
                        fadeHeight: 0,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Color(0x441B2744),
                            ],
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
                              Text('Marassi · North Coast',
                                  style: AppTheme.dm(
                                      size: 13, color: Colors.white70)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.cream,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. Reservation
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
                            KeyValueRow('Order no.', 'SHLY-7120'),
                            Divider(height: 1, color: AppColors.border),
                            KeyValueRow('Check-in', 'May 18 · 3:00 PM'),
                            Divider(height: 1, color: AppColors.border),
                            KeyValueRow('Check-out', 'May 22 · 11:00 AM'),
                            Divider(height: 1, color: AppColors.border),
                            KeyValueRow('Guests', '2 adults'),
                            Divider(height: 1, color: AppColors.border),
                            KeyValueRow('Nights', '4'),
                          ]),
                        ),
                        const SizedBox(height: 32),

                        // 3. What was included
                        Text('What was included',
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

                        // 4. Price
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
                            KeyValueRow('EGP 3,800 × 4', '15,200'),
                            Divider(height: 1, color: AppColors.border),
                            KeyValueRow('Cleaning + VAT', '2,500'),
                            Divider(height: 1, color: AppColors.border),
                            KeyValueRow('Total paid', 'EGP 17,700', bold: true),
                          ]),
                        ),
                        const SizedBox(height: 32),

                        // 5. Rate Guest Card
                        WhiteCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('How was the guest?',
                                  style: AppTheme.dm(
                                      size: 15,
                                      weight: FontWeight.w700,
                                      color: AppColors.navy)),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var i = 0; i < 5; i++)
                                    const Icon(Icons.star,
                                        size: 36, color: Color(0xFFE0E0E0)),
                                ],
                              ),
                              const SizedBox(height: 18),
                              WideButton(
                                label: 'Rate guest · earn +5 ★',
                                icon: Icons.star,
                                color: AppColors.navy,
                                height: 52,
                                radius: 14,
                                onTap: () => AppNavigation.goToOwnerRateGuest(
                                    context,
                                    extra: prop),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        WideButton(
                          label: 'Book again',
                          color: AppColors.navy,
                          textColor: AppColors.navy,
                          outline: true,
                          height: 52,
                          radius: 14,
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Top Bar
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
                            ],
                          ),
                          child: const Icon(Icons.chevron_left,
                              color: AppColors.navy, size: 28),
                        ),
                      ),
                      const StatusBadge('Past', kind: BadgeKind.gray),
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

  /// Renter view using original PastBookingDetailScreen structure
  Widget _buildRenterView(BuildContext context) {
    final booking = bookingData ?? {};
    final String propertyName =
        (booking['propertyName'] ?? 'Property').toString();
    final String location = (booking['location'] ?? 'Location').toString();
    final String imageUrl = (booking['imageUrl'] ?? '').toString();
    final String orderNumber = (booking['orderNumber'] ?? '').toString();
    final String guests = (booking['guests'] ?? '2 adults').toString();
    final int nights =
        (booking['nights'] is num) ? (booking['nights'] as num).toInt() : 1;
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
    final List<String> included = (booking['included'] is List)
        ? (booking['included'] as List).map((e) => e.toString()).toList()
        : ['Pool', 'WiFi', 'Beach', 'Smart Lock', 'Pets OK'];
    final bool hasReview = booking['hasReview'] ?? false;
    final int? rating = booking['rating'];
    final String? reviewText = booking['reviewText'];

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
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WhatsIncludedSection(
                included: included,
                title: 'What was included',
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ReviewSection(
                hasReview: hasReview,
                rating: rating,
                reviewText: reviewText,
                onWriteReview: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WriteReviewScreen(
                        propertyName: propertyName,
                        propertyImage: imageUrl,
                        stayDates:
                            '${_formatDate(booking['checkIn'])} - ${_formatDate(booking['checkOut'])}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BookAgainButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailScreen(
                        propertyId: booking['propertyId']?.toString() ?? '1',
                        propertyName: propertyName,
                        propertyImage: imageUrl,
                        location: location,
                        rating: 4.8,
                        reviewCount: 124,
                        pricePerNight: pricePerNight,
                      ),
                    ),
                  );
                },
              ),
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

  Widget _includedPill(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10)),
        child: Text(label,
            style: AppTheme.dm(
                size: 13, weight: FontWeight.w600, color: AppColors.navy)),
      );
}
