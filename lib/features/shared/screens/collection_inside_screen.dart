import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/pull_to_refresh.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/shared/widgets/collab_card.dart';

import '../properties/domain/entities/property.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';

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
  /// Listing details per property id. A saved item only stores the id, name
  /// and cover photo, so area, price and rating are fetched once per listing.
  final Map<String, Property> _details = {};
  final Set<String> _requested = {};

  void _ensureDetails(List<WishlistItem> items) {
    for (final item in items) {
      final id = item.propertyId;
      if (id.isEmpty || !_requested.add(id)) continue;
      sl<RenterRepository>().getProperty(id).then((property) {
        if (mounted) setState(() => _details[id] = property);
      }).catchError((Object _) {
        // Keeps the saved name and photo; the missing values show as "—".
      });
    }
  }

  /// The listing to compare: its fetched details, else what the item saved.
  Property _propertyFor(WishlistItem item) =>
      _details[item.propertyId] ??
      Property(
          id: item.propertyId,
          name: item.propertyName,
          area: '',
          image: item.propertyImage,
          price: 0,
          rating: 0,
          reviews: 0);

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
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _ensureDetails(collectionItems));

          return PullToRefresh(
            onRefresh: () => context
                .read<WishlistCubit>()
                .loadCollections(RoleState().currentRole),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              children: [
                TopBar(
                  title: widget.collectionName,
                  subtitle:
                      '${collectionItems.length == 1 ? '1 place' : '${collectionItems.length} places'}'
                      '${widget.sharedWithCount > 0 ? ' · shared with ${widget.sharedWithCount}' : ''}',
                ),
                const SizedBox(height: 12),
                if (widget.memberNames.isNotEmpty) ...[
                  Row(children: [
                    SizedBox(
                      width: (widget.memberNames.length > 3
                                  ? 4
                                  : widget.memberNames.length) *
                              18.0 +
                          20,
                      height: 28,
                      child: Stack(children: [
                        for (var i = 0;
                            i <
                                (widget.memberNames.length > 3
                                    ? 3
                                    : widget.memberNames.length);
                            i++)
                          Positioned(
                            left: i * 18.0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: null,
                                gradient: LinearGradient(colors: [
                                  [
                                    const Color(0xFF7FA8BF),
                                    const Color(0xFFD8B98A),
                                    const Color(0xFFC9A84C)
                                  ][i % 3],
                                  const Color(0xFF2C5066),
                                ]),
                              ),
                            ),
                          ),
                        if (widget.memberNames.length > 3)
                          Positioned(
                            left: 54,
                            child: Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.navy,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text('+${widget.memberNames.length - 3}',
                                  style: AppTheme.dm(
                                      size: 9,
                                      weight: FontWeight.w700,
                                      color: Colors.white)),
                            ),
                          ),
                      ]),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.memberNames.length > 2
                          ? 'You, ${widget.memberNames[0]}, ${widget.memberNames[1]} & ${widget.memberNames.length - 2} more'
                          : 'Shared with ${widget.memberNames.join(", ")}',
                      style: AppTheme.dm(size: 12, color: AppColors.muted),
                    ),
                  ]),
                  const SizedBox(height: 14),
                ],
                Row(children: [
                  Expanded(
                      child: WideButton(
                          label: 'Chat',
                          icon: Icons.chat_bubble_outline,
                          color: AppColors.navy,
                          height: 42,
                          onTap: () =>
                              AppNavigation.goToCollectionChat(context, extra: {
                                'collectionId': widget.collectionId,
                                'collectionName': widget.collectionName,
                                'participantNames': widget.memberNames,
                                'propertyA': collectionItems.isNotEmpty
                                    ? _propertyFor(collectionItems[0])
                                    : null,
                                'propertyB': collectionItems.length > 1
                                    ? _propertyFor(collectionItems[1])
                                    : null,
                              }))),
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
                                : '';

                            AppNavigation.goToShareCollection(
                              context,
                              collectionId: widget.collectionId,
                              collectionName: widget.collectionName,
                              collectionImage: cover,
                              placesCount: collectionItems.length,
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
                          onTap: () {
                            // Compare the first two saved listings by default.
                            final pA = collectionItems.isNotEmpty
                                ? _propertyFor(collectionItems[0])
                                : null;
                            final pB = collectionItems.length > 1
                                ? _propertyFor(collectionItems[1])
                                : null;

                            AppNavigation.goToCompare(
                              context,
                              collectionName: widget.collectionName,
                              collectionId: widget.collectionId,
                              memberNames: widget.memberNames,
                              propertyA: pA,
                              propertyB: pB,
                            );
                          })),
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
                      final prop = _details[item.propertyId];
                      final name = item.propertyName.isNotEmpty
                          ? item.propertyName
                          : prop?.name ?? '';
                      final image = item.propertyImage.isNotEmpty
                          ? item.propertyImage
                          : prop?.image ?? '';

                      return GestureDetector(
                        onTap: () {
                          AppNavigation.goToProperty(context, extra: {
                            'id': item.propertyId,
                            'name': name,
                            'imageUrl': image,
                            'location': prop?.area ?? '',
                            'rating': prop?.rating ?? 0,
                            'reviews': prop?.reviews ?? 0,
                            'price': prop?.price ?? 0,
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CollabCard(
                            image: image,
                            name: name,
                            loc: prop?.area ?? '',
                            tags: prop == null
                                ? const []
                                : [prop.type, ...prop.tags],
                            pet: prop != null && prop.petsOk ? '🐾 Pets' : '',
                            petOk: prop?.petsOk ?? false,
                            rating: prop == null
                                ? '—'
                                : prop.rating.toStringAsFixed(1),
                            reviews: prop == null ? '—' : '${prop.reviews}',
                            price: prop == null ? '—' : 'EGP ${prop.price}',
                            comment: 'Added to your wishlist',
                            onCompareTap: () {
                              AppNavigation.goToCompare(
                                context,
                                collectionName: widget.collectionName,
                                collectionId: widget.collectionId,
                                memberNames: widget.memberNames,
                                propertyA: _propertyFor(item),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
