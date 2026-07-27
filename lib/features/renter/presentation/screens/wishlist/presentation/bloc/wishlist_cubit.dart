import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';

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

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _repository;

  WishlistCubit(this._repository) : super(WishlistState());

  /// Helper to get current role from RoleState
  Role get _activeRole => RoleState().currentRole;

  Future<void> checkStatus(String propertyId, [Role? role]) async {
    final targetRole = role ?? _activeRole;
    try {
      final isWishlisted = await _repository.isWishlisted(propertyId, targetRole);
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
      final isWishlisted = await _repository.toggleWishlist(
        propertyId: propertyId,
        propertyName: propertyName,
        propertyImage: propertyImage,
        role: targetRole,
      );

      final collections = await _repository.getCollections(targetRole);
      final items = await _repository.getAllWishlistItems(targetRole);

      emit(state.copyWith(
        collections: collections,
        items: items,
        toggledPropertyId: propertyId,
        isToggledStatus: isWishlisted,
        status: WishlistStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to toggle'));
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
      await _repository.addToWishlist(
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
      await _repository.addToCollection(
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
      await _repository.addCollection(name, targetRole);
      await loadCollections(targetRole);
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to create collection'));
    }
  }

  Future<void> loadCollections([Role? role]) async {
    final targetRole = role ?? _activeRole;
    emit(state.copyWith(status: WishlistStatus.loading));
    try {
      final collections = await _repository.getCollections(targetRole);
      final items = await _repository.getAllWishlistItems(targetRole);

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
      final items = await _repository.getWishlistItems(collectionId, targetRole);
      emit(state.copyWith(items: items, status: WishlistStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.error, errorMessage: 'Failed to load wishlist items'));
    }
  }
}
