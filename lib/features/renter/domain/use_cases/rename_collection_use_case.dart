import 'package:sahely/data/models.dart';
import '../repositories/wishlist_repository.dart';

class RenameCollectionUseCase {
  final WishlistRepository repository;

  RenameCollectionUseCase(this.repository);

  Future<void> execute({
    required String collectionId,
    required String newName,
    required Role role,
  }) {
    return repository.renameCollection(collectionId, newName, role);
  }
}
