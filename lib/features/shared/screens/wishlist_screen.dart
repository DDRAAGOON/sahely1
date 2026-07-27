import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/broker/presentation/screens/wishlist/bloc/broker_wishlist_cubit.dart';
import 'package:sahely/features/broker/presentation/screens/wishlist/pages/broker_collection_inside_page.dart';
import 'package:sahely/features/broker/presentation/screens/wishlist/widgets/broker_wishlist_widgets.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/create_collection_sheet.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/new_collection_tile.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/wishlist_collection_card.dart';

/// Enum for the user role to customize the wishlist screen.
enum WishlistRole { renter, owner, broker }

/// Unified Wishlist Screen shared across Renter, Owner, and Broker roles.
class WishlistScreen extends StatefulWidget {
  final bool showNav;
  final WishlistRole role;

  const WishlistScreen(
      {super.key, this.showNav = true, this.role = WishlistRole.renter});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.role == WishlistRole.broker) {
      context.read<BrokerWishlistCubit>().loadCollections();
    } else {
      context.read<WishlistCubit>().loadCollections();
    }
  }

  Future<void> _createNewCollection() async {
    if (widget.role == WishlistRole.broker) {
      final result = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: AppColors.cream,
        isScrollControlled: true,
        builder: (context) => const BrokerCreateCollectionSheet(),
      );

      if (result != null && result.isNotEmpty && mounted) {
        context.read<BrokerWishlistCubit>().createCollection(result);
      }
    } else {
      final result = await showModalBottomSheet<String>(
        context: context,
        useRootNavigator: true,
        backgroundColor: AppColors.cream,
        isScrollControlled: true,
        builder: (context) => const CreateCollectionSheet(),
      );

      if (result != null && result.isNotEmpty && mounted) {
        context.read<WishlistCubit>().createCollection(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBroker = widget.role == WishlistRole.broker;
    final title = isBroker ? 'Broker Wishlist' : 'Wishlist';

    if (isBroker) {
      return _buildBrokerView(context);
    }
    return _buildRenterOwnerView(context, title);
  }

  Widget _buildRenterOwnerView(BuildContext context, String title) {
    return Container(
      color: AppColors.cream,
      child: SafeArea(
        child: BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, state) {
            if (state.status == WishlistStatus.loading &&
                state.collections.isEmpty) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.gold));
            }

            final collections = state.collections;
            final totalPlaces =
                collections.fold<int>(0, (sum, col) => sum + (col.itemCount));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                  fontFamily: 'DM Sans')),
                          const SizedBox(height: 4),
                          Text('$totalPlaces properties',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.secondary,
                                  fontFamily: 'DM Sans')),
                        ],
                      ),
                      GestureDetector(
                        onTap: _createNewCollection,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: AppColors.navy,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: AppColors.gold, size: 18),
                              SizedBox(width: 6),
                              Text('New',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                      fontFamily: 'DM Sans')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.1),
                      itemCount: collections.length + 1,
                      itemBuilder: (context, index) {
                        if (index == collections.length) {
                          return NewCollectionTile(onTap: _createNewCollection);
                        }
                        final collection = collections[index];
                        return GestureDetector(
                          onTap: () {
                            AppNavigation.goToCollection(context, extra: {
                              'collectionId': collection.id,
                              'collectionName': collection.name,
                              'propertyCount': collection.itemCount,
                              'sharedWithCount': collection.isShared ? 3 : 0,
                              'memberNames': const ['Omar', 'Nour', 'Youssef'],
                            });
                          },
                          child: WishlistCollectionCard(
                            name: collection.name,
                            count: collection.itemCount,
                            coverImage: collection.coverImage,
                            isShared: collection.isShared,
                            sharedWith: collection.isShared ? 3 : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrokerView(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: SafeArea(
        child: BlocBuilder<BrokerWishlistCubit, BrokerWishlistState>(
          builder: (context, state) {
            if (state.status == BrokerWishlistStatus.loading &&
                state.collections.isEmpty) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.gold));
            }

            final collections = state.collections;
            final totalPlaces =
                collections.fold<int>(0, (sum, col) => sum + col.itemCount);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Broker Wishlist',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$totalPlaces properties',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.secondary,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _createNewCollection,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: AppColors.navy,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: AppColors.gold, size: 18),
                              SizedBox(width: 6),
                              Text('New',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                      fontFamily: 'DM Sans')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: collections.length + 1,
                      itemBuilder: (context, index) {
                        if (index == collections.length) {
                          return BrokerNewCollectionTile(
                              onTap: _createNewCollection);
                        }
                        final collection = collections[index];
                        return GestureDetector(
                          onTap: () {
                            AppNavigation.safePush(context, '/broker/collection',
                                extra: {
                                  'collectionId': collection.id,
                                  'collectionName': collection.name,
                                  'propertyCount': collection.itemCount,
                                  'sharedWithCount': collection.isShared ? 3 : 0,
                                  'memberNames': const [
                                    'Omar',
                                    'Nour',
                                    'Youssef'
                                  ],
                                });
                          },
                          child: BrokerWishlistCollectionCard(
                            name: collection.name,
                            count: collection.itemCount,
                            coverImage: collection.coverImage,
                            isShared: collection.isShared,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
