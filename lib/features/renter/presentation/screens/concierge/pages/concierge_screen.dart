import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/widgets/blocked_action_gate.dart';
import 'package:sahely/core/theme/app_colors.dart';

import 'concierge_booking_screen.dart';

class ConciergeScreen extends StatefulWidget {
  const ConciergeScreen({super.key});

  @override
  State<ConciergeScreen> createState() => _ConciergeScreenState();
}

class _ConciergeScreenState extends State<ConciergeScreen> {
  final String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Home', 'Dining', 'Transport'];

  // Mocked state for logic
  final bool _hasActiveBooking = true;
  final int _userMawsemLevel = 3;

  // قائمة الخدمات المتميزة مع التصنيفات
  final List<Map<String, dynamic>> _allPremiumServices = [
    {
      'name': 'Private Chef',
      'price': 1200,
      'imageUrl': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      'category': 'Dining',
    },
    {
      'name': 'Airport Transfer',
      'price': 800,
      'imageUrl': 'https://images.unsplash.com/photo-1540962351504-03099e0a754b?w=800',
      'category': 'Transport',
    },
    {
      'name': 'Yacht Rental',
      'price': 5000,
      'imageUrl': 'https://images.unsplash.com/photo-1567899378494-47b22a2ae96a?w=800',
      'category': 'Transport',
    },
  ];

  void _handleServiceRequest(String serviceName, {int? price}) {
    final verificationCubit = context.read<VerificationCubit>();
    if (!_hasActiveBooking) {
      _showNoActiveBookingSheet();
      return;
    }
    // Block action if not fully verified
    if (!verificationCubit.canPerformAction()) {
      _showBlockedActionSheet();
      return;
    }
    _openBookingFlow(serviceName, price);
  }

  void _showNoActiveBookingSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _InfoBottomSheet(
        title: 'No Active Booking',
        message: 'Concierge services are only available when you have an active booking or during the booking process.',
        buttonText: 'Find a Property',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _showBlockedActionSheet() {
    final verificationCubit = context.read<VerificationCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final dataState = verificationCubit.currentDataState;
        return BlockedActionGate(
          emailVerified: dataState.emailVerified,
          phoneVerified: dataState.phoneVerified,
          idVerified: dataState.idVerified,
          cardAdded: dataState.cardAdded,
          onCompleteSetup: () {
            Navigator.pop(context);
            // Navigate to profile or specific verification step
          },
          onNotNow: () => Navigator.pop(context),
        );
      },
    );
  }

  void _openBookingFlow(String serviceName, int? price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConciergeBookingScreen(
          serviceName: serviceName,
          basePrice: price,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // منطق الفلترة
    final bool showHomeGrid = _selectedCategory == 'All' || _selectedCategory == 'Home';
    
    final List<Map<String, dynamic>> filteredPremiumServices = _allPremiumServices.where((service) {
      if (_selectedCategory == 'All') return true;
      return service['category'] == _selectedCategory;
    }).toList();

    return Container(
      color: AppColors.cream,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Coming Soon Placeholder (Centered)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Icon(Icons.hourglass_bottom_rounded,
                                color: AppColors.gold.withValues(alpha: 0.6),
                                size: 48),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Coming Soon',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Our premium concierge services are currently under development to provide you with the best experience.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const _InfoBottomSheet({
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'DM Sans')),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: AppColors.secondary, fontFamily: 'DM Sans')),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(buttonText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'DM Sans')),
            ),
          ),
        ],
      ),
    );
  }
}
