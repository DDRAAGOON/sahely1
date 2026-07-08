import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/models.dart';
import '../../data/repositories/wishlist_repository.dart';

enum WishlistStatus { initial, loading, loaded, error }

class WishlistState {
  final List<Property> items;
  final WishlistStatus status;
  final String? toggledPropertyId;
  final bool? isToggledStatus;

  WishlistState({
    this.items = const [],
    this.status = WishlistStatus.initial,
    this.toggledPropertyId,
    this.isToggledStatus,
  });

  WishlistState copyWith({
    List<Property>? items,
    WishlistStatus? status,
    String? toggledPropertyId,
    bool? isToggledStatus,
  }) {
    return WishlistState(
      items: items ?? this.items,
      status: status ?? this.status,
      toggledPropertyId: toggledPropertyId ?? this.toggledPropertyId,
      isToggledStatus: isToggledStatus ?? this.isToggledStatus,
    );
  }
}

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _repository;
  
  WishlistCubit(this._repository) : super(WishlistState());

  void checkStatus(String propertyId) async {
    final isWishlisted = await _repository.isWishlisted(propertyId);
    emit(state.copyWith(
      toggledPropertyId: propertyId,
      isToggledStatus: isWishlisted,
    ));
  }

  Future<void> toggleWishlist({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
  }) async {
    final isSaved = await _repository.toggleWishlist(
      propertyId: propertyId,
      propertyName: propertyName,
      propertyImage: propertyImage,
    );
    
    final updatedItems = List<Property>.from(state.items);
    if (!isSaved) {
       updatedItems.removeWhere((p) => p.name == propertyName);
    } else {
       updatedItems.add(Property(
        name: propertyName,
        image: propertyImage,
        area: 'Unknown',
        price: 0,
        rating: 0,
        reviews: 0,
      ));
    }

    emit(state.copyWith(
      items: updatedItems,
      toggledPropertyId: propertyName,
      isToggledStatus: isSaved,
    ));
  }
}
