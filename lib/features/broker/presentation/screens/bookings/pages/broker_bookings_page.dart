import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../bloc/broker_bookings_cubit.dart';
import '../widgets/broker_bookings_header.dart';
import '../widgets/broker_bookings_filter_tabs.dart';
import '../widgets/broker_active_booking_card.dart';
import '../widgets/broker_upcoming_booking_card.dart';
import '../widgets/broker_past_stays_section.dart';

class BrokerBookingsPage extends StatefulWidget {
  const BrokerBookingsPage({super.key});

  @override
  State<BrokerBookingsPage> createState() => _BrokerBookingsPageState();
}

class _BrokerBookingsPageState extends State<BrokerBookingsPage> {
  String _selectedTab = 'Active';
  final List<String> _tabs = ['Upcoming', 'Active', 'Past'];

  @override
  void initState() {
    super.initState();
    context.read<BrokerBookingsCubit>().loadBookings();
  }

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
            const BrokerBookingsHeader(),
            const SizedBox(height: 20),
            BrokerBookingsFilterTabs(
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
    return BlocBuilder<BrokerBookingsCubit, BrokerBookingsState>(
      builder: (context, state) {
        if (state.status == BrokerBookingsStatus.loading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.gold));
        }

        final filteredBookings = state.bookings.where((b) => b.status == _selectedTab).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedTab == 'Active') ...[
                if (filteredBookings.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text('No active bookings found', style: TextStyle(color: AppColors.secondary, fontFamily: 'DM Sans')),
                  ))
                else
                  ...filteredBookings.map((booking) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: BrokerActiveBookingCard(
                      propertyName: booking.propertyName,
                      location: booking.area,
                      orderNumber: booking.orderNo,
                      dates: booking.dates,
                      guests: booking.guests,
                      imageUrl: booking.imageUrl,
                      onDigitalLockTap: () {
                        context.push(
                          '/broker/smart-lock',
                          extra: {
                            'propertyName': booking.propertyName,
                            'bookingRef': booking.orderNo,
                            'passcode': '8842',
                            'checkIn': booking.checkIn,
                            'checkOut': booking.checkOut,
                            'propertyLat': 31.0263,
                            'propertyLng': 28.9402,
                          },
                        );
                      },
                      onSOSTap: () {
                        context.push('/broker/sos');
                      },
                      onViewDetailsTap: () {
                        context.push(
                          '/broker/booking-details',
                          extra: {
                            'propertyName': booking.propertyName,
                            'location': booking.area,
                            'imageUrl': booking.imageUrl,
                            'orderNumber': booking.orderNo,
                            'dates': booking.dates,
                            'guests': booking.guests,
                            'checkIn': booking.checkIn,
                            'checkOut': booking.checkOut,
                          }
                        );
                      },
                    ),
                  )),
              ] 
              else if (_selectedTab == 'Upcoming') ...[
                if (filteredBookings.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text('No upcoming bookings found', style: TextStyle(color: AppColors.secondary, fontFamily: 'DM Sans')),
                  ))
                else
                  ...filteredBookings.map((booking) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: BrokerUpcomingBookingCard(
                      propertyName: booking.propertyName,
                      location: booking.area,
                      dates: booking.dates,
                      orderNumber: booking.orderNo,
                      imageUrl: booking.imageUrl,
                      profit: booking.profit,
                      onTap: () {
                        // Navigate to Broker Upcoming Booking Detail
                      },
                    ),
                  )),
              ] 
              else ...[
                if (filteredBookings.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text('No past stays found', style: TextStyle(color: AppColors.secondary, fontFamily: 'DM Sans')),
                  ))
                else
                  BrokerPastStaysSection(
                    pastBookings: filteredBookings,
                    onCardTap: (booking) {
                      // Navigate to Broker Past Booking Detail
                    },
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}
