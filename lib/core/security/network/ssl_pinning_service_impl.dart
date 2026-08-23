import 'dart:typed_data';
import 'ssl_pinning_service.dart';
import 'certificate_provider.dart';
import 'ssl_pinning_failure.dart';

class SSLPinningServiceImpl implements SSLPinningService {
  final CertificateProvider _certificateProvider;
  final List<Uint8List> _allowedCertificates = [];

  SSLPinningServiceImpl(this._certificateProvider);

  @override
  Future<void> initialize() async {
    try {
      final certs = await _certificateProvider.getCertificates();
      _allowedCertificates.clear();
      _allowedCertificates.addAll(certs);
    } catch (e) {
      throw SSLPinningException('Failed to initialize SSL Pinning: $e');
    }
  }

  @override
  bool validateCertificate(Uint8List serverCertificate) {
    if (_allowedCertificates.isEmpty) {
      // If no certificates are pinned, we might want to default to true or false 
      // based on whether pinning is "activated" or not.
      // Requirements say do not activate yet.
      return true; 
    }

    for (final allowed in _allowedCertificates) {
      if (_compareCertificates(allowed, serverCertificate)) {
        return true;
      }
    }
    return false;
  }

  @override
  List<Uint8List> get allowedCertificates => List.unmodifiable(_allowedCertificates);

  bool _compareCertificates(Uint8List cert1, Uint8List cert2) {
    if (cert1.length != cert2.length) return false;
    for (int i = 0; i < cert1.length; i++) {
      if (cert1[i] != cert2[i]) return false;
    }
    return true;
  }
}
