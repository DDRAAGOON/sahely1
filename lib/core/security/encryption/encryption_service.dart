abstract class EncryptionService {
  String encrypt({required String data, required String key, required String iv});
  String decrypt({required String encryptedData, required String key, required String iv});
  String hash({required String data});
  String hmac({required String data, required String key});
  String generateRandomKey();
  String generateRandomIV();
}
