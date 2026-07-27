import 'package:flutter/foundation.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/domain/models/wishlist_item.dart';

class WishlistRepository {
  // Data isolated by Role
  final Map<Role, Map<String, WishlistItem>> _wishlistItemsByRole = {
    Role.renter: {},
    Role.owner: {},
    Role.broker: {},
  };

  final Map<Role, List<WishlistCollection>> _collectionsByRole = {
    Role.renter: [
      const WishlistCollection(id: 'all_saved', name: 'All Saved', itemCount: 0),
    ],
    Role.owner: [
      const WishlistCollection(id: 'all_saved', name: 'All Saved', itemCount: 0),
    ],
    Role.broker: [
      const WishlistCollection(id: 'all_saved', name: 'All Saved', itemCount: 0),
    ],
  };

  Future<bool> isWishlisted(String propertyId, Role role) async {
    return _wishlistItemsByRole[role]?.containsKey(propertyId) ?? false;
  }

  Future<void> addToWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    required Role role,
    String? collectionId,
  }) async {
    final targetCollection = collectionId ?? 'all_saved';

    final item = WishlistItem(
      propertyId: propertyId,
      propertyName: propertyName,
      propertyImage: propertyImage,
      collectionIds: [targetCollection],
      addedAt: DateTime.now(),
    );

    _wishlistItemsByRole[role]![propertyId] = item;
    _updateCollectionCount(targetCollection, 1, role,
        coverImage: propertyImage);
  }

  Future<void> removeFromWishlist(String propertyId, Role role) async {
    final item = _wishlistItemsByRole[role]?[propertyId];
    if (item != null) {
      for (var colId in item.collectionIds) {
        _updateCollectionCount(colId, -1, role);
      }
      _wishlistItemsByRole[role]!.remove(propertyId);
    }
  }

  Future<bool> toggleWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    required Role role,
  }) async {
    if (await isWishlisted(propertyId, role)) {
      await removeFromWishlist(propertyId, role);
      return false;
    } else {
      await addToWishlist(
          propertyId: propertyId,
          propertyName: propertyName,
          propertyImage: propertyImage,
          role: role);
      return true;
    }
  }

  Future<void> addCollection(String name, Role role) async {
    final newCol = WishlistCollection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      itemCount: 0,
    );
    _collectionsByRole[role]!.add(newCol);
  }

  void _updateCollectionCount(String id, int delta, Role role,
      {String? coverImage}) {
    final collections = _collectionsByRole[role]!;
    final index = collections.indexWhere((c) => c.id == id);
    if (index != -1) {
      final c = collections[index];
      collections[index] = WishlistCollection(
        id: c.id,
        name: c.name,
        itemCount: (c.itemCount + delta).clamp(0, 999),
        coverImage: delta > 0
            ? (coverImage ?? c.coverImage)
            : (c.itemCount + delta > 0 ? c.coverImage : null),
        isShared: c.isShared,
      );
    }
  }

  Future<List<WishlistCollection>> getCollections(Role role) async {
    return _collectionsByRole[role] ?? [];
  }

  Future<void> addToCollection({
    required String propertyId,
    required String collectionId,
    required Role role,
  }) async {
    final item = _wishlistItemsByRole[role]?[propertyId];
    if (item != null) {
      final updatedCollections = List<String>.from(item.collectionIds);
      if (!updatedCollections.contains(collectionId)) {
        updatedCollections.add(collectionId);
        _wishlistItemsByRole[role]![propertyId] =
            item.copyWith(collectionIds: updatedCollections);
        _updateCollectionCount(collectionId, 1, role,
            coverImage: item.propertyImage);
      }
    }
  }

  Future<List<WishlistItem>> getWishlistItems(
      String collectionId, Role role) async {
    return _wishlistItemsByRole[role]!
        .values
        .where((item) => item.collectionIds.contains(collectionId))
        .toList();
  }

  Future<List<WishlistItem>> getAllWishlistItems(Role role) async {
    return _wishlistItemsByRole[role]!.values.toList();
  }
}
