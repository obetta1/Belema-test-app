


import 'package:belema_test_app/core/models/account_details_model.dart';
import 'package:belema_test_app/core/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletBalance = StateProvider<double>((ref) => 0.0);
final transactions = StateProvider<List<Transaction>>((ref) => []);
final accountDetail = StateProvider<AccountDetailsResponse>((ref) => AccountDetailsResponse(
      accountNumber: '',
      balance: 0,
    ));
