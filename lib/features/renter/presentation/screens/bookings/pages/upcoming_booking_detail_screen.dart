import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sahely/core/theme/app_colors.dart';
import '../widgets/booking_hero_image.dart';
import '../widgets/booking_photo_gallery.dart';
import '../widgets/about_place_section.dart';
import '../widgets/location_map_section.dart';
import '../widgets/check_in_banner.dart';
import '../widgets/reservation_details_card.dart';
import '../widgets/whats_included_section.dart';
import '../widgets/price_breakdown_card.dart';
import '../widgets/ask_sahely_ai_banner.dart';
import '../widgets/cancel_booking_button.dart';

class UpcomingBookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> booking;

  const UpcomingBookingDetailScreen({
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
        // Formats to "Jun 21 · 3:00 PM"
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
    final String propertyName = (booking['propertyName'] ?? 'Property').toString();
    final String location = (booking['location'] ?? 'Location').toString();
    final String imageUrl = (booking['imageUrl'] ?? '').toString();
    final String orderNumber = (booking['orderNumber'] ?? '').toString();
    final String guests = (booking['guests'] ?? '1 Guest').toString();
    final String description = (booking['description'] ?? 'No description available.').toString();
    
    final int nights = (booking['nights'] is num) ? (booking['nights'] as num).toInt() : 1;
    final int daysUntilCheckIn = (booking['daysUntilCheckIn'] is num) ? (booking['daysUntilCheckIn'] as num).toInt() : 4;
    final int pricePerNight = (booking['pricePerNight'] is num) ? (booking['pricePerNight'] as num).toInt() : 0;
    final int cleaningVat = (booking['cleaningVat'] is num) ? (booking['cleaningVat'] as num).toInt() : 0;
    final int total = (booking['total'] is num) ? (booking['total'] as num).toInt() : 0;

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
          // 1. Hero Image
          SliverToBoxAdapter(
            child: BookingHeroImage(
              imageUrl: imageUrl,
              allPhotos: photos,
              onBackTap: () => Navigator.pop(context),
            ),
          ),

          // 2. Property Title & Location
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    propertyName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(fontSize: 13, color: AppColors.secondary, fontFamily: 'DM Sans'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Photo Gallery
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BookingPhotoGallery(photos: photos),
            ),
          ),

          // 5. About Place
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AboutPlaceSection(description: description, amenities: amenities),
            ),
          ),

          // 5.5 Location Map
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: LocationMapSection(location: location),
            ),
          ),

          // 5.7 Check-in Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CheckInBanner(daysUntilCheckIn: daysUntilCheckIn),
            ),
          ),

          // 6. Reservation Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reservation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'DM Sans'),
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

          // 7. What's Included
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WhatsIncludedSection(included: included),
            ),
          ),

          // 8. Price Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'DM Sans'),
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

          // 9. Ask Sahely AI
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AskSahelyAiBanner(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sahely AI is ready to help!'), backgroundColor: AppColors.navy),
                  );
                },
              ),
            ),
          ),

          // 10. Cancel Booking Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: CancelBookingButton(onTap: () => _showCancelDialog(context)),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Booking',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'DM Sans'),
        ),
        content: const Text('Are you sure you want to cancel this booking?',
          style: TextStyle(fontSize: 14, color: AppColors.secondary, fontFamily: 'DM Sans'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Keep')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB22222)),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
