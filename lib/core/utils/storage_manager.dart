import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class StorageManager {
  static const String _tokenKey = 'access_token';
  static const _secureStorage = FlutterSecureStorage();

  /// Save token securely
  static Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(
        key: _tokenKey,
        value: token,
      );
      Logger().d('Token saved securely');
    } catch (e) {
      Logger().e('Error saving token: $e');
      throw Exception('Failed to save token');
    }
  }

  /// Retrieve token from secure storage
  static Future<String?> getToken() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      return token;
    } catch (e) {
      Logger().e('Error retrieving token: $e');
      return null;
    }
  }

  /// Clear token from secure storage
  static Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      Logger().d('Token cleared');
    } catch (e) {
      Logger().e('Error clearing token: $e');
    }
  }

  /// Check if token exists
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
