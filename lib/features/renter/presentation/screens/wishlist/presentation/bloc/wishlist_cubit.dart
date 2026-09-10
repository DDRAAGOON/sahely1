import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';

import 'package:sahely/features/renter/domain/use_cases/get_wishlist_collections_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/get_wishlist_items_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/toggle_wishlist_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/add_to_wishlist_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/remove_from_wishlist_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/add_to_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/remove_from_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/create_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/rename_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/delete_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/check_wishlist_status_use_case.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';

enum WishlistStatus { initial, loading, loaded, error }

class WishlistState {
  final List<WishlistCollection> collections;
  final List<WishlistItem> items;
  final WishlistStatus status;
  final String? errorMessage;
  final String? toggledPropertyId;
  final bool? isToggledStatus;

  WishlistState({
    this.collections = const [],
    this.items = const [],
    this.status = WishlistStatus.initial,
    this.errorMessage,
    this.toggledPropertyId,
    this.isToggledStatus,
  });

  WishlistState copyWith({
    List<WishlistCollection>? collections,
    List<WishlistItem>? items,
    WishlistStatus? status,
    String? errorMessage,
    String? toggledPropertyId,
    bool? isToggledStatus,
  }) {
    return WishlistState(
      collections: collections ?? this.collections,
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage,
      toggledPropertyId: toggledPropertyId ?? this.toggledPropertyId,
      isToggledStatus: isToggledStatus ?? this.isToggledStatus,
    );
  }
}

class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlistCollectionsUseCase _getCollectionsUseCase;
  final GetWishlistItemsUseCase _getItemsUseCase;
  final ToggleWishlistUseCase _toggleUseCase;
  final AddToWishlistUseCase _addToWishlistUseCase;
  final AddToCollectionUseCase _addToCollectionUseCase;
  final CreateCollectionUseCase _createCollectionUseCase;
  final CheckWishlistStatusUseCase _checkStatusUseCase;

  WishlistCubit({
    required GetWishlistCollectionsUseCase getCollectionsUseCase,
    required GetWishlistItemsUseCase getItemsUseCase,
    required ToggleWishlistUseCase toggleUseCase,
    required AddToWishlistUseCase addToWishlistUseCase,
    required RemoveFromWishlistUseCase removeFromWishlistUseCase,
    required AddToCollectionUseCase addToCollectionUseCase,
    required RemoveFromCollectionUseCase removeFromCollectionUseCase,
    required CreateCollectionUseCase createCollectionUseCase,
    required RenameCollectionUseCase renameCollectionUseCase,
    required DeleteCollectionUseCase deleteCollectionUseCase,
    required CheckWishlistStatusUseCase checkStatusUseCase,
  })  : _getCollectionsUseCase = getCollectionsUseCase,
        _getItemsUseCase = getItemsUseCase,
        _toggleUseCase = toggleUseCase,
        _addToWishlistUseCase = addToWishlistUseCase,
        _addToCollectionUseCase = addToCollectionUseCase,
        _createCollectionUseCase = createCollectionUseCase,
        _checkStatusUseCase = checkStatusUseCase,
        super(WishlistState());

  Role get _activeRole => RoleState().currentRole;

  Future<void> checkStatus(String propertyId, [Role? role]) async {
    final targetRole = role ?? _activeRole;
    try {
      final isWishlisted = await _checkStatusUseCase.execute(propertyId, targetRole);
      emit(state.copyWith(
        toggledPropertyId: propertyId,
        isToggledStatus: isWishlisted,
        status: WishlistStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Error checking status'));
    }
  }

  Future<void> toggleWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    Role? role,
  }) async {
    final targetRole = role ?? _activeRole;
    try {
      await _toggleUseCase.execute(
        propertyId: propertyId,
        propertyName: propertyName,
        propertyImage: propertyImage,
        role: targetRole,
      );

      await loadCollections(targetRole);
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to toggle'));
    }
  }

  Future<void> updatePropertyCollections({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    required List<String> collectionIds,
    Role? role,
  }) async {
    final targetRole = role ?? _activeRole;
    try {
      final item = WishlistItem(
        propertyId: propertyId,
        propertyName: propertyName,
        propertyImage: propertyImage,
        collectionIds: collectionIds,
        addedAt: DateTime.now(),
      );

      // We need to handle counts for ALL collections involved.
      await _addToWishlistUseCase.repository.syncItemCollections(
        item,
        targetRole,
        collectionIds,
      );
      
      await loadCollections(targetRole);
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to update collections'));
    }
  }

  Future<void> saveToSpecificCollection({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    required String collectionId,
    Role? role,
  }) async {
    final targetRole = role ?? _activeRole;
    try {
      await _addToWishlistUseCase.execute(
        propertyId: propertyId,
        propertyName: propertyName,
        propertyImage: propertyImage,
        collectionId: collectionId,
        role: targetRole,
      );
      await loadCollections(targetRole);
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to save to collection'));
    }
  }

  Future<void> addToCollection({
    required String propertyId,
    required String collectionId,
    Role? role,
  }) async {
    final targetRole = role ?? _activeRole;
    try {
      await _addToCollectionUseCase.execute(
        propertyId: propertyId,
        collectionId: collectionId,
        role: targetRole,
      );
      await loadCollections(targetRole);
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to add to collection'));
    }
  }

  Future<void> createCollection(String name, [Role? role]) async {
    final targetRole = role ?? _activeRole;
    try {
      await _createCollectionUseCase.execute(name, targetRole);
      await loadCollections(targetRole);
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to create collection'));
    }
  }

  Future<void> loadCollections([Role? role]) async {
    final targetRole = role ?? _activeRole;
    emit(state.copyWith(status: WishlistStatus.loading));
    try {
      final collections = await _getCollectionsUseCase.execute(targetRole);
      final items = await _getItemsUseCase.execute(role: targetRole);

      emit(state.copyWith(
        collections: collections,
        items: items,
        status: WishlistStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to load collections'));
    }
  }

  Future<void> loadWishlistItems(String collectionId, [Role? role]) async {
    final targetRole = role ?? _activeRole;
    emit(state.copyWith(status: WishlistStatus.loading));
    try {
      final items = await _getItemsUseCase.execute(collectionId: collectionId, role: targetRole);
      emit(state.copyWith(items: items, status: WishlistStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to load wishlist items'));
    }
  }
}
