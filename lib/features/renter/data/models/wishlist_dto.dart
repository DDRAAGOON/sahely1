import 'package:equatable/equatable.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';

class WishlistItemDto extends Equatable {
  final String propertyId;
  final String propertyName;
  final String propertyImage;
  final List<String> collectionIds;
  final DateTime addedAt;

  const WishlistItemDto({
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    required this.collectionIds,
    required this.addedAt,
  });

  factory WishlistItemDto.fromJson(Map<String, dynamic> json) {
    return WishlistItemDto(
      propertyId: json['propertyId'] as String,
      propertyName: json['propertyName'] as String,
      propertyImage: json['propertyImage'] as String,
      collectionIds: List<String>.from(json['collectionIds'] as List),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'propertyName': propertyName,
      'propertyImage': propertyImage,
      'collectionIds': collectionIds,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  WishlistItem toEntity() {
    return WishlistItem(
      propertyId: propertyId,
      propertyName: propertyName,
      propertyImage: propertyImage,
      collectionIds: collectionIds,
      addedAt: addedAt,
    );
  }

  factory WishlistItemDto.fromEntity(WishlistItem entity) {
    return WishlistItemDto(
      propertyId: entity.propertyId,
      propertyName: entity.propertyName,
      propertyImage: entity.propertyImage,
      collectionIds: entity.collectionIds,
      addedAt: entity.addedAt,
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

class WishlistCollectionDto extends Equatable {
  final String id;
  final String name;
  final int itemCount;
  final String? coverImage;
  final bool isShared;
  final List<String> members;

  const WishlistCollectionDto({
    required this.id,
    required this.name,
    required this.itemCount,
    this.coverImage,
    this.isShared = false,
    this.members = const [],
  });

  factory WishlistCollectionDto.fromJson(Map<String, dynamic> json) {
    return WishlistCollectionDto(
      id: json['id'] as String,
      name: json['name'] as String,
      itemCount: json['itemCount'] as int,
      coverImage: json['coverImage'] as String?,
      isShared: json['isShared'] as bool? ?? false,
      members: List<String>.from(json['members'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'itemCount': itemCount,
      'coverImage': coverImage,
      'isShared': isShared,
      'members': members,
    };
  }

  WishlistCollection toEntity() {
    return WishlistCollection(
      id: id,
      name: name,
      itemCount: itemCount,
      coverImage: coverImage,
      isShared: isShared,
      members: members,
    );
  }

  factory WishlistCollectionDto.fromEntity(WishlistCollection entity) {
    return WishlistCollectionDto(
      id: entity.id,
      name: entity.name,
      itemCount: entity.itemCount,
      coverImage: entity.coverImage,
      isShared: entity.isShared,
      members: entity.members,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, itemCount, coverImage, isShared, members];
}
