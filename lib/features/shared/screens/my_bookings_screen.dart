import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/shared/screens/active_booking_detail_screen.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/active_booking_card.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/bookings_filter_tabs.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/bookings_header.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/past_stays_section.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/widgets/upcoming_booking_card.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String _selectedTab = 'Active';
  final List<String> _tabs = ['Upcoming', 'Active', 'Past'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const BookingsHeader(),
            const SizedBox(height: 20),
            BookingsFilterTabs(
              tabs: _tabs,
              selectedTab: _selectedTab,
              onTabSelected: (tab) {
                setState(() {
                  _selectedTab = tab;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final bookingsProvider = context.watch<BookingsProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedTab == 'Active') ...[
            if (bookingsProvider.activeBookings.isEmpty)
              const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text('No active bookings found',
                    style: TextStyle(
                        color: AppColors.secondary, fontFamily: 'DM Sans')),
              ))
            else
              ...bookingsProvider.activeBookings.map((booking) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ActiveBookingCard(
                      propertyName: booking.propertyName,
                      location: booking.location,
                      orderNumber: booking.orderNumber,
                      dates: booking.dates,
                      guests: booking.guests,
                      imageUrl: booking.imageUrl,
                      onDigitalLockTap: () {
                        AppNavigation.goToSmartLock(
                          context,
                          extra: {
                            'propertyName': booking.propertyName,
                            'bookingRef': booking.orderNumber,
                            'passcode': '8842',
                            'checkIn': booking.checkIn,
                            'checkOut': booking.checkOut,
                            'propertyLat': 31.0263,
                            'propertyLng': 28.9402,
                          },
                        );
                      },
                      onSOSTap: () {
                        AppNavigation.goToSos(context);
                      },
                      onViewDetailsTap: () {
                        AppNavigation.goToBookingDetail(
                          context,
                          extra: {
                            'propertyName': booking.propertyName,
                            'location': booking.location,
                            'orderNumber': booking.orderNumber,
                            'dates': booking.dates,
                            'guests': booking.guests,
                            'imageUrl': booking.imageUrl,
                            'role': ActiveBookingRole.renter,
                          },
                        );
                      },
                    ),
                  )),
          ] else if (_selectedTab == 'Upcoming') ...[
            if (bookingsProvider.upcomingBookings.isEmpty)
              const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text('No upcoming bookings found',
                    style: TextStyle(
                        color: AppColors.secondary, fontFamily: 'DM Sans')),
              ))
            else
              ...bookingsProvider.upcomingBookings.map((booking) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: UpcomingBookingCard(
                      propertyName: booking.propertyName,
                      location: booking.location,
                      dates: booking.dates,
                      orderNumber: booking.orderNumber,
                      imageUrl: booking.imageUrl,
                      onTap: () {
                        AppNavigation.goToBookingUpcoming(
                          context,
                          extra: {
                            'propertyName': booking.propertyName,
                            'location': booking.location,
                            'imageUrl': booking.imageUrl,
                            'orderNumber': booking.orderNumber,
                            'checkIn': booking.checkIn,
                            'checkOut': booking.checkOut,
                            'guests': booking.guests,
                            'total': booking.totalPaid,
                            'nights': booking.checkOut
                                .difference(booking.checkIn)
                                .inDays,
                            'daysUntilCheckIn': booking.checkIn
                                .difference(DateTime.now())
                                .inDays,
                            'photos': [
                              booking.imageUrl,
                              booking.imageUrl,
                              booking.imageUrl
                            ],
                            'description':
                                'A beautiful stay in the heart of ${booking.location}. Enjoy world-class amenities and breathtaking views.',
                            'amenities': const [
                              'Wi-Fi',
                              'Pool',
                              'Parking',
                              'Kitchen'
                            ],
                            'included': const [
                              'Breakfast',
                              'Free Cleaning',
                              'Airport Transfer'
                            ],
                            'latitude': 31.0263,
                            'longitude': 28.9402,
                            'pricePerNight': 2500,
                            'cleaningVat': 150,
                          },
                        );
                      },
                    ),
                  )),
          ] else ...[
            if (bookingsProvider.pastBookings.isEmpty)
              const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text('No past stays found',
                    style: TextStyle(
                        color: AppColors.secondary, fontFamily: 'DM Sans')),
              ))
            else
              PastStaysSection(
                pastBookings: bookingsProvider.pastBookings,
                onCardTap: (booking) {
                  AppNavigation.goToBookingPast(
                    context,
                    extra: {
                      'propertyName': booking.propertyName,
                      'location': booking.location,
                      'imageUrl': booking.imageUrl,
                      'orderNumber': booking.orderNumber,
                      'checkIn': booking.checkIn,
                      'checkOut': booking.checkOut,
                      'guests': booking.guests,
                      'total': booking.totalPaid,
                      'nights': booking.checkOut
                          .difference(booking.checkIn)
                          .inDays,
                      'photos': [
                        booking.imageUrl,
                        booking.imageUrl,
                        booking.imageUrl
                      ],
                      'description':
                          'Your wonderful stay at ${booking.propertyName} in ${booking.location}. We hope to see you again!',
                      'amenities': const [
                        'Wi-Fi',
                        'Pool',
                        'Parking',
                        'Kitchen'
                      ],
                      'included': const ['Breakfast', 'Free Cleaning'],
                      'pricePerNight': 2500,
                      'cleaningVat': 150,
                      'hasReview': false,
                      // Logic could check if a review exists
                    },
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}


