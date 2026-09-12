import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Smart-lock vendors the backend can drive (`SmartLockProvider`).
class SmartLockProviders {
  SmartLockProviders._();

  static const String tuya = 'tuya';
  static const String ttlock = 'ttlock';
  static const String igloohome = 'igloohome';
}

/// Remote data source for smart locks.
///
/// The lock routes live under the property (`/properties/:id/smart-lock/*`);
/// the guest's door PIN comes from the booking
/// (`GET /bookings/:id/lock/pin`).
///
/// `/locks/tuya` and `/locks/hardware-callback` are vendor webhooks the app
/// must never call, so they are absent here.
class SmartLockApiDataSource {
  final ApiClient apiClient;

  SmartLockApiDataSource(this.apiClient);

  /// Pairs a physical lock with a property (owner only).
  Future<Map<String, dynamic>> register({
    required String propertyId,
    required String deviceId,
    required String provider,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.smartLockRegister(propertyId),
      data: {'device_id': deviceId, 'provider': provider},
    );
    return asMap(unwrapData(res.data));
  }

  Future<void> remove(String propertyId) =>
      apiClient.delete(ApiEndpoints.smartLock(propertyId));

  /// Whether the lock is currently reachable - check before showing a PIN so
  /// the guest is not sent to a door that cannot open.
  Future<Map<String, dynamic>> onlineStatus(String propertyId) async {
    final res =
        await apiClient.get(ApiEndpoints.smartLockOnlineStatus(propertyId));
    return asMap(unwrapData(res.data));
  }

  Future<List<Map<String, dynamic>>> accessLog(String propertyId) async {
    final res =
        await apiClient.get(ApiEndpoints.smartLockAccessLog(propertyId));
    return asListOfMaps(unwrapData(res.data));
  }

  /// Issues a one-off override code. Audited server-side.
  Future<Map<String, dynamic>> emergencyAccess(
    String propertyId, {
    String? reason,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.smartLockEmergencyAccess(propertyId),
      data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    );
    return asMap(unwrapData(res.data));
  }

  /// The guest's door PIN for a stay. Only valid inside the check-in window.
  Future<Map<String, dynamic>> bookingPin(String bookingId) async {
    final res = await apiClient.get(ApiEndpoints.bookingLockPin(bookingId));
    return asMap(unwrapData(res.data));
  }
}
