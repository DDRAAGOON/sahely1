import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../bloc/broker_wishlist_cubit.dart';
import '../widgets/broker_wishlist_widgets.dart';
import 'broker_collection_inside_page.dart';

class BrokerWishlistPage extends StatefulWidget {
  const BrokerWishlistPage({super.key});

  @override
  State<BrokerWishlistPage> createState() => _BrokerWishlistPageState();
}

class _BrokerWishlistPageState extends State<BrokerWishlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<BrokerWishlistCubit>().loadCollections();
  }

  Future<void> _createNewCollection() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const BrokerCreateCollectionSheet(),
    );

    if (result != null && result.isNotEmpty && mounted) {
      context.read<BrokerWishlistCubit>().createCollection(result);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${collections.length} collections · $totalPlaces properties',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.secondary,
                              fontFamily: 'Cairo',
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
                              Text(
                                'New',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                  fontFamily: 'Cairo',
                                ),
                              ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BrokerCollectionInsidePage(
                                  collectionId: collection.id,
                                  collectionName: collection.name,
                                  propertyCount: collection.itemCount,
                                  sharedWithCount: collection.isShared ? 3 : 0,
                                  memberNames: const [
                                    'Omar',
                                    'Nour',
                                    'Youssef'
                                  ],
                                ),
                              ),
                            );
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
