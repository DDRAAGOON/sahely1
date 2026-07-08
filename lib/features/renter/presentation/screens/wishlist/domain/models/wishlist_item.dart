class WishlistItem {
  final String propertyId;
  final String propertyName;
  final String propertyImage;
  final List<String> collectionIds;
  final DateTime addedAt;

  const WishlistItem({
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    required this.collectionIds,
    required this.addedAt,
  });

  WishlistItem copyWith({
    List<String>? collectionIds,
  }) {
    return WishlistItem(
      propertyId: propertyId,
      propertyName: propertyName,
      propertyImage: propertyImage,
      collectionIds: collectionIds ?? this.collectionIds,
      addedAt: addedAt,
    );
  }
}

class WishlistCollection {
  final String id;
  final String name;
  final int itemCount;
  final String? coverImage;
  final bool isShared;

  const WishlistCollection({
    required this.id,
    required this.name,
    required this.itemCount,
    this.coverImage,
    this.isShared = false,
  });
}
