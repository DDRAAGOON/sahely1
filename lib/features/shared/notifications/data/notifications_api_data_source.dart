import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Per-channel notification switches (`UpdateNotificationPreferencesDto`).
class NotificationPreferences {
  final bool? emailEnabled;
  final bool? pushEnabled;
  final bool? smsEnabled;
  final bool? bookingReminders;
  final bool? promotional;

  const NotificationPreferences({
    this.emailEnabled,
    this.pushEnabled,
    this.smsEnabled,
    this.bookingReminders,
    this.promotional,
  });

  /// The live payload is camelCase: `emailEnabled`, `smsEnabled`,
  /// `pushEnabled`, `marketingEnabled`. It has no separate booking-reminder
  /// switch, and the promotional toggle is called `marketingEnabled`.
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      emailEnabled: pick(json, 'email_enabled') as bool?,
      pushEnabled: pick(json, 'push_enabled') as bool?,
      smsEnabled: pick(json, 'sms_enabled') as bool?,
      bookingReminders: pick(json, 'booking_reminders') as bool?,
      promotional: (pick(json, 'marketing_enabled') ??
          pick(json, 'promotional')) as bool?,
    );
  }

  /// Only the switches the caller actually set are sent, so a partial update
  /// never resets the others.
  Map<String, dynamic> toJson() => {
        if (emailEnabled != null) 'email_enabled': emailEnabled,
        if (pushEnabled != null) 'push_enabled': pushEnabled,
        if (smsEnabled != null) 'sms_enabled': smsEnabled,
        if (bookingReminders != null) 'booking_reminders': bookingReminders,
        if (promotional != null) 'marketing_enabled': promotional,
      };
}

/// Remote data source for the `notifications` module - the in-app inbox and
/// FCM device-token registration.
class NotificationsApiDataSource {
  final ApiClient apiClient;

  NotificationsApiDataSource(this.apiClient);

  Future<List<Map<String, dynamic>>> fetchNotifications({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.notifications,
      queryParameters: pageQuery(page: page, limit: limit),
    );
    return asListOfMaps(unwrapData(res.data));
  }

  Future<void> markRead(String id) =>
      apiClient.put(ApiEndpoints.notificationRead(id));

  Future<void> markAllRead() =>
      apiClient.put(ApiEndpoints.notificationsReadAll);

  Future<void> remove(String id) =>
      apiClient.delete(ApiEndpoints.notification(id));

  /// Registers this device for push. Call it after login and whenever FCM
  /// rotates the token, otherwise pushes silently stop arriving.
  Future<void> registerDeviceToken(String fcmToken) => apiClient.post(
        ApiEndpoints.notificationDeviceToken,
        data: {'fcm_token': fcmToken},
      );

  Future<NotificationPreferences> fetchPreferences() async {
    final res = await apiClient.get(ApiEndpoints.notificationPreferences);
    return NotificationPreferences.fromJson(asMap(unwrapData(res.data)));
  }

  Future<void> updatePreferences(NotificationPreferences preferences) =>
      apiClient.put(
        ApiEndpoints.notificationPreferences,
        data: preferences.toJson(),
      );
}
