import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/collection_header.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/collection_members_actions.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/collection_property_card.dart';

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
    final role = RoleState().currentRole;
    context.read<WishlistCubit>().loadWishlistItems(widget.collectionId, role);
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

                AppNavigation.goToShareCollection(
                  context,
                  collectionName: widget.collectionName,
                  collectionImage: collection.coverImage ?? 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800',
                  placesCount: collection.itemCount,
                  shareableLink: 'sahely.app/c/${widget.collectionName.toLowerCase().replaceAll(' ', '-')}',
                );
              },
              onCompareTap: () {
                AppNavigation.goToCompare(
                  context,
                  collectionName: widget.collectionName,
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

                  if (state.status == WishlistStatus.loaded) {
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
                              style: AppTheme.dm(
                                  color: AppColors.secondary),
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
                          amenities: const ['Pool', 'Wi-Fi'],
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
