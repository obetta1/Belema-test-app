import 'package:belema_test_app/core/api/newtwork_repository.dart';
import 'package:belema_test_app/core/api/ntwork_repository_imp.dart';
import 'package:belema_test_app/core/models/set_pin_response_model.dart';
import 'package:belema_test_app/core/utils/constants.dart';
import 'package:belema_test_app/core/utils/device_binding_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final pinServiceProvider = Provider<PinServiceProvider>((ref) {
  return PinServiceProvider();
});

class PinServiceProvider {
  NetworkRepository networkRepository = NetworkImplementation();

  /// Set transaction PIN with device binding
  Future<SetPinResponse> setTransactionPin({
    required String pin,
    required void Function(String message) onError,
  }) async {
    try {
      // Check if device is already bound
      final isBound = await DeviceBindingService.isDeviceBound();

      Map<String, String>? deviceBindingData;

      if (!isBound) {
        // Initialize device binding for first-time setup
        deviceBindingData =
            await DeviceBindingService.initializeDeviceBinding(pin);
        if (deviceBindingData == null) {
          onError('Failed to initialize device security');
          return SetPinResponse(
            success: false,
            message: 'Failed to initialize device security',
          );
        }
      } else {
        // Device already bound, just encrypt PIN for existing binding
        final encryptedPin = await DeviceBindingService.verifyPin(pin);
        if (encryptedPin == null) {
          onError('Invalid PIN for device binding');
          return SetPinResponse(
            success: false,
            message: 'Invalid PIN for device binding',
          );
        }
        deviceBindingData = {
          'encryptedPin': encryptedPin,
        };
      }

      ///if the device binding has been implemented on the backend, the encryptedPin,
      /// the deviceId and privateKey will be included in the payload
      final payload = {
        'pin': deviceBindingData['encryptedPin'],
        if (deviceBindingData.containsKey('deviceId'))
          'deviceId': deviceBindingData['deviceId'],
        if (deviceBindingData.containsKey('privateKey'))
          'privateKey': deviceBindingData['privateKey'],
      };


      final payload2 = {
        'pin': pin,
      };


      var response = await networkRepository.post(
        '$baseUrl/set-transaction-pin',
        form: payload2,
      );

      final setPinResponse = SetPinResponse.fromJson(response);

      if (setPinResponse.success) {
        Logger().d('PIN set successfully with device binding');
      }

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
