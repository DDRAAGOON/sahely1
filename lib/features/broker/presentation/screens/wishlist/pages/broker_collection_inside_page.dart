import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/broker/presentation/screens/wishlist/widgets/broker_collection_header.dart';
import 'package:sahely/features/broker/presentation/screens/wishlist/widgets/broker_collection_members_actions.dart';
import 'package:sahely/features/broker/presentation/screens/wishlist/widgets/broker_collection_property_card.dart';

class BrokerCollectionInsidePage extends StatefulWidget {
  final String collectionId;
  final String collectionName;
  final int propertyCount;
  final int sharedWithCount;
  final List<String> memberNames;

  const BrokerCollectionInsidePage({
    super.key,
    required this.collectionId,
    required this.collectionName,
    required this.propertyCount,
    required this.sharedWithCount,
    required this.memberNames,
  });

  @override
  State<BrokerCollectionInsidePage> createState() =>
      _BrokerCollectionInsidePageState();
}

class _BrokerCollectionInsidePageState
    extends State<BrokerCollectionInsidePage> {
  @override
  void initState() {
    super.initState();
    context
        .read<WishlistCubit>()
        .loadWishlistItems(widget.collectionId, Role.broker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            BrokerCollectionHeader(
              collectionName: widget.collectionName,
              propertyCount: widget.propertyCount,
              sharedWithCount: widget.sharedWithCount,
              onBackTap: () => Navigator.pop(context),
            ),

            // Members & Actions
            BrokerCollectionMembersActions(
              memberNames: widget.memberNames,
              onChatTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Group Chat...')),
                );
              },
              onShareTap: () {
                final cubit = context.read<WishlistCubit>();
                final collection = cubit.state.collections.firstWhere(
                  (c) => c.id == widget.collectionId,
                  orElse: () => WishlistCollection(
                      id: widget.collectionId,
                      name: widget.collectionName,
                      itemCount: widget.propertyCount),
                );

                AppNavigation.goToShareCollection(
                  context,
                  collectionId: widget.collectionId,
                  collectionName: widget.collectionName,
                  collectionImage: collection.coverImage ?? '',
                  placesCount: collection.itemCount,
                );
              },
              onCompareTap: () {
                AppNavigation.goToCompare(
                  context,
                  collectionName: widget.collectionName,
                  collectionId: widget.collectionId,
                  memberNames: widget.memberNames,
                );
              },
            ),

            const SizedBox(height: 16),

            // Property List
            Expanded(
              child: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  if (state.status == WishlistStatus.loading) {
                    return const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.gold));
                  }

                  if (state.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border,
                              size: 64,
                              color:
                                  AppColors.secondary.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Text(
                            'No properties in this collection yet',
                            style: AppTheme.dm(color: AppColors.secondary),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return BrokerCollectionPropertyCard(
                        propertyName: item.propertyName,
                        location: 'North Coast, Egypt',
                        propertyType: 'Villa',
                        beds: 3,
                        amenities: const ['Pool', 'Wi-Fi'],
                        rating: 4.8,
                        reviewCount: 12,
                        pricePerNight: 4500,
                        imageUrl: item.propertyImage,
                        friendNote: 'Added recently',
                        friendAvatarColor: AppColors.navy,
                        onTap: () {
                          final p = Property(
                            name: item.propertyName,
                            area: 'North Coast',
                            image: item.propertyImage,
                            price: 4500,
                            rating: 4.8,
                            reviews: 12,
                          );
                          AppNavigation.goToPropertyDetail(context, extra: p);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
