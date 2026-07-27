import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/shared/widgets/collab_card.dart';

class CollectionInsideScreen extends StatefulWidget {
  final String collectionId;
  final String collectionName;
  final int sharedWithCount;
  final List<String> memberNames;

  const CollectionInsideScreen({
    super.key,
    this.collectionId = 'all_saved',
    this.collectionName = 'All Saved',
    this.sharedWithCount = 0,
    this.memberNames = const [],
  });

  @override
  State<CollectionInsideScreen> createState() => _CollectionInsideScreenState();
}

class _CollectionInsideScreenState extends State<CollectionInsideScreen> {
  @override
  void initState() {
    super.initState();
    // Load all items fresh when this screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final role = RoleState().currentRole;
        context.read<WishlistCubit>().loadCollections(role);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          final collectionItems = state.items
              .where((i) => i.collectionIds.contains(widget.collectionId))
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            children: [
              TopBar(
                title: widget.collectionName,
                subtitle:
                    '${collectionItems.length} places${widget.sharedWithCount > 0 ? ' · shared with ${widget.sharedWithCount}' : ''}',
              ),
              const SizedBox(height: 12),
              Row(children: [
                SizedBox(
                  width: 92,
                  height: 28,
                  child: Stack(children: [
                    for (var i = 0; i < 3; i++)
                      Positioned(
                        left: i * 18.0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            gradient: LinearGradient(colors: [
                              const [
                                Color(0xFF7FA8BF),
                                Color(0xFFD8B98A),
                                Color(0xFFC9A84C)
                              ][i],
                              const Color(0xFF2C5066),
                            ]),
                          ),
                        ),
                      ),
                    Positioned(
                      left: 54,
                      child: Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.navy,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text('+1',
                            style: AppTheme.dm(
                                size: 9,
                                weight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(width: 8),
                Text('You, Omar, Nour & 1 more',
                    style: AppTheme.dm(size: 12, color: AppColors.muted)),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                    child: WideButton(
                        label: 'Chat',
                        icon: Icons.chat_bubble_outline,
                        color: AppColors.navy,
                        height: 42,
                        onTap: () =>
                            AppNavigation.goToCollectionChat(context))),
                const SizedBox(width: 8),
                Expanded(
                    child: WideButton(
                        label: 'Share',
                        icon: Icons.link,
                        color: AppColors.gold,
                        textColor: AppColors.navy,
                        height: 42,
                        onTap: () {
                          final cover = collectionItems.isNotEmpty 
                            ? collectionItems.first.propertyImage 
                            : 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800';
                          
                          AppNavigation.goToShareCollection(
                            context,
                            collectionName: widget.collectionName,
                            collectionImage: cover,
                            placesCount: collectionItems.length,
                            shareableLink: 'sahely.app/c/${widget.collectionName.toLowerCase().replaceAll(' ', '-')}',
                          );
                        })),
                const SizedBox(width: 8),
                Expanded(
                    child: WideButton(
                        label: 'Compare',
                        icon: Icons.bar_chart,
                        color: AppColors.navy,
                        outline: true,
                        height: 42,
                        onTap: () => AppNavigation.goToCompare(
                          context,
                          collectionName: widget.collectionName,
                          memberNames: widget.memberNames.isNotEmpty ? widget.memberNames : const ['Omar', 'Nour', 'Youssef'],
                        ))),
              ]),
              const SizedBox(height: 16),
              if (collectionItems.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text('No places added yet.',
                        style: AppTheme.dm(color: AppColors.muted)),
                  ),
                )
              else
                Column(
                  children: collectionItems.map((item) {
                    final prop = Sample.allTrending
                            .where(
                              (p) =>
                                  p.name == item.propertyId ||
                                  p.image == item.propertyImage,
                            )
                            .firstOrNull ??
                        Sample.allTrending.first;

                    return GestureDetector(
                      onTap: () {
                        AppNavigation.goToProperty(context, extra: {
                          'id': prop.id,
                          'name': item.propertyName.isNotEmpty
                              ? item.propertyName
                              : prop.name,
                          'imageUrl': item.propertyImage.isNotEmpty
                              ? item.propertyImage
                              : prop.image,
                          'location': 'North Coast',
                          'rating': prop.rating,
                          'reviews': prop.reviews,
                          'price': prop.price,
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CollabCard(
                          image: item.propertyImage.isNotEmpty
                              ? item.propertyImage
                              : prop.image,
                          name: item.propertyName.isNotEmpty
                              ? item.propertyName
                              : prop.name,
                          loc: 'North Coast',
                          tags: const ['Villa', 'Pool'],
                          pet: '🐾 Pets',
                          petOk: true,
                          rating: prop.rating.toString(),
                          reviews: '124',
                          price: 'EGP ${prop.price}',
                          comment: 'Added to your wishlist',
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          );
        },
      ),
    );
  }
}
