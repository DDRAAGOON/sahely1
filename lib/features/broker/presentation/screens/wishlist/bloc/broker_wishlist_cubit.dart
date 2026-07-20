import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repositories/broker_wishlist_repository.dart';
import '../../../../domain/models/broker_wishlist_item.dart';

enum BrokerWishlistStatus { initial, loading, loaded, error }

class BrokerWishlistState {
  final List<BrokerWishlistCollection> collections;
  final List<BrokerWishlistItem> items;
  final BrokerWishlistStatus status;
  final String? errorMessage;
  final String? toggledPropertyId;
  final bool? isToggledStatus;

  BrokerWishlistState({
    this.collections = const [],
    this.items = const [],
    this.status = BrokerWishlistStatus.initial,
    this.errorMessage,
    this.toggledPropertyId,
    this.isToggledStatus,
  });

  BrokerWishlistState copyWith({
    List<BrokerWishlistCollection>? collections,
    List<BrokerWishlistItem>? items,
    BrokerWishlistStatus? status,
    String? errorMessage,
    String? toggledPropertyId,
    bool? isToggledStatus,
  }) {
    return BrokerWishlistState(
      collections: collections ?? this.collections,
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage,
      toggledPropertyId: toggledPropertyId ?? this.toggledPropertyId,
      isToggledStatus: isToggledStatus ?? this.isToggledStatus,
    );
  }
}

// Specialized states for easier BlocBuilder filtering
class BrokerWishlistStatusLoaded extends BrokerWishlistState {
  final String propertyId;
  final bool isWishlisted;

  BrokerWishlistStatusLoaded(this.propertyId, this.isWishlisted,
      List<BrokerWishlistCollection> collections)
      : super(
            toggledPropertyId: propertyId,
            isToggledStatus: isWishlisted,
            collections: collections,
            status: BrokerWishlistStatus.loaded);
}

class BrokerWishlistToggled extends BrokerWishlistState {
  final String propertyId;
  final bool isWishlisted;

  BrokerWishlistToggled(this.propertyId, this.isWishlisted,
      List<BrokerWishlistCollection> collections)
      : super(
            toggledPropertyId: propertyId,
            isToggledStatus: isWishlisted,
            collections: collections,
            status: BrokerWishlistStatus.loaded);
}

class BrokerCollectionsLoaded extends BrokerWishlistState {
  @override
  final List<BrokerWishlistCollection> collections;

  BrokerCollectionsLoaded(this.collections)
      : super(collections: collections, status: BrokerWishlistStatus.loaded);
}

class BrokerWishlistCubit extends Cubit<BrokerWishlistState> {
  final BrokerWishlistRepository _repository;

  BrokerWishlistCubit(this._repository) : super(BrokerWishlistState());

  Future<void> checkStatus(String propertyId) async {
    try {
      final isWishlisted = await _repository.isWishlisted(propertyId);
      emit(BrokerWishlistStatusLoaded(
          propertyId, isWishlisted, state.collections));
    } catch (e) {
      emit(state.copyWith(
          status: BrokerWishlistStatus.error,
          errorMessage: 'Error checking status'));
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
      emit(BrokerWishlistToggled(propertyId, isWishlisted, collections));
    } catch (e) {
      emit(state.copyWith(
          status: BrokerWishlistStatus.error,
          errorMessage: 'Failed to toggle'));
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
      emit(state.copyWith(
          status: BrokerWishlistStatus.error,
          errorMessage: 'Failed to add to collection'));
    }
  }

  Future<void> loadCollections() async {
    emit(state.copyWith(status: BrokerWishlistStatus.loading));
    try {
      final collections = await _repository.getCollections();
      emit(BrokerCollectionsLoaded(collections));
    } catch (e) {
      emit(state.copyWith(
          status: BrokerWishlistStatus.error,
          errorMessage: 'Failed to load collections'));
    }
  }

  Future<void> createCollection(String name) async {
    try {
      await _repository.addCollection(name);
      await loadCollections();
    } catch (e) {
      emit(state.copyWith(
          status: BrokerWishlistStatus.error,
          errorMessage: 'Failed to create collection'));
    }
  }

  Future<void> loadWishlistItems(String collectionId) async {
    emit(state.copyWith(status: BrokerWishlistStatus.loading));
    try {
      final items = await _repository.getWishlistItems(collectionId);
      emit(state.copyWith(items: items, status: BrokerWishlistStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
          status: BrokerWishlistStatus.error,
          errorMessage: 'Failed to load items'));
    }
  }
}
