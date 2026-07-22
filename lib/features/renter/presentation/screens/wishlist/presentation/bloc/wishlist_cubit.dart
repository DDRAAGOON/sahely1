import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sahely/features/renter/presentation/screens/wishlist/data/repositories/wishlist_repository.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/domain/models/wishlist_item.dart';

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

// Fixed specialized states to use correct names and preserve all data
class WishlistStatusLoaded extends WishlistState {
  final String propertyId;
  final bool isWishlisted;

  WishlistStatusLoaded(
      this.propertyId, this.isWishlisted, WishlistState previousState)
      : super(
            toggledPropertyId: propertyId,
            isToggledStatus: isWishlisted,
            collections: previousState.collections,
            items: previousState.items,
            status: WishlistStatus.loaded);
}

class WishlistToggled extends WishlistState {
  final String propertyId;
  final bool isWishlisted;

  WishlistToggled(
      this.propertyId, this.isWishlisted, WishlistState previousState)
      : super(
            toggledPropertyId: propertyId,
            isToggledStatus: isWishlisted,
            collections: previousState.collections,
            items: previousState.items,
            status: WishlistStatus.loaded);
}

class CollectionsLoaded extends WishlistState {
  @override
  final List<WishlistCollection> collections;

  CollectionsLoaded(this.collections, WishlistState previousState)
      : super(
            collections: collections,
            items: previousState.items,
            toggledPropertyId: previousState.toggledPropertyId,
            isToggledStatus: previousState.isToggledStatus,
            status: WishlistStatus.loaded);
}

class WishlistItemsLoaded extends WishlistState {
  @override
  final List<WishlistItem> items;

  WishlistItemsLoaded(this.items, WishlistState previousState)
      : super(
            items: items,
            collections: previousState.collections,
            toggledPropertyId: previousState.toggledPropertyId,
            isToggledStatus: previousState.isToggledStatus,
            status: WishlistStatus.loaded);
}

class WishlistLoading extends WishlistState {
  WishlistLoading(WishlistState previousState)
      : super(
          status: WishlistStatus.loading,
          collections: previousState.collections,
          items: previousState.items,
          toggledPropertyId: previousState.toggledPropertyId,
          isToggledStatus: previousState.isToggledStatus,
        );
}

class WishlistError extends WishlistState {
  final String message;

  WishlistError(this.message, WishlistState previousState)
      : super(
          errorMessage: message,
          status: WishlistStatus.error,
          collections: previousState.collections,
          items: previousState.items,
          toggledPropertyId: previousState.toggledPropertyId,
          isToggledStatus: previousState.isToggledStatus,
        );
}

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _repository;

  WishlistCubit(this._repository) : super(WishlistState());

  Future<void> checkStatus(String propertyId) async {
    try {
      final isWishlisted = await _repository.isWishlisted(propertyId);
      emit(WishlistStatusLoaded(propertyId, isWishlisted, state));
    } catch (e) {
      emit(WishlistError('Error checking status', state));
    }
  }

  Future<void> toggleWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
  }) async {
    try {
      final isWishlisted = await _repository.toggleWishlist(
        propertyId: propertyId,
        propertyName: propertyName,
        propertyImage: propertyImage,
      );

      final collections = await _repository.getCollections();

      // Update our internal items list by doing a fresh fetch so UI responds
      final items = await _repository.getAllWishlistItems();

      // We manually construct a new WishlistState to update items along with the toggle
      final newState = state.copyWith(
        collections: collections,
        items: items, // Add this so CollectionInsideScreen gets the new item!
      );

      emit(WishlistToggled(propertyId, isWishlisted, newState));
    } catch (e) {
      emit(WishlistError('Failed to toggle', state));
    }
  }

  Future<void> saveToSpecificCollection({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    required String collectionId,
  }) async {
    try {
      await _repository.addToWishlist(
        propertyId: propertyId,
        propertyName: propertyName,
        propertyImage: propertyImage,
        collectionId: collectionId,
      );
      final collections = await _repository.getCollections();
      final items = await _repository.getAllWishlistItems();

      final newState = state.copyWith(collections: collections, items: items);
      emit(WishlistToggled(propertyId, true, newState));

      // We emit CollectionsLoaded to refresh the UI
      emit(CollectionsLoaded(collections, newState));
    } catch (e) {
      emit(WishlistError('Failed to save to collection', state));
    }
  }

  Future<void> addToCollection({
    required String propertyId,
    required String collectionId,
  }) async {
    try {
      await _repository.addToCollection(
        propertyId: propertyId,
        collectionId: collectionId,
      );
      await loadCollections();
    } catch (e) {
      emit(WishlistError('Failed to add to collection', state));
    }
  }

  Future<void> createCollection(String name) async {
    try {
      await _repository.addCollection(name);
      await loadCollections();
    } catch (e) {
      emit(WishlistError('Failed to create collection', state));
    }
  }

  Future<void> loadCollections() async {
    emit(WishlistLoading(state));
    try {
      final collections = await _repository.getCollections();
      final items = await _repository.getAllWishlistItems();

      final newState = state.copyWith(collections: collections, items: items);
      emit(CollectionsLoaded(collections, newState));
    } catch (e) {
      emit(WishlistError('Failed to load collections', state));
    }
  }

  Future<void> loadWishlistItems(String collectionId) async {
    emit(WishlistLoading(state));
    try {
      final items = await _repository.getWishlistItems(collectionId);
      emit(WishlistItemsLoaded(items, state));
    } catch (e) {
      emit(WishlistError('Failed to load wishlist items', state));
    }
  }
}
