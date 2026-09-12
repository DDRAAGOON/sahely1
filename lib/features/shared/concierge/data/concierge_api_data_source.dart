import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Remote data source for the `concierge` module - add-on services (cleaning,
/// chef, transfers, ...) a guest can book alongside a stay.
class ConciergeApiDataSource {
  final ApiClient apiClient;

  ConciergeApiDataSource(this.apiClient);

  /// The service catalogue.
  Future<List<Map<String, dynamic>>> fetchServices() async {
    final res = await apiClient.get(ApiEndpoints.conciergeServices);
    return asListOfMaps(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> fetchService(String id) async {
    final res = await apiClient.get(ApiEndpoints.conciergeService(id));
    return asMap(unwrapData(res.data));
  }

  /// Books a service. [scheduledAt] is an ISO-8601 timestamp.
  Future<Map<String, dynamic>> book({
    required String serviceId,
    String? bookingId,
    String? scheduledAt,
    int quantity = 1,
    String? notes,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.conciergeBookings,
      data: {
        'service_id': serviceId,
        'quantity': quantity,
        if (bookingId != null) 'booking_id': bookingId,
        if (scheduledAt != null) 'scheduled_at': scheduledAt,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
    return asMap(unwrapData(res.data));
  }

  Future<List<Map<String, dynamic>>> myBookings() async {
    final res = await apiClient.get(ApiEndpoints.conciergeBookings);
    return asListOfMaps(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> fetchBooking(String id) async {
    final res = await apiClient.get(ApiEndpoints.conciergeBooking(id));
    return asMap(unwrapData(res.data));
  }

  Future<void> cancel(String id) =>
      apiClient.post(ApiEndpoints.conciergeBookingCancel(id));
}
