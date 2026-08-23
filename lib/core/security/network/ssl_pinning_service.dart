import 'dart:typed_data';

abstract class SSLPinningService {
  Future<void> initialize();
  bool validateCertificate(Uint8List serverCertificate);
  List<Uint8List> get allowedCertificates;
}
