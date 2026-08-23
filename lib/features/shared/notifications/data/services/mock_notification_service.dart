import 'package:flutter/foundation.dart';
import '../../domain/services/notification_service.dart';

class MockNotificationService implements NotificationService {
  @override
  Future<void> notifyOwnerNewReview({
    required String ownerId,
    required String propertyName,
    required String bookingId,
    required double rating,
  }) async {
    debugPrint('NOTIFICATION: Owner $ownerId notified about new $rating-star review for $propertyName (Booking $bookingId)');
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
