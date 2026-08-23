import 'package:flutter/services.dart';
import 'certificate_provider.dart';

class AssetCertificateProvider implements CertificateProvider {
  final List<String> certificatePaths;

  AssetCertificateProvider({required this.certificatePaths});

  @override
  Future<List<Uint8List>> getCertificates() async {
    final certificates = <Uint8List>[];
    for (final path in certificatePaths) {
      final data = await rootBundle.load(path);
      certificates.add(data.buffer.asUint8List());
    }
    return certificates;
  }
}
