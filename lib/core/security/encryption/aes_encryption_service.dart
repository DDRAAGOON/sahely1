import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'encryption_service.dart';
import 'encryption_failure.dart';

class AesEncryptionService implements EncryptionService {
  @override
  String encrypt({required String data, required String key, required String iv}) {
    try {
      final encrypter = Encrypter(AES(Key.fromBase64(key)));
      final encrypted = encrypter.encrypt(data, iv: IV.fromBase64(iv));
      return encrypted.base64;
    } catch (e) {
      throw EncryptionException('Failed to encrypt data: $e');
    }
  }

  @override
  String decrypt({required String encryptedData, required String key, required String iv}) {
    try {
      final encrypter = Encrypter(AES(Key.fromBase64(key)));
      final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: IV.fromBase64(iv));
      return decrypted;
    } catch (e) {
      throw EncryptionException('Failed to decrypt data: $e');
    }
  }

  @override
  String hash({required String data}) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  String hmac({required String data, required String key}) {
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(data);
    final hmacSha256 = Hmac(sha256, keyBytes);
    final digest = hmacSha256.convert(dataBytes);
    return digest.toString();
  }

  @override
  String generateRandomKey() {
    return Key.fromSecureRandom(32).base64;
  }

  @override
  String generateRandomIV() {
    return IV.fromSecureRandom(16).base64;
  }
}
