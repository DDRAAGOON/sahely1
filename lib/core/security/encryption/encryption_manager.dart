import 'encryption_service.dart';

class EncryptionManager {
  final EncryptionService _service;

  EncryptionManager(this._service);

  String encrypt(
      {required String data, required String key, required String iv}) {
    return _service.encrypt(data: data, key: key, iv: iv);
  }

  String decrypt(
      {required String encryptedData,
      required String key,
      required String iv}) {
    return _service.decrypt(encryptedData: encryptedData, key: key, iv: iv);
  }

  String hash({required String data}) {
    return _service.hash(data: data);
  }

  String hmac({required String data, required String key}) {
    return _service.hmac(data: data, key: key);
  }

  String generateRandomKey() {
    return _service.generateRandomKey();
  }

  String generateRandomIV() {
    return _service.generateRandomIV();
  }
}
