import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/bookings/widgets/booking_card.dart';
import '../../../../shared/bookings/domain/entities/booking.dart';
import '../../../../shared/widgets/buttons/sahely_button.dart';

class OwnerBookingsPage extends StatefulWidget {
  const OwnerBookingsPage({super.key});

  @override
  State<OwnerBookingsPage> createState() => _OwnerBookingsPageState();
}

class _OwnerBookingsPageState extends State<OwnerBookingsPage> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Property Bookings', style: AppTheme.dm(size: 20, weight: FontWeight.w700)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTab('Upcoming', 0),
                const SizedBox(width: 8),
                _buildTab('Active', 1),
                const SizedBox(width: 8),
                _buildTab('Past', 2),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        itemCount: 2,
        itemBuilder: (context, index) {
          final booking = Booking(
            id: index.toString(),
            propertyId: 'p1',
            propertyName: 'Golden Dunes',
            propertyImage: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
            location: 'Marassi',
            orderNo: 'SHLY-992$index',
            startDate: DateTime.now().add(const Duration(days: 2)),
            endDate: DateTime.now().add(const Duration(days: 5)),
            guests: 4,
            totalPrice: 15000,
            status: _activeTab == 1 ? BookingStatus.active : BookingStatus.upcoming,
          );

          return BookingCard(
            booking: booking,
            showFullDetails: _activeTab == 1,
            bottomAction: _activeTab == 1 ? SahelyButton(
              label: 'Manage Stay',
              variant: ButtonVariant.outline,
              height: 44,
              onTap: () {},
            ) : null,
          );
        },
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.navy : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTheme.dm(
            size: 13, 
            weight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
