import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/kit.dart';
import '../../../../../../core/widgets/ui.dart';
import '../../smart_lock/pages/broker_smart_lock_screen.dart';
import '../../support/pages/broker_sos_chat_screen.dart';

class BrokerBookingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BrokerBookingDetailsPage({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final String pName = booking['propertyName'] ?? '';
    final String location = booking['location'] ?? '';
    final String imageUrl = booking['imageUrl'] ?? '';
    final String orderNo = booking['orderNumber'] ?? '';
    final String dates = booking['dates'] ?? '';
    final String guests = booking['guests'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SahelyImage(
                  imageUrl: imageUrl,
                  height: 240,
                  width: double.infinity,
                  fadeHeight: 100,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.chevron_left, color: AppColors.navy),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'DM Sans'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Info Chips
                Row(
                  children: [
                    _infoChip(Icons.tag, orderNo),
                    const SizedBox(width: 8),
                    _infoChip(Icons.calendar_today, dates.split('·')[0]),
                    const SizedBox(width: 8),
                    _infoChip(Icons.people_outline, guests.split(',')[0]),
                  ],
                ),
                const SizedBox(height: 24),

                // Main Buttons
                Row(
                  children: [
                    Expanded(
                      child: NavyButton(
                        label: 'Digital Lock',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrokerSmartLockScreen(
                                propertyName: pName,
                                bookingRef: orderNo,
                                passcode: '8842',
                                checkIn: booking['checkIn'],
                                checkOut: booking['checkOut'],
                                propertyLat: 31.02,
                                propertyLng: 29.60,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WideButton(
                        label: 'SOS',
                        color: AppColors.sos,
                        icon: Icons.warning_amber_rounded,
                        onTap: () {
                          Navigator.pushNamed(context, '/sos');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Details Card
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Property Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy)),
                      const SizedBox(height: 16),
                      _detailRow(Icons.king_bed_outlined, '3 Bedrooms'),
                      const Divider(height: 24),
                      _detailRow(Icons.bathtub_outlined, '2 Bathrooms'),
                      const Divider(height: 24),
                      _detailRow(Icons.beach_access_outlined, 'Beachfront Access'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Location Map Placeholder
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 32, color: AppColors.muted),
                        SizedBox(height: 8),
                        Text('Map View', style: TextStyle(color: AppColors.muted)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.gold),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.navy), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.navy),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 14, color: AppColors.navy)),
      ],
    );
  }
}
