import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Remote data source for the `violations` module - the single reporting
/// channel for abusive content, guest/host misconduct and compound rule
/// breaches.
class ViolationsApiDataSource {
  final ApiClient apiClient;

  ViolationsApiDataSource(this.apiClient);

  /// General report (`POST /violations/report`).
  ///
  /// [evidenceUrls] are object keys produced by the S3 upload flow.
  Future<Map<String, dynamic>> report({
    required String type,
    required String description,
    List<String> evidenceUrls = const [],
    String? bookingId,
    String? propertyId,
  }) =>
      _post(
        ApiEndpoints.violationsReport,
        type: type,
        description: description,
        evidenceUrls: evidenceUrls,
        bookingId: bookingId,
        propertyId: propertyId,
      );

  /// Compound rule breach (`POST /violations/compound`) - noise, unregistered
  /// guests, gate misuse and the like.
  Future<Map<String, dynamic>> reportCompound({
    required String type,
    required String description,
    List<String> evidenceUrls = const [],
    String? bookingId,
    String? propertyId,
  }) =>
      _post(
        ApiEndpoints.violationsCompound,
        type: type,
        description: description,
        evidenceUrls: evidenceUrls,
        bookingId: bookingId,
        propertyId: propertyId,
      );

  /// Reports filed by, or against, the signed-in user.
  Future<List<Map<String, dynamic>>> mine() async {
    final res = await apiClient.get(ApiEndpoints.violationsMine);
    return asListOfMaps(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    required String type,
    required String description,
    required List<String> evidenceUrls,
    String? bookingId,
    String? propertyId,
  }) async {
    final res = await apiClient.post(
      path,
      data: {
        'type': type,
        'description': description,
        if (evidenceUrls.isNotEmpty) 'evidence_urls': evidenceUrls,
        if (bookingId != null) 'booking_id': bookingId,
        if (propertyId != null) 'property_id': propertyId,
      },
    );
    return asMap(unwrapData(res.data));
  }
}
