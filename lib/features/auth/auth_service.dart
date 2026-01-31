import 'package:belema_test_app/core/api/newtwork_repository.dart';
import 'package:belema_test_app/core/api/ntwork_repository_imp.dart';
import 'package:belema_test_app/core/utils/constants.dart';
import 'package:belema_test_app/core/utils/device_binding_service.dart';
import 'package:belema_test_app/core/utils/token.dart';
import 'package:belema_test_app/core/utils/storage_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final authProvider = Provider<AuthServiceProvider>((ref) {
  return AuthServiceProvider();
});

class LoginResponse {
  final String accessToken;
  final bool hasPin;

  LoginResponse({
    required this.accessToken,
    required this.hasPin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      hasPin: json['hasPin'] ?? false,
    );
  }
}

class AuthServiceProvider {
  NetworkRepository networkRepository = NetworkImplementation();

  /// Login with credentials and handle response
  /// Returns a map with 'success' and 'hasPin' status
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required WidgetRef ref,
    required void Function(String message) onError,
  }) async {
    try {
      var response = await networkRepository.post(
        '$baseUrl/login',
        form: {
          'username': username,
          'password': password,
        },
      );

      // Parse response
      final loginResponse = LoginResponse.fromJson(response);

      // Save token securely
      await StorageManager.saveToken(loginResponse.accessToken);

      // Update the static Token class for header usage
      Token.bearerToken = loginResponse.accessToken;

      Logger().d('Login successful. HasPin: ${loginResponse.hasPin}');

      return {
        'success': true,
        'hasPin': loginResponse.hasPin,
      };
    } catch (e, t) {
      Logger().e('Login failed: $e', stackTrace: t);
      onError('Login failed: $e');
      return {
        'success': false,
        'hasPin': false,
      };
    }
  }

  /// Logout - clear stored token and device binding
  Future<void> logout() async {
    try {
      await StorageManager.clearToken();
      Token.bearerToken = null;

      // Clear device binding data
      await DeviceBindingService.clearDeviceBinding();

      Logger().d('Logout successful - token and device binding cleared');
    } catch (e) {
      Logger().e('Logout failed: $e');
    }
  }
}
