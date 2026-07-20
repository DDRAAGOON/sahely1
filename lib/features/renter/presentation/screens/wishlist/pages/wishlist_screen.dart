import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../presentation/bloc/wishlist_cubit.dart';
import '../widgets/create_collection_sheet.dart';
import '../widgets/new_collection_tile.dart';
import '../widgets/wishlist_collection_card.dart';

class WishlistScreen extends StatefulWidget {
  final bool showNav;

  const WishlistScreen({super.key, this.showNav = true});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    // Always reload to get fresh items
    context.read<WishlistCubit>().loadCollections();
  }

  Future<void> _createNewCollection() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const CreateCollectionSheet(),
    );

    if (result != null && result.isNotEmpty && mounted) {
      context.read<WishlistCubit>().createCollection(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: SafeArea(
        child: BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, state) {
            // Only show loader if we have absolutely no data
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
                          const Text('Wishlist',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                  fontFamily: 'Cairo')),
                          const SizedBox(height: 4),
                          Text(
                              '${collections.length} collections · $totalPlaces properties',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.secondary,
                                  fontFamily: 'Cairo')),
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
                                      fontFamily: 'Cairo')),
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
}
