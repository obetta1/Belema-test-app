import 'dart:convert';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class DeviceBindingService {
  static const _secureStorage = FlutterSecureStorage();
  static const String _deviceIdKey = 'device_id';
  static const String _privateKeyKey = 'private_key';
  static const String _pinAttemptsKey = 'pin_attempts';

  /// Get device ID
  static Future<String> getDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } catch (e) {
      Logger().e('Error getting device ID: $e');
      return 'fallback_device_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Generate a random private key
  static String _generatePrivateKey() {
    final random = Random.secure();
    final keyBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(keyBytes);
  }

  /// Encrypt PIN using AES-256 with private key
  static String _encryptPin(String pin, String privateKey) {
    final key = encrypt.Key.fromBase64(privateKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(pin, iv: iv);
    return encrypted.base64;
  }

  /// Decrypt PIN using AES-256 with private key
  static String _decryptPin(String encryptedPin, String privateKey) {
    try {
      final key = encrypt.Key.fromBase64(privateKey);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final decrypted = encrypter.decrypt64(encryptedPin, iv: iv);
      return decrypted;
    } catch (e) {
      Logger().e('Error decrypting PIN: $e');
      return '';
    }
  }

  /// Initialize device binding (called on first PIN setup)
  static Future<Map<String, String>?> initializeDeviceBinding(
      String pin) async {
    try {
      final deviceId = await getDeviceId();
      final privateKey = _generatePrivateKey();
      final encryptedPin = _encryptPin(pin, privateKey);

      // Store private key securely
      await _secureStorage.write(key: _privateKeyKey, value: privateKey);

      // Store device ID
      await _secureStorage.write(key: _deviceIdKey, value: deviceId);

      // Store encrypted PIN with PIN as key
      await _secureStorage.write(key: pin, value: encryptedPin);

      Logger().d('Device binding initialized successfully');

      return {
        'deviceId': deviceId,
        'privateKey': privateKey,
        'encryptedPin': encryptedPin,
      };
    } catch (e) {
      Logger().e('Error initializing device binding: $e');
      return null;
    }
  }

  /// Verify PIN and return encrypted PIN if valid
  static Future<String?> verifyPin(String enteredPin) async {
    try {
      // Get encrypted PIN from storage using entered PIN as key
      final encryptedPin = await _secureStorage.read(key: enteredPin);

      if (encryptedPin == null || encryptedPin.isEmpty) {
        // Invalid PIN - increment attempts
        await _incrementPinAttempts();
        return null;
      }

      // Valid PIN - reset attempts
      await _resetPinAttempts();

      return encryptedPin;
    } catch (e) {
      Logger().e('Error verifying PIN: $e');
      return null;
    }
  }

  /// Check if device is already bound
  static Future<bool> isDeviceBound() async {
    try {
      final privateKey = await _secureStorage.read(key: _privateKeyKey);
      final deviceId = await _secureStorage.read(key: _deviceIdKey);
      return privateKey != null && deviceId != null;
    } catch (e) {
      Logger().e('Error checking device binding: $e');
      return false;
    }
  }

  /// Get current PIN attempts count
  static Future<int> getPinAttempts() async {
    try {
      final attempts = await _secureStorage.read(key: _pinAttemptsKey);
      return int.tryParse(attempts ?? '0') ?? 0;
    } catch (e) {
      Logger().e('Error getting PIN attempts: $e');
      return 0;
    }
  }

  /// Increment PIN attempts
  static Future<void> _incrementPinAttempts() async {
    try {
      final currentAttempts = await getPinAttempts();
      final newAttempts = currentAttempts + 1;
      await _secureStorage.write(
          key: _pinAttemptsKey, value: newAttempts.toString());

      Logger().d('PIN attempts incremented to: $newAttempts');
    } catch (e) {
      Logger().e('Error incrementing PIN attempts: $e');
    }
  }

  /// Reset PIN attempts
  static Future<void> _resetPinAttempts() async {
    try {
      await _secureStorage.write(key: _pinAttemptsKey, value: '0');
      Logger().d('PIN attempts reset to 0');
    } catch (e) {
      Logger().e('Error resetting PIN attempts: $e');
    }
  }

  /// Check if account should be locked (3+ failed attempts)
  static Future<bool> shouldLockAccount() async {
    final attempts = await getPinAttempts();
    return attempts >= 3;
  }

  /// Clear all device binding data (for logout/account lock)
  static Future<void> clearDeviceBinding() async {
    try {
      await _secureStorage.deleteAll();
      Logger().d('Device binding data cleared');
    } catch (e) {
      Logger().e('Error clearing device binding: $e');
    }
  }
}
