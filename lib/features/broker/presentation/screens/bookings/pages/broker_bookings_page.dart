import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/bloc/broker_bookings_cubit.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/widgets/broker_active_booking_card.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/widgets/broker_bookings_filter_tabs.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/widgets/broker_bookings_header.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/widgets/broker_past_stays_section.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/widgets/broker_upcoming_booking_card.dart';

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
    _handleInitialTab();
  }

  void _handleInitialTab() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouterState.of(context);
      final tab = state.uri.queryParameters['tab'];
      if (tab != null && _tabs.contains(tab)) {
        setState(() {
          _selectedTab = tab;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant BrokerBookingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleInitialTab();
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
          return const Center(
              child: CircularProgressIndicator(color: AppColors.gold));
        }

        final filteredBookings =
            state.bookings.where((b) => b.status == _selectedTab).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedTab == 'Active') ...[
                if (filteredBookings.isEmpty)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text('No active bookings found',
                        style: AppTheme.dm(color: AppColors.secondary)),
                  ))
                else
                  ...filteredBookings.map((booking) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: BrokerActiveBookingCard(
                          propertyName: booking.propertyName,
                          location: booking.area,
                          orderNumber: booking.orderNo,
                          dates: booking.dates,
                          guests: booking.guests,
                          imageUrl: booking.imageUrl,
                          onDigitalLockTap: () {
                            AppNavigation.goToBrokerSmartLock(
                              context,
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
                            AppNavigation.goToBrokerSos(context);
                          },
                          onPropertyTap: () {
                            AppNavigation.goToPropertyDetail(context, extra: {
                              'name': booking.propertyName,
                              'location': booking.area,
                              'imageUrl': booking.imageUrl,
                            });
                          },
                          onViewDetailsTap: () {
                            context.push('/broker/booking-details', extra: {
                              'propertyName': booking.propertyName,
                              'location': booking.area,
                              'imageUrl': booking.imageUrl,
                              'orderNumber': booking.orderNo,
                              'dates': booking.dates,
                              'guests': booking.guests,
                              'checkIn': booking.checkIn,
                              'checkOut': booking.checkOut,
                            });
                          },
                        ),
                      )),
              ] else if (_selectedTab == 'Upcoming') ...[
                if (filteredBookings.isEmpty)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text('No upcoming bookings found',
                        style: AppTheme.dm(color: AppColors.secondary)),
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
                            AppNavigation.goToPropertyDetail(context, extra: {
                              'name': booking.propertyName,
                              'location': booking.area,
                              'imageUrl': booking.imageUrl,
                              'rating': 4.8,
                              'reviewCount': 124,
                              'pricePerNight': 4500,
                            });
                          },
                        ),
                      )),
              ] else ...[
                if (filteredBookings.isEmpty)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text('No past stays found',
                        style: AppTheme.dm(color: AppColors.secondary)),
                  ))
                else
                  BrokerPastStaysSection(
                    pastBookings: filteredBookings,
                    onCardTap: (booking) {
                      AppNavigation.goToPropertyDetail(context, extra: {
                        'name': booking.propertyName,
                        'location': booking.area,
                        'imageUrl': booking.imageUrl,
                        'rating': 4.8,
                        'reviewCount': 124,
                        'pricePerNight': 4500,
                      });
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
