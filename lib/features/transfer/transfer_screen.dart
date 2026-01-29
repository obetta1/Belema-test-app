import 'package:belema_test_app/core/models/bank_model.dart';
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

class TransferScreen extends ConsumerStatefulWidget{
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  List<BanksModel> bankList = [];
  BanksModel? selectedBank;
  bool _loadingAccountDetails = false;

  void _validateAccountNumber() async {
    setState(() {
      _loadingAccountDetails = true;
    });

    // Simulate an API call to validate the account number
    await Future.delayed(const Duration(seconds: 2));

    // For demonstration, I assume the account number is valid and set a dummy account name
    setState(() {
      _accountNameController.text = 'John Doe';
      _loadingAccountDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text('Transfer')),
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
            dropdownData:bankList.map((e) => e.name!).toList(),
            hint: 'Select Bank',
            label: 'Bank',
            onSelected: (value) {
              selectedBank = bankList.firstWhere(
                    (element) => element.name == value,
              );
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
            autoValidate: AutovalidateMode.onUserInteraction,
            textInputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter account number';
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
              if (value!.length == 10) _validateAccountNumber();
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
                  ref.watch(walletBalance)) {
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
          PasswordInputField(
            controller: _newPinController,
            hint: "Enter Your PIN",
            label: "Transaction PIN",
            validator: (String? value) {
              if (value!.length != 4) {
                return "PIN must be 4 digits";
              }
              return null;
            }, // Ensure this validator exists
          ),
          SizedBox(height: 30.0.h),
          PrimaryButton(
            onPressed: (){},
            buttonText: 'Next',
          ),
        ],
      ),
    );
  }
}
