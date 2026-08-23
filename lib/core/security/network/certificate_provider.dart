import 'dart:typed_data';

abstract class CertificateProvider {
  Future<List<Uint8List>> getCertificates();
}
