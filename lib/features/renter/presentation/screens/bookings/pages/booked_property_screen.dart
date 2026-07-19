import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import '../widgets/booked_property_header.dart';
import '../widgets/property_photo_gallery.dart';
import '../widgets/booking_info_chips.dart';
import '../widgets/door_passcode_sos_buttons.dart';
import '../widgets/property_details_card.dart';
import '../widgets/location_map_section.dart';
import '../widgets/arrival_checklist_section.dart';
import '../widgets/rate_your_stay_section.dart';
import '../widgets/ask_sahely_ai_section.dart';
import 'smart_lock_screen.dart';
import 'arrival_checklist_screen.dart';
import '../../reviews/pages/write_review_screen.dart';

class BookedPropertyScreen extends StatelessWidget {
  final String bookingId;

  const BookedPropertyScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    // Watch provider to get updates when checklist changes
    final bookingsProvider = context.watch<BookingsProvider>();
    
    // Find the specific booking or show loading/error
    final allBookings = [...bookingsProvider.activeBookings, ...bookingsProvider.upcomingBookings, ...bookingsProvider.pastBookings];
    
    Booking? booking;
    try {
      booking = allBookings.firstWhere((b) => b.id == bookingId);
    } catch (e) {
      booking = null;
    }

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.cream, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // Header with Hero Image
          SliverToBoxAdapter(
            child: BookedPropertyHeader(
              propertyName: booking.propertyName,
              location: booking.location,
              imageUrl: booking.imageUrl,
              onBackTap: () => Navigator.pop(context),
            ),
          ),

          // Photo Gallery
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PropertyPhotoGallery(
                photos: [booking.imageUrl, booking.imageUrl, booking.imageUrl],
              ),
            ),
          ),

          // Booking Info Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BookingInfoChips(
                orderNumber: booking.orderNumber,
                dates: booking.dates,
                guests: booking.guests,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Door Passcode & SOS Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DoorPasscodeSosButtons(
                onDoorPasscodeTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SmartLockScreen(
                        propertyName: booking!.propertyName,
                        bookingRef: booking.orderNumber,
                        passcode: '8842',
                        checkIn: booking.checkIn,
                        checkOut: booking.checkOut,
                        propertyLat: 31.0263,
                        propertyLng: 28.9402,
                      ),
                    ),
                  );
                },
                onSOSTap: () {
                  context.push('/sos');
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Property Details
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PropertyDetailsCard(
                details: {
                  'bedrooms': 3,
                  'beds': 4,
                  'bathrooms': 2,
                  'beach': 'Hacienda White Beach',
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Location
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LocationMapSection(
                location: booking.location,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Arrival Checklist
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ArrivalChecklistSection(
                checklist: booking.checklist,
                onChecklistChanged: (newChecklist) {
                  context.read<BookingsProvider>().updateChecklist(bookingId, newChecklist);
                },
                onReportIssue: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArrivalChecklistScreen(
                        bookingId: booking!.orderNumber,
                        checkInTime: booking.checkIn,
                        checklistItems: List<Map<String, dynamic>>.from(booking.checklist),
                      ),
                    ),
                  );
                  
                  if (result != null && result is List<Map<String, dynamic>>) {
                    context.read<BookingsProvider>().updateChecklist(bookingId, result);
                  }
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Rate Your Stay
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RateYourStaySection(
                onAddReview: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WriteReviewScreen(
                        propertyName: booking!.propertyName,
                        propertyImage: booking.imageUrl,
                        stayDates: booking.dates,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Ask Sahely AI
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: AskSahelyAiSection(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
      ),
    );
  }
}
