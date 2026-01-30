import 'package:belema_test_app/core/models/bank_model.dart';
import 'package:belema_test_app/core/utils/nigerian_banks.dart';
import 'package:belema_test_app/core/widgets/custome_snackbar.dart';
import 'package:belema_test_app/features/transfer/transfer_service.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/states/app_states.dart';
import '../../core/utils/app_colors.dart';
import '../../core/widgets/dropdown_search_field.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/password_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../dashboard/dashboard_service.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  List<BanksModel> bankList = [];
  BanksModel? selectedBank;
  bool _loadingAccountDetails = false;
  bool _submittingTransfer = false;

  @override
  void initState() {
    super.initState();
    bankList = nigerianBanks;
  }

  @override
  void dispose() {
    _bankController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _amountController.dispose();
    _newPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          DropdownSearchField(
            controller: _bankController,
            down: true,
            dropdownData: bankList.map((e) => e.name!).toList(),
            hint: 'Select Bank',
            label: 'Bank',
            onSelected: (value) {
              selectedBank = bankList.firstWhere(
                (element) => element.name == value,
              );
              _accountNameController.clear();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a bank';
              }
              return null;
            },
          ),
          SizedBox(height: 24.0.h),
          InputField(
            label: 'Account Number',
            controller: _accountNumberController,
            hint: 'Account Number',
            maxLength: 10,
            autoValidate: AutovalidateMode.onUserInteraction,
            textInputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter account number';
              }
              if (value.length != 10) {
                return 'Account number must be 10 digits';
              }
              return null;
            },
            suffixIcon: _loadingAccountDetails
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LoadingAnimationWidget.inkDrop(
                      color: AppColors.primaryColor,
                      size: 20.0.w,
                    ),
                  )
                : null,
            onChanged: (String? value) {
              if (value!.length == 10) {
                _validateAccountNumber();
              }
            },
          ),
          SizedBox(height: 24.0.h),
          InputField(
            label: 'Account Name',
            controller: _accountNameController,
            hint: 'Verify account number',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please wait for account to be validated';
              }
              return null;
            },
            notEditable: true,
          ),
          SizedBox(height: 24.0.h),
          InputField(
            label: 'Amount',
            controller: _amountController,
            hint: 'Enter Amount',
            onChanged: (_) {
              setState(() {});
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an amount';
              }

              if (double.parse(value.replaceAll(',', '')) < 100) {
                return 'Amount must be greater than ₦100';
              }
              if (double.parse(value.replaceAll(',', '')) >
                  ref.watch(accountDetail).balance) {
                return 'Insufficient Account Balance';
              }

              return null;
            },
            autoValidate: AutovalidateMode.onUserInteraction,
            formatters: [
              CurrencyTextInputFormatter.currency(
                decimalDigits: 2,
                symbol: '',
              ),
            ],
            textInputType: TextInputType.number,
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: Text(
                '₦',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0.sp,
                  color: AppColors.textNeutral,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.0.h),
          InputField(
            controller: _newPinController,
            hint: "Enter Your PIN",
            label: "Transaction PIN",
            maxLength: 4,
            textInputType: TextInputType.number,
            validator: (String? value) {
              if (value!.length != 4) {
                return "PIN must be 4 digits";
              }
              return null;
            },
          ),
          SizedBox(height: 30.0.h),
          PrimaryButton(
            onPressed: _handleTransferSubmit,
            buttonText: 'Next',
            isLoading: _submittingTransfer,
          ),
        ],
      ),
    );
  }

  /// Validate account number and fetch account details
  /// this is a simulated function for demonstration purposes since there is no endpoint for this
  void _validateAccountNumber() async {
    if (selectedBank == null) {
      MessageAlert.error(
          context: context, message: 'Please select a bank first');
      return;
    }

    if (_accountNumberController.text.length != 10) {
      return;
    }

    setState(() {
      _loadingAccountDetails = true;
      _accountNameController.clear();
    });

    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay
      if (!mounted) return;
      setState(() {
        _accountNameController.text = 'John Doe'; // Simulated account name
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingAccountDetails = false;
        });
      }
    }
  }

  Future<void> _handleTransferSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submittingTransfer = true);

    try {
      final transferService = ref.read(transferServiceProvider);
      final amount = double.parse(_amountController.text.replaceAll(',', ''));

      final result = await transferService.submitTransfer(
        toAccount: '1000',

        ///i don't what is to be here so i used a dummy value
        amount: amount,
        pin: _newPinController.text,
        onError: (message) {
          MessageAlert.error(context: context, message: message);
        },
      );

      if (!mounted) return;

      if (result != null) {
        MessageAlert.success(
          context: context,
          message: 'Transfer successful - ID: ${result.transactionId}',
        );
        ref
            .read(dashboardServiceProvider)
            .getAccountDetails(ref: ref, onError: (message) {});
        _clearForm();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        MessageAlert.error(
            context: context, message: 'An unexpected error occurred');
      }
    } finally {
      if (mounted) {
        setState(() => _submittingTransfer = false);
      }
    }
  }

  /// Clear form fields
  void _clearForm() {
    _bankController.clear();
    _accountNumberController.clear();
    _accountNameController.clear();
    _amountController.clear();
    _newPinController.clear();
    setState(() {
      selectedBank = null;
    });
  }
}
