import '../repositories/booking_repository.dart';

class UpdateChecklistUseCase {
  final BookingRepository repository;

  UpdateChecklistUseCase(this.repository);

  Future<void> execute(String bookingId, List<Map<String, dynamic>> newChecklist) {
    return repository.updateChecklist(bookingId, newChecklist);
  }
}
