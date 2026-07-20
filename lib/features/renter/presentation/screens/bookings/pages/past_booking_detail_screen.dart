import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/property/page/property_detail_screen.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/pages/write_review_screen.dart';

import '../widgets/book_again_button.dart';
import '../widgets/past_booking_hero_image.dart';
import '../widgets/price_breakdown_card.dart';
import '../widgets/reservation_details_card.dart';
import '../widgets/review_section.dart';
import '../widgets/whats_included_section.dart';

class PastBookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> booking;

  const PastBookingDetailScreen({
    super.key,
    required this.booking,
  });

  String _formatReservationDate(dynamic date) {
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

  @override
  Widget build(BuildContext context) {
    // Data extraction with safety
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
          // 1. Hero Image (Contains Title & Location as overlay)
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

          // 2. Reservation Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reservation',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: 'DM Sans'),
                  ),
                  const SizedBox(height: 12),
                  ReservationDetailsCard(
                    orderNumber: orderNumber,
                    checkIn: _formatReservationDate(booking['checkIn']),
                    checkOut: _formatReservationDate(booking['checkOut']),
                    guests: guests,
                    nights: nights,
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 3. What was included
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

          // 4. Price Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        fontFamily: 'DM Sans'),
                  ),
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

          // 5. Review Section
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
                            '${_formatReservationDate(booking['checkIn'])} - ${_formatReservationDate(booking['checkOut'])}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 6. Book Again Button
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
}
