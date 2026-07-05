import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/wishlist_item.dart';
import '../../data/repositories/wishlist_repository.dart';

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
  WishlistStatusLoaded(this.propertyId, this.isWishlisted, List<WishlistCollection> collections) 
    : super(toggledPropertyId: propertyId, isToggledStatus: isWishlisted, collections: collections, status: WishlistStatus.loaded);
}

class WishlistToggled extends WishlistState {
  final String propertyId;
  final bool isWishlisted;
  WishlistToggled(this.propertyId, this.isWishlisted, List<WishlistCollection> collections) 
    : super(toggledPropertyId: propertyId, isToggledStatus: isWishlisted, collections: collections, status: WishlistStatus.loaded);
}

class CollectionsLoaded extends WishlistState {
  final List<WishlistCollection> collections;
  CollectionsLoaded(this.collections) : super(collections: collections, status: WishlistStatus.loaded);
}

class WishlistItemsLoaded extends WishlistState {
  final List<WishlistItem> items;
  WishlistItemsLoaded(this.items, List<WishlistCollection> collections) 
    : super(items: items, collections: collections, status: WishlistStatus.loaded);
}

class WishlistLoading extends WishlistState {
  WishlistLoading(List<WishlistCollection> collections) : super(status: WishlistStatus.loading, collections: collections);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message, List<WishlistCollection> collections) 
    : super(errorMessage: message, status: WishlistStatus.error, collections: collections);
}

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _repository;

  WishlistCubit(this._repository) : super(WishlistState());

  Future<void> checkStatus(String propertyId) async {
    try {
      final isWishlisted = await _repository.isWishlisted(propertyId);
      emit(WishlistStatusLoaded(propertyId, isWishlisted, state.collections));
    } catch (e) {
      emit(WishlistError('Error checking status', state.collections));
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
      emit(WishlistToggled(propertyId, isWishlisted, collections));
    } catch (e) {
      emit(WishlistError('Failed to toggle', state.collections));
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
      emit(WishlistError('Failed to add to collection', state.collections));
    }
  }

  Future<void> createCollection(String name) async {
    try {
      await _repository.addCollection(name);
      await loadCollections();
    } catch (e) {
      emit(WishlistError('Failed to create collection', state.collections));
    }
  }

  Future<void> loadCollections() async {
    emit(WishlistLoading(state.collections));
    try {
      final collections = await _repository.getCollections();
      emit(CollectionsLoaded(collections));
    } catch (e) {
      emit(WishlistError('Failed to load collections', state.collections));
    }
  }

  Future<void> loadWishlistItems(String collectionId) async {
    emit(WishlistLoading(state.collections));
    try {
      final items = await _repository.getWishlistItems(collectionId);
      emit(WishlistItemsLoaded(items, state.collections));
    } catch (e) {
      emit(WishlistError('Failed to load wishlist items', state.collections));
    }
  }
}
