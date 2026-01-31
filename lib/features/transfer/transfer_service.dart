import 'package:belema_test_app/core/api/newtwork_repository.dart';
import 'package:belema_test_app/core/api/ntwork_repository_imp.dart';
import 'package:belema_test_app/core/models/account_details_model.dart';
import 'package:belema_test_app/core/models/transfer_response_model.dart';
import 'package:belema_test_app/core/utils/constants.dart';
import 'package:belema_test_app/core/utils/device_binding_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final transferServiceProvider = Provider<TransferServiceProvider>((ref) {
  return TransferServiceProvider();
});

class TransferServiceProvider {
  NetworkRepository networkRepository = NetworkImplementation();

  /// Get account details by account number and bank code
  /// Returns AccountDetailsResponse with account name, number, and bank code
  Future<AccountDetailsResponse?> getAccountDetails({
    required String accountNumber,
    required String bankCode,
    required void Function(String message) onError,
  }) async {
    try {
      var response = await networkRepository.get(
        '$baseUrl/get-account-details?accountNumber=$accountNumber&bankCode=$bankCode',
      );

      final accountDetails = AccountDetailsResponse.fromJson(response);
      return accountDetails;
    } catch (e, t) {
      Logger().e('Get account details failed: $e', stackTrace: t);
      onError('Failed to validate account: $e');
      return null;
    }
  }

  /// Verify PIN with device binding and rate limiting
  Future<Map<String, dynamic>> verifyPinForTransfer({
    required String enteredPin,
    required void Function(String message) onError,
  }) async {
    try {
      // Check if account should be locked due to too many attempts
      final shouldLock = await DeviceBindingService.shouldLockAccount();
      if (shouldLock) {
        // Send account lock request to backend
        await _lockAccount();
        return {
          'success': false,
          'message': 'Account locked due to multiple failed attempts',
          'locked': true,
        };
      }

      // Verify PIN using device binding
      final encryptedPin = await DeviceBindingService.verifyPin(enteredPin);

      if (encryptedPin == null || encryptedPin.isEmpty) {
        final attempts = await DeviceBindingService.getPinAttempts();
        final remainingAttempts = 3 - attempts;

        if (remainingAttempts <= 0) {
          await _lockAccount();
          return {
            'success': false,
            'message': 'Account locked due to multiple failed attempts',
            'locked': true,
          };
        }

        return {
          'success': false,
          'message': 'Invalid PIN. $remainingAttempts attempts remaining.',
          'locked': false,
        };
      }

      // PIN verified successfully
      return {
        'success': true,
        'encryptedPin': encryptedPin,
        'locked': false,
      };
    } catch (e, t) {
      Logger().e('PIN verification failed: $e', stackTrace: t);
      onError('PIN verification failed: $e');
      return {
        'success': false,
        'message': 'PIN verification failed',
        'locked': false,
      };
    }
  }

  /// Submit transfer with account details, amount, and PIN
  /// Returns TransferResponse with transaction ID and status
  Future<TransferResponse?> submitTransfer({
    required String accountNumber,
    required String toAccount,
    required double amount,
    required String pin,
    required void Function(String message) onError,
  }) async {
    try {
      // First verify PIN with device binding
      final pinVerification = await verifyPinForTransfer(
        enteredPin: pin,
        onError: onError,
      );

      if (!pinVerification['success']) {
        onError(pinVerification['message']);
        return null;
      }

      // PIN verified, proceed with transfer
      final encryptedPin = pinVerification['encryptedPin'];

      var response = await networkRepository.post(
        '$baseUrl/transfer',
        form: {
          'accountNumber': accountNumber,
          'toAccount': toAccount,
          'amount': amount,
          'pin': pin, ///if the device binding and encryption has been implemented on the backend, encryptedPin would be passed to the payload,
        },
      );

      final transferResponse = TransferResponse.fromJson(response);
      Logger().d('Transfer submitted: ${transferResponse}');
      return transferResponse;
    } catch (e, t) {
      Logger().e('Transfer failed: $e', stackTrace: t);
      onError('Transfer failed: $e');
      return null;
    }
  }

  /// Lock account due to too many failed PIN attempts
  Future<void> _lockAccount() async {
    try {
      // Send account lock request to backend
      await networkRepository.post(
        '$baseUrl/lock-account',
        form: {},
      );

      // Clear device binding data
      await DeviceBindingService.clearDeviceBinding();

      Logger().d('Account locked and device binding cleared');
    } catch (e) {
      Logger().e('Error locking account: $e');
    }
  }
}