import 'dart:typed_data';
import 'ssl_pinning_service.dart';

class NetworkSecurityManager {
  final SSLPinningService _sslPinningService;

  NetworkSecurityManager(this._sslPinningService);

  Future<void> initialize() async {
    await _sslPinningService.initialize();
  }

  bool isCertificateValid(Uint8List serverCertificate) {
    return _sslPinningService.validateCertificate(serverCertificate);
  }

  List<Uint8List> get pinnedCertificates =>
      _sslPinningService.allowedCertificates;
}
