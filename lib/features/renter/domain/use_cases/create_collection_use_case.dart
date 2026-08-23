import 'package:sahely/data/models.dart';
import 'package:sahely/features/renter/domain/models/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class CreateCollectionUseCase {
  final WishlistRepository repository;

  CreateCollectionUseCase(this.repository);

  Future<void> execute(String name, Role role) {
    final collection = WishlistCollection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      itemCount: 0,
    );
    return repository.saveCollection(collection, role);
  }
}
