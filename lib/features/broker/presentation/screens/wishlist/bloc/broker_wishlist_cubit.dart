import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/broker_wishlist_repository.dart';

class BrokerWishlistCubit extends Cubit<void> {
  final BrokerWishlistRepository _repository;
  BrokerWishlistCubit(this._repository) : super(null);
}
