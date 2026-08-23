import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/create_collection_sheet.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/new_collection_tile.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/wishlist_collection_card.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';
import 'package:sahely/core/theme/app_theme.dart';

/// Unified Wishlist Screen shared across Renter, Owner, and Broker roles.
class WishlistScreen extends StatefulWidget {
  final bool showNav;
  final Role role;

  const WishlistScreen(
      {super.key, this.showNav = true, this.role = Role.renter});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().loadCollections(widget.role);
  }

  Future<void> _createNewCollection() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      backgroundColor: AppColors.cream,
      isScrollControlled: true,
      builder: (context) => const CreateCollectionSheet(),
    );

    if (result != null && result.isNotEmpty && mounted) {
      context.read<WishlistCubit>().createCollection(result, widget.role);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.role == Role.broker ? 'Broker Wishlist' : 'Wishlist';

    return Container(
      color: AppColors.cream,
      child: SafeArea(
        child: EntranceFaded(
          child: BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              if (state.status == WishlistStatus.loading &&
                  state.collections.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold));
              }

              final collections = state.collections.where((c) {
                if (c.id == 'all_saved') return c.itemCount > 0;
                return true;
              }).toList();
              
              final totalPlaces =
                  state.collections.fold<int>(0, (sum, col) => sum + (col.itemCount));

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
                                style: AppTheme.dm(
                                    size: 22,
                                    weight: FontWeight.w700,
                                    color: AppColors.navy)),
                            const SizedBox(height: 4),
                            Text('$totalPlaces properties',
                                style: AppTheme.dm(
                                    size: 13,
                                    color: AppColors.secondary)),
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add, color: AppColors.gold, size: 18),
                                const SizedBox(width: 6),
                                Text('New',
                                    style: AppTheme.dm(
                                        size: 13,
                                        weight: FontWeight.w600,
                                        color: AppColors.white)),
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
                              if (widget.role == Role.broker) {
                                 AppNavigation.safePush(context, '/broker/collection',
                                  extra: {
                                    'collectionId': collection.id,
                                    'collectionName': collection.name,
                                    'propertyCount': collection.itemCount,
                                    'sharedWithCount': collection.members.length,
                                    'memberNames': collection.members,
                                  });
                              } else {
                                  AppNavigation.goToCollection(context, extra: {
                                    'collectionId': collection.id,
                                    'collectionName': collection.name,
                                    'propertyCount': collection.itemCount,
                                    'sharedWithCount': collection.members.length,
                                    'memberNames': collection.members,
                                  });
                              }
                            },
                            child: WishlistCollectionCard(
                              name: collection.name,
                              count: collection.itemCount,
                              coverImage: collection.coverImage,
                              isShared: collection.isShared || collection.members.isNotEmpty,
                              sharedWith: collection.members.isNotEmpty ? collection.members.length : null,
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
      ),
    );
  }
}
