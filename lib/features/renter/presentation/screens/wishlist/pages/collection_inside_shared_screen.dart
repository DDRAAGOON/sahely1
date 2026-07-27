import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/domain/models/wishlist_item.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/collection_header.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/collection_members_actions.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/collection_property_card.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/share_collection_sheet.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/pages/collection_compare_screen.dart';

class CollectionInsideSharedScreen extends StatefulWidget {
  final String collectionId;
  final String collectionName;
  final int propertyCount;
  final int sharedWithCount;
  final List<String> memberNames;

  const CollectionInsideSharedScreen({
    super.key,
    required this.collectionId,
    required this.collectionName,
    required this.propertyCount,
    required this.sharedWithCount,
    required this.memberNames,
  });

  @override
  State<CollectionInsideSharedScreen> createState() =>
      _CollectionInsideSharedScreenState();
}

class _CollectionInsideSharedScreenState
    extends State<CollectionInsideSharedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().loadWishlistItems(widget.collectionId);
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
            CollectionHeader(
              collectionName: widget.collectionName,
              propertyCount: widget.propertyCount,
              sharedWithCount: widget.sharedWithCount,
              onBackTap: () => Navigator.pop(context),
            ),

            // Members & Actions
            CollectionMembersActions(
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

                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => ShareCollectionSheet(
                    collectionName: widget.collectionName,
                    collectionImage: collection.coverImage ?? '',
                    placesCount: collection.itemCount,
                    shareableLink:
                        'sahely.app/c/${widget.collectionName.toLowerCase().replaceAll(' ', '-')}',
                    isInviteOnly: false,
                  ),
                );
              },
              onCompareTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CollectionCompareScreen(
                      collectionName: widget.collectionName,
                      participantNames: widget.memberNames,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Property List
            Expanded(
              child: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  if (state is WishlistLoading) {
                    return const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.gold));
                  }

                  if (state is WishlistItemsLoaded) {
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
                            const Text(
                              'No properties in this collection yet',
                              style: TextStyle(
                                  color: AppColors.secondary,
                                  fontFamily: 'DM Sans'),
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
                        return CollectionPropertyCard(
                          propertyName: item.propertyName,
                          location: 'North Coast, Egypt',
                          // Default if not in model
                          propertyType: 'Villa',
                          // Default
                          beds: 3,
                          // Default
                          amenities: const ['Pool', 'WiFi'],
                          rating: 4.8,
                          reviewCount: 12,
                          pricePerNight: 4500,
                          imageUrl: item.propertyImage,
                          friendNote: 'Added recently',
                          friendAvatarColor: AppColors.navy,
                          onTap: () {
                            AppNavigation.goToPropertyDetail(context, extra: {
                              'id': item.propertyId,
                              'name': item.propertyName,
                              'imageUrl': item.propertyImage,
                              'location': 'North Coast',
                              'rating': 4.8,
                              'reviewCount': 12,
                              'price': 4500,
                            });
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
