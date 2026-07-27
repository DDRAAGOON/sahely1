import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class ConciergeScreen extends StatefulWidget {
  const ConciergeScreen({super.key});

  @override
  State<ConciergeScreen> createState() => _ConciergeScreenState();
}

class _ConciergeScreenState extends State<ConciergeScreen> {
  final String _selectedCategory = 'All';

  // Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø®Ø¯Ù…Ø§Øª Ø§Ù„Ù…ØªÙ…ÙŠØ²Ø© Ù…Ø¹ Ø§Ù„ØªØµÙ†ÙŠÙØ§Øª
  final List<Map<String, dynamic>> _allPremiumServices = [
    {
      'name': 'Private Chef',
      'price': 1200,
      'imageUrl':
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      'category': 'Dining',
    },
    {
      'name': 'Airport Transfer',
      'price': 800,
      'imageUrl':
          'https://images.unsplash.com/photo-1540962351504-03099e0a754b?w=800',
      'category': 'Transport',
    },
    {
      'name': 'Yacht Rental',
      'price': 5000,
      'imageUrl':
          'https://images.unsplash.com/photo-1567899378494-47b22a2ae96a?w=800',
      'category': 'Transport',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Ù…Ù†Ø·Ù‚ Ø§Ù„ÙÙ„ØªØ±Ø©
    _allPremiumServices.where((service) {
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
                              fontFamily: 'DM Sans',
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
                                fontFamily: 'DM Sans',
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
