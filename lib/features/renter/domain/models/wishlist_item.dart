import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
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
    String? propertyId,
    String? propertyName,
    String? propertyImage,
    List<String>? collectionIds,
    DateTime? addedAt,
  }) {
    return WishlistItem(
      propertyId: propertyId ?? this.propertyId,
      propertyName: propertyName ?? this.propertyName,
      propertyImage: propertyImage ?? this.propertyImage,
      collectionIds: collectionIds ?? this.collectionIds,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  List<Object?> get props => [
        propertyId,
        propertyName,
        propertyImage,
        collectionIds,
        addedAt,
      ];
}

class WishlistCollection extends Equatable {
  final String id;
  final String name;
  final int itemCount;
  final String? coverImage;
  final bool isShared;
  final List<String> members;

  const WishlistCollection({
    required this.id,
    required this.name,
    required this.itemCount,
    this.coverImage,
    this.isShared = false,
    this.members = const [],
  });

  WishlistCollection copyWith({
    String? id,
    String? name,
    int? itemCount,
    String? coverImage,
    bool? isShared,
    List<String>? members,
  }) {
    return WishlistCollection(
      id: id ?? this.id,
      name: name ?? this.name,
      itemCount: itemCount ?? this.itemCount,
      coverImage: coverImage ?? this.coverImage,
      isShared: isShared ?? this.isShared,
      members: members ?? this.members,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, itemCount, coverImage, isShared, members];
}
