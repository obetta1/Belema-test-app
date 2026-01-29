import 'package:belema_test_app/core/api/newtwork_repository.dart';
import 'package:belema_test_app/core/api/ntwork_repository_imp.dart';
import 'package:belema_test_app/core/models/account_details_model.dart';
import 'package:belema_test_app/core/models/transfer_response_model.dart';
import 'package:belema_test_app/core/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final transferServiceProvider = Provider<TransferServiceProvider>((ref) {
  return TransferServiceProvider();
});

class TransferServiceProvider {
  NetworkRepository networkRepository = NetworkImplementation();

  Future<AccountDetailsResponse?> getAccountDetails({
    required void Function(String message) onError,
  }) async {
    try {
      var response = await networkRepository.get(
        '$baseUrl/get-account-details',
      );

      final accountDetails = AccountDetailsResponse.fromJson(response);
      return accountDetails;
    } catch (e, t) {
      Logger().e('Get account details failed: $e', stackTrace: t);
      onError('Failed to validate account: $e');
      return null;
    }
  }

  Future<TransferResponse?> submitTransfer({
    required String toAccount,
    required double amount,
    required String pin,
    required void Function(String message) onError,
  }) async {
    try {
      var response = await networkRepository.post(
        '$baseUrl/transfer',
        form: {
          'toAccount': toAccount,
          'amount': amount,
          'pin': pin,
        },
      );

      final transferResponse = TransferResponse.fromJson(response);
      return transferResponse;
    } catch (e, t) {
      Logger().e('Transfer failed: $e', stackTrace: t);
      onError('Transfer failed: $e');
      return null;
    }
  }
}
