import '../../domain/models/wishlist_item.dart';

class WishlistRepository {
  // Real In-memory Data
  final Map<String, WishlistItem> _wishlistItems = {};
  final List<WishlistCollection> _collections = [
    const WishlistCollection(id: 'all_saved', name: 'All Saved', itemCount: 0),
    const WishlistCollection(id: 'beach_trip_2026', name: 'Beach Trip 2026', itemCount: 0, isShared: true),
    const WishlistCollection(id: 'family_villas', name: 'Family Villas', itemCount: 0),
  ];

  Future<bool> isWishlisted(String propertyId) async {
    return _wishlistItems.containsKey(propertyId);
  }

  Future<void> addToWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
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

    _wishlistItems[propertyId] = item;
    _updateCollectionCount(targetCollection, 1, coverImage: propertyImage);
  }

  Future<void> removeFromWishlist(String propertyId) async {
    final item = _wishlistItems[propertyId];
    if (item != null) {
      for (var colId in item.collectionIds) {
        _updateCollectionCount(colId, -1);
      }
      _wishlistItems.remove(propertyId);
    }
  }

  Future<bool> toggleWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
  }) async {
    if (_wishlistItems.containsKey(propertyId)) {
      await removeFromWishlist(propertyId);
      return false;
    } else {
      await addToWishlist(propertyId: propertyId, propertyName: propertyName, propertyImage: propertyImage);
      return true;
    }
  }

  Future<void> addCollection(String name) async {
    final newCol = WishlistCollection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      itemCount: 0,
    );
    _collections.add(newCol);
  }

  void _updateCollectionCount(String id, int delta, {String? coverImage}) {
    final index = _collections.indexWhere((c) => c.id == id);
    if (index != -1) {
      final c = _collections[index];
      _collections[index] = WishlistCollection(
        id: c.id,
        name: c.name,
        itemCount: (c.itemCount + delta).clamp(0, 999),
        coverImage: delta > 0 ? (coverImage ?? c.coverImage) : (c.itemCount + delta > 0 ? c.coverImage : null),
        isShared: c.isShared,
      );
    }
  }

  Future<List<WishlistCollection>> getCollections() async {
    return _collections;
  }

  Future<void> addToCollection({
    required String propertyId,
    required String collectionId,
  }) async {
    final item = _wishlistItems[propertyId];
    if (item != null) {
      final updatedCollections = List<String>.from(item.collectionIds);
      if (!updatedCollections.contains(collectionId)) {
        updatedCollections.add(collectionId);
        _wishlistItems[propertyId] = item.copyWith(collectionIds: updatedCollections);
        _updateCollectionCount(collectionId, 1, coverImage: item.propertyImage);
      }
    }
  }

  Future<List<WishlistItem>> getWishlistItems(String collectionId) async {
    return _wishlistItems.values.where((item) => item.collectionIds.contains(collectionId)).toList();
  }

  Future<List<WishlistItem>> getAllWishlistItems() async {
    return _wishlistItems.values.toList();
  }
}
