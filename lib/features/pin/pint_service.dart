import 'package:belema_test_app/core/api/newtwork_repository.dart';
import 'package:belema_test_app/core/api/ntwork_repository_imp.dart';
import 'package:belema_test_app/core/models/set_pin_response_model.dart';
import 'package:belema_test_app/core/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final pinServiceProvider = Provider<PinServiceProvider>((ref) {
  return PinServiceProvider();
});

class PinServiceProvider {
  NetworkRepository networkRepository = NetworkImplementation();

  /// Set transaction PIN
  /// Returns SetPinResponse with success status and message
  Future<SetPinResponse> setTransactionPin({
    required String pin,
    required void Function(String message) onError,
  }) async {
    try {
      var response = await networkRepository.post(
        '$baseUrl/set-transaction-pin',
        form: {
          'pin': pin,
        },
      );

      final setPinResponse = SetPinResponse.fromJson(response);
      Logger().d('PIN set successfully');
      return setPinResponse;
    } catch (e, t) {
      Logger().e('Set PIN failed: $e', stackTrace: t);
      onError('Failed to set PIN: $e');
      return SetPinResponse(
        success: false,
        message: 'Failed to set PIN',
      );
    }
  }
}
