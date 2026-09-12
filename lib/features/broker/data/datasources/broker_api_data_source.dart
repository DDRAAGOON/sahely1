import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// Remote data source for the `brokers` module.
///
/// Note the path prefix is singular - `/broker/...`, not `/brokers/...`.
/// Every route here is role-restricted to `broker` accounts.
class BrokerApiDataSource {
  final ApiClient apiClient;

  BrokerApiDataSource(this.apiClient);

  // -- Dashboard & earnings ---------------------------------------------------

  Future<Map<String, dynamic>> fetchDashboard() =>
      _map(ApiEndpoints.brokerDashboard);

  Future<List<Map<String, dynamic>>> fetchCommissions({
    int page = 1,
    int limit = ApiEndpoints.defaultPageSize,
  }) async {
    final res = await apiClient.get(
      ApiEndpoints.brokerCommissions,
      queryParameters: pageQuery(page: page, limit: limit),
    );
    return asListOfMaps(unwrapData(res.data));
  }

  /// Payout windows: when each earned commission becomes withdrawable.
  Future<List<Map<String, dynamic>>> fetchEarningWindows() =>
      _list(ApiEndpoints.brokerEarningWindows);

  /// Current tier and progress toward the next one.
  Future<Map<String, dynamic>> fetchTier() => _map(ApiEndpoints.brokerTier);

  // -- Portfolio --------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchProperties() =>
      _list(ApiEndpoints.brokerProperties);

  Future<Map<String, dynamic>> fetchProfile() =>
      _map(ApiEndpoints.brokerProfile);

  Future<void> updateProfile({String? companyName, String? bio}) =>
      apiClient.put(
        ApiEndpoints.brokerProfile,
        data: {
          if (companyName != null) 'company_name': companyName,
          if (bio != null) 'bio': bio,
        },
      );

  // -- Perks ------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchPerks() =>
      _list(ApiEndpoints.brokerPerks);

  /// Redeems a complimentary stay perk.
  Future<Map<String, dynamic>> redeemStay({
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.brokerRedeemStay,
      data: {
        'property_id': propertyId,
        'check_in': _isoDate(checkIn),
        'check_out': _isoDate(checkOut),
      },
    );
    return asMap(unwrapData(res.data));
  }

  // -- Referrals --------------------------------------------------------------

  /// Creates (or returns) the broker's shareable referral link.
  Future<Map<String, dynamic>> createReferralLink() async {
    final res = await apiClient.post(ApiEndpoints.brokerReferralLink);
    return asMap(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> fetchReferralStats() =>
      _map(ApiEndpoints.brokerReferralStats);

  // -- Payouts ----------------------------------------------------------------

  /// [accountNumberEncrypted] must already be encrypted by the caller.
  Future<Map<String, dynamic>> withdraw({
    required int amountPiastres,
    required String accountNumberEncrypted,
    String? bankName,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.brokerWithdraw,
      data: {
        'amount_piastres': amountPiastres,
        'account_number_encrypted': accountNumberEncrypted,
        if (bankName != null) 'bank_name': bankName,
      },
    );
    return asMap(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> _map(String path) async {
    final res = await apiClient.get(path);
    return asMap(unwrapData(res.data));
  }

  Future<List<Map<String, dynamic>>> _list(String path) async {
    final res = await apiClient.get(path);
    return asListOfMaps(unwrapData(res.data));
  }

  static String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
