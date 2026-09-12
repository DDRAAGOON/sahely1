import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/widgets/reviews_given_section.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/widgets/reviews_received_section.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/widgets/reviews_tabs.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/reviews/domain/repositories/review_repository.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  int _selectedTab = 0; // 0 = Given, 1 = Received (About Me)
  List<Map<String, dynamic>> _given = const [];
  List<Map<String, dynamic>> _received = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _role(String role) => switch (role.toLowerCase()) {
        'broker' => 'Broker',
        'owner' => 'Owner',
        _ => 'Renter',
      };

  /// `GET /reviews?userId=`: the reviews I wrote (with the listing's name
  /// and photo) and the ones hosts wrote about me.
  Future<void> _load() async {
    final profile = context.read<ProfileProvider>();
    await profile.fetchProfileData();
    final id = profile.id;
    if (id.isEmpty) return;
    try {
      final reviews = await sl<ReviewRepository>().getUserReviews(id);
      final mine = reviews.where((r) => r.userId == id).toList();
      final aboutMe = reviews.where((r) => r.userId != id).toList();
      final listings = <String, Property>{};
      for (final propertyId in {for (final r in mine) r.propertyId}) {
        if (propertyId.isEmpty) continue;
        try {
          listings[propertyId] =
              await sl<RenterRepository>().getProperty(propertyId);
        } catch (_) {}
      }
      if (!mounted) return;
      setState(() {
        _given = [
          for (final r in mine)
            {
              'propertyName': listings[r.propertyId]?.name ?? '',
              'propertyImage': listings[r.propertyId]?.image ?? '',
              'rating': r.rating.round(),
              'date': '${_months[r.createdAt.month - 1]} ${r.createdAt.year}',
              'reviewText': r.comment,
            },
        ];
        _received = [
          for (final r in aboutMe)
            {
              'hostName': r.userName,
              'hostRole': _role(r.userRole),
              'hostAvatar': r.userAvatar,
              'rating': r.rating.round(),
              'reviewText': r.comment,
            },
        ];
      });
    } catch (_) {
      // Both tabs stay empty.
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        reviewCount: _given.length,
                        reviews: _given,
                      )
                    : ReviewsReceivedSection(
                        reviewCount: _received.length,
                        reviews: _received,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
