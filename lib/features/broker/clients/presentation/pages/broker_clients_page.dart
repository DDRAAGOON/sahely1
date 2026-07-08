import 'package:flutter/material.dart';
import '../../../../shared/bookings/widgets/booking_card.dart';
import '../../../../shared/bookings/domain/entities/booking.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class BrokerClientsPage extends StatelessWidget {
  const BrokerClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Client Bookings', style: AppTheme.dm(size: 20, weight: FontWeight.w700)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        itemCount: 3,
        itemBuilder: (context, index) {
          return BookingCard(
            booking: Booking(
              id: index.toString(),
              propertyId: 'p1',
              propertyName: 'Sea View Chalet',
              propertyImage: 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800',
              location: 'Marassi',
              orderNo: 'SHLY-441$index',
              startDate: DateTime.now().add(const Duration(days: 5)),
              endDate: DateTime.now().add(const Duration(days: 10)),
              guests: 4,
              totalPrice: 12000,
              status: BookingStatus.upcoming,
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
