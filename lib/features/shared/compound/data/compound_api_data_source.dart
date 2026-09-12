import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Remote data source for the `compound` module - the gate security check that
/// gates arrivals, and the cleaning log kept between stays.
class CompoundApiDataSource {
  final ApiClient apiClient;

  CompoundApiDataSource(this.apiClient);

  /// Records the gate security decision for an arriving booking.
  ///
  /// [score] is an optional 0-100 risk score supplied by compound staff.
  Future<Map<String, dynamic>> submitSecurityCheck({
    required String bookingId,
    required String status,
    String? notes,
    int? score,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.compoundSecurityCheck(bookingId),
      data: {
        'status': status,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (score != null) 'score': score,
      },
    );
    return asMap(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> fetchSecurityCheck(String bookingId) async {
    final res =
        await apiClient.get(ApiEndpoints.compoundSecurityCheck(bookingId));
    return asMap(unwrapData(res.data));
  }

  /// Marks a property as cleaned and ready for the next arrival.
  Future<void> confirmCleaning(String propertyId) =>
      apiClient.post(ApiEndpoints.cleaningConfirm(propertyId));

  Future<List<Map<String, dynamic>>> fetchCleaningLog(String propertyId) async {
    final res = await apiClient.get(ApiEndpoints.cleaningLog(propertyId));
    return asListOfMaps(unwrapData(res.data));
  }
}
