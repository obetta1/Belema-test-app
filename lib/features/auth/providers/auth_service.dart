import 'package:belema_test_app/core/api/newtwork_repository.dart';
import 'package:belema_test_app/core/api/ntwork_repository_imp.dart';
import 'package:belema_test_app/core/utils/constants.dart';
import 'package:belema_test_app/core/utils/token.dart';
import 'package:belema_test_app/core/utils/storage_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../core/models/login_response.dart';

final authProvider = Provider<AuthServiceProvider>((ref) {
  return AuthServiceProvider();
});

class AuthServiceProvider {
  NetworkRepository networkRepository = NetworkImplementation();

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

      final loginResponse = LoginResponse.fromJson(response);
      await StorageManager.saveToken(loginResponse.accessToken);
      Token.bearerToken = loginResponse.accessToken;
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

  /// Logout - clear stored token
  Future<void> logout() async {
    try {
      await StorageManager.clearToken();
      Token.bearerToken = null;
    } catch (e) {
      Logger().e('Logout failed: $e');
    }
  }
}
