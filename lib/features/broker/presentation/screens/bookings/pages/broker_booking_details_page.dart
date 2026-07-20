import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/arrival_checklist_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/ask_sahely_ai_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/booked_property_header.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/booking_info_chips.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/door_passcode_sos_buttons.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/location_map_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/property_details_card.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/property_photo_gallery.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/rate_your_stay_section.dart';

class BrokerBookingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BrokerBookingDetailsPage({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final String propertyName = booking['propertyName'] ?? '';
    final String location = booking['location'] ?? '';
    final String imageUrl = booking['imageUrl'] ?? '';
    final String orderNumber = booking['orderNumber'] ?? '';
    final String dates = booking['dates'] ?? '';
    final String guests = booking['guests'] ?? '';

    // Default checklist if not provided
    final List<Map<String, dynamic>> checklist = booking['checklist'] ??
        [
          {'label': 'Key collection / Smart lock', 'completed': true},
          {'label': 'WiFi connectivity', 'completed': true},
          {'label': 'AC performance', 'completed': false},
          {'label': 'Cleaning standard', 'completed': false},
          {'label': 'Hot water availability', 'completed': false},
          {'label': 'Pool access', 'completed': false},
        ];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // Header with Hero Image
          SliverToBoxAdapter(
            child: BookedPropertyHeader(
              propertyName: propertyName,
              location: location,
              imageUrl: imageUrl,
              onBackTap: () => context.pop(),
            ),
          ),

          // Photo Gallery
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PropertyPhotoGallery(
                photos: [imageUrl, imageUrl, imageUrl],
              ),
            ),
          ),

          // Booking Info Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BookingInfoChips(
                orderNumber: orderNumber,
                dates: dates,
                guests: guests,
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
                  AppNavigation.goToBrokerSmartLock(
                    context,
                    extra: {
                      'propertyName': propertyName,
                      'bookingRef': orderNumber,
                      'passcode': '8842',
                      'checkIn': booking['checkIn'] ?? DateTime.now(),
                      'checkOut': booking['checkOut'] ??
                          DateTime.now().add(const Duration(days: 4)),
                      'propertyLat': 31.0263,
                      'propertyLng': 28.9402,
                    },
                  );
                },
                onSOSTap: () {
                  AppNavigation.goToBrokerSos(context);
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
                location: location,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Arrival Checklist
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ArrivalChecklistSection(
                checklist: checklist,
                onChecklistChanged: (newChecklist) {
                  // In a real app, you would update a provider or state here
                },
                onReportIssue: () {
                  context.push(
                    '/broker/arrival-checklist',
                    extra: {
                      'bookingId': orderNumber,
                      'checkInTime': booking['checkIn'] ?? DateTime.now(),
                      'checklistItems':
                          List<Map<String, dynamic>>.from(checklist),
                    },
                  );
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
                  context.push(
                    '/write-review',
                    extra: {
                      'propertyName': propertyName,
                      'propertyImage': imageUrl,
                      'stayDates': dates,
                    },
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

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
