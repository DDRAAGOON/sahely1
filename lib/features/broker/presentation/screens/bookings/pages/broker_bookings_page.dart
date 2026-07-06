import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/kit.dart';
import '../bloc/broker_bookings_cubit.dart';

class BrokerBookingsPage extends StatefulWidget {
  const BrokerBookingsPage({super.key});

  @override
  State<BrokerBookingsPage> createState() => _BrokerBookingsPageState();
}

class _BrokerBookingsPageState extends State<BrokerBookingsPage> {
  int activeTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<BrokerBookingsCubit>().loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: BlocBuilder<BrokerBookingsCubit, BrokerBookingsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Broker Bookings',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 12),
                      SegmentTabs(
                        tabs: const ['Upcoming', 'Active', 'Past'],
                        active: activeTab,
                        onTap: (i) => setState(() => activeTab = i),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    itemCount: state.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                booking.imageUrl,
                                width: 84,
                                height: 84,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        booking.propertyName,
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'Cairo'),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.gold.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '+EGP ${booking.profit.toInt()}',
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gold, fontFamily: 'Cairo'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    booking.area,
                                    style: const TextStyle(fontSize: 12, color: AppColors.secondary, fontFamily: 'Cairo'),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    booking.dateRange,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy, fontFamily: 'Cairo'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
