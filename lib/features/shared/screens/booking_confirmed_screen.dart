import 'package:flutter/material.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import '../../../data/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';
import '../../../core/navigation/app_navigation.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final property = args?['property'] as Property?;
    final total = args?['total'] as double? ?? 21090;
    final guests = args?['guests'] as int? ?? 2;
    final pName = property?.name ?? 'Azure Beach Villa';

    String format(num n) => n.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},");

    return PhoneScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(child: SuccessCheck(gold: true)),
            const SizedBox(height: 24),
            Text("You're All Set!", style: AppTheme.dm(size: 26, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            Text(
              'Your booking at $pName is confirmed.',
              textAlign: TextAlign.center,
              style: AppTheme.dm(size: 14, color: AppColors.muted, height: 1.5),
            ),
            const SizedBox(height: 24),
            WhiteCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const KeyValueRow('Check-in', 'Jun 21, 3:00 PM'),
                  const KeyValueRow('Check-out', 'Jun 25, 11:00 AM'),
                  KeyValueRow('Guests', '$guests adults'),
                  const KeyValueRow('Unit · Floor', 'B-214 · Floor 2'),
                  const KeyValueRow('Booking ref', 'SHLY-8842'),
                  KeyValueRow('Total paid', 'EGP ${format(total)}', bold: true, topBorder: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFB3923C)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 22, color: AppColors.navy),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You earned 10 Sahel Stars on this booking!',
                      style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.navy),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Smart Lock Button
            Material(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/broker/smart-lock',
                    arguments: {
                      'propertyName': pName,
                      'bookingRef': 'SHLY-8842',
                      'passcode': '1248',
                      'checkIn': DateTime.now().subtract(const Duration(hours: 2)),
                      'checkOut': DateTime.now().add(const Duration(days: 4)),
                      'lat': 31.02,
                      'lng': 29.60,
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 20, color: AppColors.gold),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Smart lock ready — tap to access your property',
                          style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            NavyButton(
              label: 'View My Bookings',
              onTap: () => AppNavigation.goToRenterBookings(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
