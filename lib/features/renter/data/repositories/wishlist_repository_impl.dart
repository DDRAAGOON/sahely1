import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/data/datasources/mock_wishlist_data_source.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';
import 'package:sahely/features/renter/domain/repositories/wishlist_repository.dart';
import 'package:sahely/features/renter/data/models/wishlist_dto.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final MockWishlistDataSource dataSource;

  WishlistRepositoryImpl({required this.dataSource});

  @override
  Future<bool> isWishlisted(String propertyId, Role role) async {
    try {
      final item = await dataSource.getItem(propertyId, role);
      return item != null;
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> saveWishlistItem(WishlistItem item, Role role, String collectionId) async {
    try {
      final dto = WishlistItemDto.fromEntity(item);
      await dataSource.saveItem(dto, role);
      
      // Update collection metadata (count and cover image)
      final collections = await dataSource.getCollections(role);
      final index = collections.indexWhere((c) => c.id == collectionId);
      if (index != -1) {
        final c = collections[index];
        final updated = WishlistCollectionDto(
          id: c.id,
          name: c.name,
          itemCount: c.itemCount + 1,
          coverImage: dto.propertyImage,
          isShared: c.isShared,
        );
        await dataSource.saveCollection(updated, role);
      }
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> deleteWishlistItem(String propertyId, Role role) async {
    try {
      final item = await dataSource.getItem(propertyId, role);
      if (item != null) {
        await dataSource.deleteItem(propertyId, role);
        
        // Update counts for all collections this item was in
        final collections = await dataSource.getCollections(role);
        for (var colId in item.collectionIds) {
          final idx = collections.indexWhere((c) => c.id == colId);
          if (idx != -1) {
            final c = collections[idx];
            final updated = WishlistCollectionDto(
              id: c.id,
              name: c.name,
              itemCount: (c.itemCount - 1).clamp(0, 999),
              coverImage: c.coverImage,
              isShared: c.isShared,
            );
            await dataSource.saveCollection(updated, role);
          }
        }
      }
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> syncItemCollections(WishlistItem item, Role role, List<String> collectionIds) async {
    try {
      final oldItem = await dataSource.getItem(item.propertyId, role);
      final oldCollectionIds = oldItem?.collectionIds ?? [];

      final newItem = item.copyWith(collectionIds: collectionIds);
      final dto = WishlistItemDto.fromEntity(newItem);
      
      if (collectionIds.isEmpty) {
        await dataSource.deleteItem(item.propertyId, role);
      } else {
        await dataSource.saveItem(dto, role);
      }

      // Update counts for all collections
      final collections = await dataSource.getCollections(role);
      
      // Collections added
      final added = collectionIds.where((id) => !oldCollectionIds.contains(id));
      // Collections removed
      final removed = oldCollectionIds.where((id) => !collectionIds.contains(id));

      for (var id in added) {
        final idx = collections.indexWhere((c) => c.id == id);
        if (idx != -1) {
          final c = collections[idx];
          await dataSource.saveCollection(
            WishlistCollectionDto(
              id: c.id,
              name: c.name,
              itemCount: c.itemCount + 1,
              coverImage: dto.propertyImage,
              isShared: c.isShared,
            ),
            role,
          );
        }
      }

      for (var id in removed) {
        final idx = collections.indexWhere((c) => c.id == id);
        if (idx != -1) {
          final c = collections[idx];
          await dataSource.saveCollection(
            WishlistCollectionDto(
              id: c.id,
              name: c.name,
              itemCount: (c.itemCount - 1).clamp(0, 999),
              coverImage: c.coverImage,
              isShared: c.isShared,
            ),
            role,
          );
        }
      }
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> saveCollection(WishlistCollection collection, Role role) async {
    try {
      await dataSource.saveCollection(
        WishlistCollectionDto.fromEntity(collection),
        role,
      );
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<List<WishlistCollection>> getCollections(Role role) async {
    try {
      final dtos = await dataSource.getCollections(role);
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<WishlistItem?> getWishlistItem(String propertyId, Role role) async {
    try {
      final dto = await dataSource.getItem(propertyId, role);
      return dto?.toEntity();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<List<WishlistItem>> getWishlistItemsByCollection(
      String collectionId, Role role) async {
    try {
      final dtos = await dataSource.getAllItems(role);
      return dtos
          .where((dto) => dto.collectionIds.contains(collectionId))
          .map((dto) => dto.toEntity())
          .toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<List<WishlistItem>> getAllWishlistItems(Role role) async {
    try {
      final dtos = await dataSource.getAllItems(role);
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> removeFromCollection(String propertyId, String collectionId, Role role) async {
    try {
      final item = await dataSource.getItem(propertyId, role);
      if (item != null && item.collectionIds.contains(collectionId)) {
        final newIds = List<String>.from(item.collectionIds)..remove(collectionId);
        if (newIds.isEmpty) {
          await deleteWishlistItem(propertyId, role);
        } else {
          final updatedItem = WishlistItemDto(
            propertyId: item.propertyId,
            propertyName: item.propertyName,
            propertyImage: item.propertyImage,
            collectionIds: newIds,
            addedAt: item.addedAt,
          );
          await dataSource.saveItem(updatedItem, role);
          
          // Update count
          final collections = await dataSource.getCollections(role);
          final idx = collections.indexWhere((c) => c.id == collectionId);
          if (idx != -1) {
            final c = collections[idx];
            await dataSource.saveCollection(
              WishlistCollectionDto(
                id: c.id,
                name: c.name,
                itemCount: (c.itemCount - 1).clamp(0, 999),
                coverImage: c.coverImage,
                isShared: c.isShared,
              ),
              role,
            );
          }
        }
      }
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> renameCollection(String collectionId, String newName, Role role) async {
    try {
      final collections = await dataSource.getCollections(role);
      final idx = collections.indexWhere((c) => c.id == collectionId);
      if (idx != -1) {
        final c = collections[idx];
        await dataSource.saveCollection(
          WishlistCollectionDto(
            id: c.id,
            name: newName,
            itemCount: c.itemCount,
            coverImage: c.coverImage,
            isShared: c.isShared,
          ),
          role,
        );
      }
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> deleteCollection(String collectionId, Role role) async {
    try {
      await dataSource.deleteCollection(collectionId, role);
      
      // Remove collection reference from items
      final items = await dataSource.getAllItems(role);
      for (var item in items) {
        if (item.collectionIds.contains(collectionId)) {
          final newIds = List<String>.from(item.collectionIds)..remove(collectionId);
          if (newIds.isEmpty) {
            await dataSource.deleteItem(item.propertyId, role);
          } else {
            await dataSource.saveItem(
              WishlistItemDto(
                propertyId: item.propertyId,
                propertyName: item.propertyName,
                propertyImage: item.propertyImage,
                collectionIds: newIds,
                addedAt: item.addedAt,
              ),
              role,
            );
          }
        }
      }
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
