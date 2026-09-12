import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Remote data source for the `referrals` module - the invite-a-friend program.
class ReferralsApiDataSource {
  final ApiClient apiClient;

  ReferralsApiDataSource(this.apiClient);

  /// The signed-in user's own invite code and share link.
  Future<Map<String, dynamic>> fetchCode() async {
    final res = await apiClient.get(ApiEndpoints.referralCode);
    return asMap(unwrapData(res.data));
  }

  /// The referral record attached to this account (who invited them).
  Future<Map<String, dynamic>> fetchMine() async {
    final res = await apiClient.get(ApiEndpoints.referralMe);
    return asMap(unwrapData(res.data));
  }

  /// Counts and earned rewards.
  Future<Map<String, dynamic>> fetchStats() async {
    final res = await apiClient.get(ApiEndpoints.referralStats);
    return asMap(unwrapData(res.data));
  }

  /// Public - resolves a code from a deep link *before* the user signs up, so
  /// the invite can be shown on the registration screen.
  Future<Map<String, dynamic>> resolve(String code) async {
    final res = await apiClient.get(
      ApiEndpoints.referralResolve,
      queryParameters: {'code': code},
    );
    return asMap(unwrapData(res.data));
  }
}
