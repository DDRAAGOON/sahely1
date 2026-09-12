import 'package:sahely/core/errors/exception_mapper.dart';
import 'package:sahely/core/errors/failures.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/data/datasources/renter_api_data_source.dart';
import 'package:sahely/features/renter/data/datasources/wishlist_local_data_source.dart';
import 'package:sahely/features/renter/data/datasources/wishlist_api_data_source.dart';
import 'package:sahely/features/renter/data/models/wishlist_dto.dart';
import 'package:sahely/features/renter/domain/constants/wishlist_constants.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';
import 'package:sahely/features/renter/domain/repositories/wishlist_repository.dart';

/// Wishlist repository.
///
/// The collections **and everything inside them** live on the backend
/// (`/wishlists/*`), so the same account sees the same saved listings on the
/// web and on the phone. The local store is only a cache: it is refreshed
/// from every server read and answers while the device is offline.
///
/// Each read pulls the collection list and then each collection's listings,
/// which the whole wishlist UI needs at once, so the result is kept as a
/// snapshot for the duration of a screen and dropped after every change.
class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource dataSource;
  final WishlistApiDataSource apiDataSource;
  final RenterApiDataSource propertiesApi;

  WishlistRepositoryImpl({
    required this.dataSource,
    WishlistApiDataSource? api,
    RenterApiDataSource? properties,
    ApiClient? apiClient,
  })  : apiDataSource = api ?? WishlistApiDataSource(apiClient ?? ApiClient()),
        propertiesApi =
            properties ?? RenterApiDataSource(apiClient ?? ApiClient());

  List<_RemoteCollection>? _snapshot;

  // -- Reads -------------------------------------------------------------------

  @override
  Future<List<WishlistCollection>> getCollections(Role role) async {
    try {
      final remote = await _collections(role);
      if (remote != null) {
        return remote.map((c) => c.dto.toEntity()).toList();
      }
      final cached = await dataSource.getCollections(role);
      return cached.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<List<WishlistItem>> getAllWishlistItems(Role role) async {
    try {
      final remote = await _collections(role);
      if (remote != null) return _items(remote);
      final cached = await dataSource.getAllItems(role);
      return cached.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<List<WishlistItem>> getWishlistItemsByCollection(
      String collectionId, Role role) async {
    final all = await getAllWishlistItems(role);
    return all
        .where((item) => item.collectionIds.contains(collectionId))
        .toList();
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
  Future<bool> isWishlisted(String propertyId, Role role) async {
    try {
      final snapshot = _snapshot;
      if (snapshot != null) {
        return snapshot.any((c) => c.propertyIds.contains(propertyId));
      }
      return await dataSource.getItem(propertyId, role) != null;
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  // -- Writes ------------------------------------------------------------------

  @override
  Future<void> saveWishlistItem(
      WishlistItem item, Role role, String collectionId) async {
    try {
      final target = await _resolveCollectionId(collectionId, role);
      try {
        await apiDataSource.addProperty(target, item.propertyId);
      } catch (_) {
        // The collection was made for this save; without it the account
        // would be left with an empty duplicate.
        await _discardCreatedDefault(target);
        rethrow;
      }
      _invalidate();

      final existing = await dataSource.getItem(item.propertyId, role);
      final collections = {
        ...?existing?.collectionIds,
        ...item.collectionIds.map(
            (id) => id == WishlistConstants.allSavedCollectionId ? target : id),
        target,
      };
      await dataSource.saveItem(
        WishlistItemDto.fromEntity(
            item.copyWith(collectionIds: collections.toList())),
        role,
      );
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> deleteWishlistItem(String propertyId, Role role) async {
    try {
      // Un-hearting removes the listing from every collection that holds it,
      // which is what the filled heart stands for.
      final holders = await _collectionsHolding(propertyId, role);
      for (final collectionId in holders) {
        await apiDataSource.removeProperty(collectionId, propertyId);
      }
      _invalidate();
      await dataSource.deleteItem(propertyId, role);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> syncItemCollections(
      WishlistItem item, Role role, List<String> collectionIds) async {
    try {
      final wanted = <String>{
        for (final id in collectionIds) await _resolveCollectionId(id, role),
      };
      final current =
          (await _collectionsHolding(item.propertyId, role)).toSet();

      for (final id in wanted.difference(current)) {
        await apiDataSource.addProperty(id, item.propertyId);
      }
      for (final id in current.difference(wanted)) {
        await apiDataSource.removeProperty(id, item.propertyId);
      }
      _invalidate();

      if (wanted.isEmpty) {
        await dataSource.deleteItem(item.propertyId, role);
      } else {
        await dataSource.saveItem(
          WishlistItemDto.fromEntity(
              item.copyWith(collectionIds: wanted.toList())),
          role,
        );
      }
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> removeFromCollection(
      String propertyId, String collectionId, Role role) async {
    try {
      final target = await _resolveCollectionId(collectionId, role);
      await apiDataSource.removeProperty(target, propertyId);
      _invalidate();

      final item = await dataSource.getItem(propertyId, role);
      if (item == null) return;
      final remaining = List<String>.from(item.collectionIds)..remove(target);
      if (remaining.isEmpty) {
        await dataSource.deleteItem(propertyId, role);
      } else {
        await dataSource.saveItem(
          WishlistItemDto(
            propertyId: item.propertyId,
            propertyName: item.propertyName,
            propertyImage: item.propertyImage,
            collectionIds: remaining,
            addedAt: item.addedAt,
          ),
          role,
        );
      }
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> saveCollection(WishlistCollection collection, Role role) async {
    try {
      var dto = WishlistCollectionDto.fromEntity(collection);
      final existing = await dataSource.getCollections(role);
      final isNew = !existing.any((c) => c.id == collection.id);

      if (isNew) {
        // Adopt the server-generated id so later share/member calls address
        // the same collection the backend created.
        final remoteId = await apiDataSource.createCollection(collection.name);
        if (remoteId.isNotEmpty) {
          dto = WishlistCollectionDto(
            id: remoteId,
            name: dto.name,
            itemCount: dto.itemCount,
            coverImage: dto.coverImage,
            isShared: dto.isShared,
            members: dto.members,
          );
        }
      } else {
        await apiDataSource.renameCollection(collection.id, collection.name);
      }
      _invalidate();
      await dataSource.saveCollection(dto, role);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> renameCollection(
      String collectionId, String newName, Role role) async {
    try {
      await apiDataSource.renameCollection(collectionId, newName);
      _invalidate();

      final collections = await dataSource.getCollections(role);
      final index = collections.indexWhere((c) => c.id == collectionId);
      if (index != -1) {
        final c = collections[index];
        await dataSource.saveCollection(
          WishlistCollectionDto(
            id: c.id,
            name: newName,
            itemCount: c.itemCount,
            coverImage: c.coverImage,
            isShared: c.isShared,
            members: c.members,
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
      await apiDataSource.deleteCollection(collectionId);
      if (collectionId == _defaultCollectionId) {
        _forgetDefault();
      } else {
        _invalidate();
      }
      await dataSource.deleteCollection(collectionId, role);

      for (final item in await dataSource.getAllItems(role)) {
        if (!item.collectionIds.contains(collectionId)) continue;
        final remaining = List<String>.from(item.collectionIds)
          ..remove(collectionId);
        if (remaining.isEmpty) {
          await dataSource.deleteItem(item.propertyId, role);
        } else {
          await dataSource.saveItem(
            WishlistItemDto(
              propertyId: item.propertyId,
              propertyName: item.propertyName,
              propertyImage: item.propertyImage,
              collectionIds: remaining,
              addedAt: item.addedAt,
            ),
            role,
          );
        }
      }
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  // -- Server snapshot ---------------------------------------------------------

  void _invalidate() => _snapshot = null;

  /// Also forgets the default collection, e.g. after it is deleted.
  void _forgetDefault() {
    _defaultCollectionId = null;
    _invalidate();
  }

  /// Every collection with its listings, or `null` when the server could not
  /// be reached and the caller should fall back to the cache.
  Future<List<_RemoteCollection>?> _collections(Role role) async {
    final cached = _snapshot;
    if (cached != null) return cached;

    final List<Map<String, dynamic>> rows;
    try {
      rows = await apiDataSource.fetchCollections();
    } catch (_) {
      return null;
    }

    final collections = await Future.wait(rows.map(_fetchCollection));
    _snapshot = collections;
    await _cache(collections, role);
    return collections;
  }

  Future<_RemoteCollection> _fetchCollection(Map<String, dynamic> row) async {
    final id = '${row['id'] ?? ''}';
    var properties = const <Map<String, dynamic>>[];
    try {
      properties = await apiDataSource.fetchItems(id);
    } catch (_) {
      // A collection that cannot be opened still shows with its name.
    }

    // The wishlist payload carries no photos, so the cover comes from the
    // first listing itself — one request per collection, not per listing.
    var cover = '';
    if (properties.isNotEmpty) {
      try {
        final first = await propertiesApi.fetchProperty(
          '${properties.first['id'] ?? ''}',
        );
        cover = '${first['imageUrl'] ?? ''}';
      } catch (_) {
        // The card falls back to its placeholder.
      }
    }

    final memberCount = asNum(pick(row, 'member_count'))?.toInt() ?? 1;
    return _RemoteCollection(
      dto: WishlistCollectionDto(
        id: id,
        name: '${row['name'] ?? ''}',
        itemCount: properties.isNotEmpty
            ? properties.length
            : asNum(pick(row, 'property_count'))?.toInt() ?? 0,
        coverImage: cover.isEmpty ? null : cover,
        // Only `member_count` comes with the list; the member names need
        // GET /wishlists/:id/members, which the share screen fetches.
        isShared: memberCount > 1,
        members: const [],
      ),
      properties: properties,
    );
  }

  List<WishlistItem> _items(List<_RemoteCollection> collections) {
    final byProperty = <String, WishlistItem>{};
    for (final collection in collections) {
      for (final property in collection.properties) {
        final id = '${property['id'] ?? ''}';
        if (id.isEmpty) continue;
        final existing = byProperty[id];
        byProperty[id] = WishlistItem(
          propertyId: id,
          propertyName: '${property['title'] ?? ''}',
          propertyImage: existing?.propertyImage ?? '',
          collectionIds: [
            ...?existing?.collectionIds,
            collection.dto.id,
          ],
          addedAt: asDate(pick(property, 'created_at')) ?? DateTime.now(),
        );
      }
    }
    return byProperty.values.toList();
  }

  /// Mirrors the server state into the local store so the wishlist still
  /// renders, with the right contents, without a connection.
  Future<void> _cache(List<_RemoteCollection> collections, Role role) async {
    try {
      for (final stale in await dataSource.getCollections(role)) {
        if (collections.every((c) => c.dto.id != stale.id)) {
          await dataSource.deleteCollection(stale.id, role);
        }
      }
      for (final collection in collections) {
        await dataSource.saveCollection(collection.dto, role);
      }

      final items = _items(collections);
      final live = {for (final item in items) item.propertyId};
      for (final stale in await dataSource.getAllItems(role)) {
        if (!live.contains(stale.propertyId)) {
          await dataSource.deleteItem(stale.propertyId, role);
        }
      }
      for (final item in items) {
        final known = await dataSource.getItem(item.propertyId, role);
        await dataSource.saveItem(
          WishlistItemDto.fromEntity(
            // Keep a cover photo an earlier screen already resolved.
            known == null || known.propertyImage.isEmpty
                ? item
                : item.copyWith(propertyImage: known.propertyImage),
          ),
          role,
        );
      }
    } catch (_) {
      // The cache is best-effort; the screens render from the server read.
    }
  }

  /// The collections that currently hold [propertyId], server-side.
  Future<List<String>> _collectionsHolding(String propertyId, Role role) async {
    final remote = await _collections(role);
    if (remote != null) {
      return [
        for (final collection in remote)
          if (collection.propertyIds.contains(propertyId)) collection.dto.id,
      ];
    }
    final item = await dataSource.getItem(propertyId, role);
    return item?.collectionIds ?? const [];
  }

  /// The heart saves to "All Saved", which is a local placeholder, not a
  /// collection the backend knows. It maps to the account's own default
  /// collection, created once if the account has none.
  ///
  /// Resolution is shared between callers: two quick taps must not each
  /// create their own "Saved" collection.
  Future<String> _resolveCollectionId(String collectionId, Role role) {
    if (collectionId != WishlistConstants.allSavedCollectionId) {
      return Future.value(collectionId);
    }
    final known = _defaultCollectionId;
    if (known != null) return Future.value(known);
    return _resolving ??= _resolveDefault(role)
      ..whenComplete(() => _resolving = null);
  }

  Future<String> _resolveDefault(Role role) async {
    final remote = await _collections(role);
    if (remote == null) {
      // Without the server list a new collection could duplicate one that
      // already exists, so the save fails instead.
      throw const NetworkFailure('Your collections could not be loaded.');
    }

    for (final collection in remote) {
      if (collection.dto.name.trim().toLowerCase() == _defaultCollectionName) {
        return _defaultCollectionId = collection.dto.id;
      }
    }

    final created = await apiDataSource.createCollection('Saved');
    _invalidate();
    _createdDefaultId = created;
    return _defaultCollectionId = created;
  }

  /// The account's default collection for the heart, once found or created.
  String? _defaultCollectionId;

  /// The one this session created, so a failed save can take it back.
  String? _createdDefaultId;
  Future<String>? _resolving;

  /// Removes a default collection this session created, after the save it was
  /// created for failed.
  Future<void> _discardCreatedDefault(String collectionId) async {
    if (collectionId != _createdDefaultId) return;
    try {
      await apiDataSource.deleteCollection(collectionId);
    } catch (_) {
      // Leaving it is better than losing the original error.
    }
    _createdDefaultId = null;
    _forgetDefault();
  }

  static const _defaultCollectionName = 'saved';
}

/// One server collection together with the listings it holds.
class _RemoteCollection {
  _RemoteCollection({required this.dto, required this.properties});

  final WishlistCollectionDto dto;
  final List<Map<String, dynamic>> properties;

  late final Set<String> propertyIds = {
    for (final property in properties) '${property['id'] ?? ''}',
  };
}
