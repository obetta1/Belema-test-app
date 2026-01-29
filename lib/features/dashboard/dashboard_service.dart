import 'package:belema_test_app/core/api/newtwork_repository.dart';
import 'package:belema_test_app/core/api/ntwork_repository_imp.dart';
import 'package:belema_test_app/core/models/transaction_model.dart';
import 'package:belema_test_app/core/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../core/models/account_details_model.dart';
import '../../core/states/app_states.dart';

final dashboardServiceProvider = Provider<DashboardServiceProvider>((ref) {
  return DashboardServiceProvider();
});


class DashboardServiceProvider {
  NetworkRepository networkRepository = NetworkImplementation();

  /// Fetch transactions for the user
  /// Returns list of Transaction objects
  Future<List<Transaction>> getTransactions({
    required WidgetRef ref,
    required void Function(String message) onError,
  }) async {
    try {
      var response = await networkRepository.get(
        '$baseUrl/get-transactions',
      );
      final transactionsResponse = TransactionsResponse.fromJson(response);
      ref.read(transactions.notifier).state = transactionsResponse.transactions;
      return transactionsResponse.transactions;
    } catch (e, t) {
      Logger().e('Get transactions failed: $e', stackTrace: t);
      onError('Failed to fetch transactions: $e');
      return [];
    }
  }

  Future<AccountDetailsResponse?> getAccountDetails({
    required WidgetRef ref,
    required void Function(String message) onError,
  }) async {
    try {
      var response = await networkRepository.get(
        '$baseUrl/get-account-details',
      );

      final accountDetails = AccountDetailsResponse.fromJson(response);
      ref.read(accountDetail.notifier).state = accountDetails;
      return accountDetails;
    } catch (e, t) {
      Logger().e('Get account details failed: $e', stackTrace: t);
      onError('Failed to validate account: $e');
      return null;
    }
  }
}
