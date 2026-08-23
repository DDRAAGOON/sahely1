import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/widgets/reviews_given_section.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/widgets/reviews_received_section.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/widgets/reviews_tabs.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  int _selectedTab = 0; // 0 = Given, 1 = Received (About Me)

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.navy,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Tabs
            ReviewsTabs(
              selectedTab: _selectedTab,
              onTabSelected: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),

            const SizedBox(height: 24),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _selectedTab == 0
                    ? ReviewsGivenSection(
                        reviewCount: profile.reviewsGiven,
                        reviews: const [
                          {
                            'propertyName': 'Lagoon Retreat',
                            'propertyImage':
                                'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=200',
                            'rating': 5,
                            'date': 'Jun 2026',
                            'reviewText':
                                'Unreal pool and the smart-lock check-in was effortless. Would book again in a heartbeat.',
                          },
                          {
                            'propertyName': 'Golden Dunes',
                            'propertyImage':
                                'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=200',
                            'rating': 4,
                            'date': 'May 2026',
                            'reviewText':
                                'Beautiful villa, quiet area. Beach was a little busy on the weekend but loved it overall.',
                          },
                        ],
                      )
                    : ReviewsReceivedSection(
                        reviewCount: profile.reviewsReceived,
                        reviews: const [
                          {
                            'hostName': 'Layla M.',
                            'hostRole': 'Owner',
                            'hostAvatar' : null,
                            'rating': 5,
                            'reviewText':
                                'Wonderful guest — left the villa spotless and communicated clearly. Welcome any time!',
                          },
                          {
                            'hostName': 'Karim A.',
                            'hostRole': 'Broker',
                            'hostAvatar': null,
                            'rating': 5,
                            'reviewText':
                                'Respectful, on-time check-out, easy to coordinate with. A 5-star guest.',
                          },
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
