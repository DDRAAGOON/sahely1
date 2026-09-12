import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/upload/file_upload_api.dart';
import 'package:sahely/features/renter/presentation/verification/domain/models/verification_state.dart';

/// Remote data source for identity verification (KYC).
///
/// The backend splits KYC across two prefixes:
///  * `/auth/verification/*` - the *post-login* profile flow (status, identity
///    documents, payment card),
///  * `/verification/*`      - the *session-based* flow used during
///    registration (start -> documents -> liveness -> review), driven by a
///    `session_token`.
///
/// Both are covered here; the app picks whichever matches where the user is.
class VerificationApiDataSource {
  final ApiClient apiClient;
  final FileUploadApi _uploads;

  VerificationApiDataSource(this.apiClient, {FileUploadApi? uploads})
      : _uploads = uploads ?? FileUploadApi(apiClient);

  // -- Post-login profile flow (`/auth/verification/*`) -----------------------

  /// `GET /auth/verification/status` - drives the verification checklist UI.
  ///
  /// The backend answers with a step list, not flat booleans:
  /// `{ steps: [{ step: 'email'|'phone'|'identity'|'payment_card',
  ///              status: 'completed', completed_at }],
  ///    complete: true, can_skip_identity_and_card_at_registration,
  ///    complete_later_in_profile: [...] }`
  ///
  /// Reading flat `email_verified`-style flags left every step false, so a
  /// fully verified user was re-prompted to verify everything again.
  Future<VerificationState> fetchStatus() async {
    final res = await apiClient.get(ApiEndpoints.verificationStatus);
    final data = asMap(unwrapData(res.data));

    final steps = asListOfMaps(data['steps']);
    final allComplete = data['complete'] == true || data['complete'] == 'true';

    bool done(String stepName, List<String> legacyFlags) {
      if (allComplete) return true;
      final matched = steps.any((step) {
        if ('${pick(step, 'step') ?? ''}'.toLowerCase() != stepName) {
          return false;
        }
        return const {'completed', 'complete', 'verified', 'approved'}
            .contains('${pick(step, 'status') ?? ''}'.toLowerCase());
      });
      if (matched) return true;
      // Fall back to the flat flags in case an older backend is deployed.
      return legacyFlags.any((flag) => _flag(data, flag));
    }

    return VerificationState(
      emailVerified: done('email', ['email_verified']),
      phoneVerified: done('phone', ['phone_verified']),
      idVerified: done('identity', ['identity_verified', 'id_verified']) ||
          '${data['kyc_status'] ?? data['kycStatus'] ?? ''}'.toLowerCase() ==
              'approved',
      cardAdded: done('payment_card', ['card_added', 'card_verified']),
    );
  }

  /// Uploads the three identity images through the S3 flow, then submits them.
  ///
  /// Returns the object keys so a retry does not re-upload.
  Future<Map<String, String>> submitIdentityDocuments({
    required String idFrontPath,
    required String idBackPath,
    required String faceScanPath,
  }) async {
    final idFront = await _uploads.uploadFile(
      filePath: idFrontPath,
      uploadType: UploadTypes.idFront,
    );
    final idBack = await _uploads.uploadFile(
      filePath: idBackPath,
      uploadType: UploadTypes.idBack,
    );
    final faceScan = await _uploads.uploadFile(
      filePath: faceScanPath,
      uploadType: UploadTypes.selfie,
    );

    await apiClient.post(
      ApiEndpoints.verificationIdentity,
      data: {
        'id_front_url': idFront,
        'id_back_url': idBack,
        'face_scan_url': faceScan,
      },
    );

    return {
      'id_front_url': idFront,
      'id_back_url': idBack,
      'face_scan_url': faceScan,
    };
  }

  /// Registers a payment card during verification.
  ///
  /// Card data goes straight to the backend over TLS and is never persisted on
  /// the device.
  Future<void> submitCard({
    required String cardholderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) =>
      apiClient.post(
        ApiEndpoints.verificationCard,
        data: {
          'cardholder_name': cardholderName,
          'card_number': cardNumber,
          'expiry_date': expiryDate,
          'cvv': cvv,
        },
      );

  // -- Session flow (`/verification/*`) ---------------------------------------

  /// Opens a verification session. On mobile the flow runs inline
  /// (`device_type: 'mobile'`); desktop gets a QR code to hand off.
  Future<Map<String, dynamic>> startSession({
    required String registrationSessionId,
    String deviceType = 'mobile',
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.kycStart,
      data: {
        'registration_session_id': registrationSessionId,
        'device_type': deviceType,
      },
    );
    return asMap(unwrapData(res.data));
  }

  /// Continues a desktop session that was handed off by QR code.
  Future<Map<String, dynamic>> scanQr(String qrToken) async {
    final res = await apiClient.post(
      ApiEndpoints.kycQrScan,
      data: {'qr_token': qrToken},
    );
    return asMap(unwrapData(res.data));
  }

  /// Submits already-uploaded document object keys for OCR + face compare.
  Future<Map<String, dynamic>> submitDocuments({
    required String sessionToken,
    required String idFrontObjectKey,
    required String idBackObjectKey,
    String? selfieObjectKey,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.kycDocuments,
      data: {
        'session_token': sessionToken,
        'id_front_object_key': idFrontObjectKey,
        'id_back_object_key': idBackObjectKey,
        if (selfieObjectKey != null) 'selfie_object_key': selfieObjectKey,
      },
    );
    return asMap(unwrapData(res.data));
  }

  /// Creates an AWS Face Liveness session; returns the id the SDK needs.
  Future<Map<String, dynamic>> startLiveness(String sessionToken) async {
    final res = await apiClient.post(
      ApiEndpoints.kycLivenessStart,
      data: {'session_token': sessionToken},
    );
    return asMap(unwrapData(res.data));
  }

  Future<Map<String, dynamic>> submitLiveness({
    required String sessionToken,
    required String livenessSessionId,
  }) async {
    final res = await apiClient.post(
      ApiEndpoints.kycLivenessSubmit,
      data: {
        'session_token': sessionToken,
        'liveness_session_id': livenessSessionId,
      },
    );
    return asMap(unwrapData(res.data));
  }

  /// Escalates to a human reviewer when the automated checks are inconclusive.
  Future<void> requestManualReview(String sessionToken) => apiClient.post(
        ApiEndpoints.kycRequestReview,
        data: {'session_token': sessionToken},
      );

  /// Polls the outcome of a verification session.
  Future<Map<String, dynamic>> sessionStatus(String sessionId) async {
    final res = await apiClient.get(ApiEndpoints.kycStatus(sessionId));
    return asMap(unwrapData(res.data));
  }

  /// Uploads a KYC image and returns its S3 object key.
  Future<String> uploadDocument({
    required String filePath,
    required String uploadType,
  }) =>
      _uploads.uploadFile(filePath: filePath, uploadType: uploadType);

  static bool _flag(Map<String, dynamic> json, String key) =>
      json[key] == true || json[key] == 'true';
}
