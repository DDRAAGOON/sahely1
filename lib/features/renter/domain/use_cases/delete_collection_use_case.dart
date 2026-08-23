import 'package:sahely/data/models.dart';
import '../repositories/wishlist_repository.dart';

class DeleteCollectionUseCase {
  final WishlistRepository repository;

  DeleteCollectionUseCase(this.repository);

  Future<void> execute(String collectionId, Role role) async {
    await repository.deleteCollection(collectionId, role);
  }
}
