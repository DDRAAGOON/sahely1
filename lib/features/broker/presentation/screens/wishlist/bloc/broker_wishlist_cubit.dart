import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/models/broker_wishlist_item.dart';
import '../../../../data/repositories/broker_wishlist_repository.dart';

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

class BrokerWishlistCubit extends Cubit<BrokerWishlistState> {
  final BrokerWishlistRepository _repository;

  BrokerWishlistCubit(this._repository) : super(BrokerWishlistState());

  Future<void> loadCollections() async {
    emit(state.copyWith(status: BrokerWishlistStatus.loading));
    try {
      final collections = await _repository.getCollections();
      emit(state.copyWith(collections: collections, status: BrokerWishlistStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: BrokerWishlistStatus.error, errorMessage: 'Failed to load collections'));
    }
  }

  Future<void> createCollection(String name) async {
    try {
      await _repository.addCollection(name);
      await loadCollections();
    } catch (e) {
      emit(state.copyWith(status: BrokerWishlistStatus.error, errorMessage: 'Failed to create collection'));
    }
  }
  
  Future<void> loadWishlistItems(String collectionId) async {
    emit(state.copyWith(status: BrokerWishlistStatus.loading));
    try {
      final items = await _repository.getWishlistItems(collectionId);
      emit(state.copyWith(items: items, status: BrokerWishlistStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: BrokerWishlistStatus.error, errorMessage: 'Failed to load items'));
    }
  }
}
