import 'package:belema_test_app/core/widgets/custome_snackbar.dart';
import 'package:belema_test_app/core/widgets/input_field.dart';
import 'package:belema_test_app/features/pin/pint_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/routes/app_routes.dart';
import '../../core/utils/app_colors.dart';
import '../../core/widgets/primary_button.dart';

class SetPinScreen extends ConsumerStatefulWidget {
  const SetPinScreen({super.key});

  @override
  ConsumerState<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends ConsumerState<SetPinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Pin'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          const Divider(),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Reset PIN',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0.sp,
                      color: AppColors.textNeutral,
                    ),
                  ),
                ),
                SizedBox(height: 8.0.h),
                Center(
                  child: Text(
                    'Set your transaction PIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.textNeutral2,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 24.0.h),
                InputField(
                  controller: _newPinController,
                  hint: "New PIN",
                  label: "New PIN",
                  maxLength: 4,
                  textInputType: TextInputType.number,
                  validator: (String? value) {
                    if (value!.length != 4) {
                      return "PIN must be 4 digits";
                    }
                    return null;
                  }, // Ensure this validator exists
                ),
                SizedBox(height: 24.0.h),
                InputField(
                  controller: _confirmPinController,
                  hint: 'Confirm New PIN',
                  label: 'Confirm New PIN',
                  maxLength: 4,
                  textInputType: TextInputType.number,
                  validator: (String? value) {
                    if (_newPinController.text != _confirmPinController.text) {
                      return "PIN do not match";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50.0.h),
                PrimaryButton(
                  isLoading: _loading,
                  onPressed: _handleSetPin,
                  buttonText: 'Reset',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSetPin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);

    try {
      final pinService = ref.read(pinServiceProvider);
      final result = await pinService.setTransactionPin(
        pin: _newPinController.text.trim(),
        onError: (message) {
          MessageAlert.error(context: context, message: message);
        },
      );

      if (!mounted) return;

      if (result.success) {
        MessageAlert.success(context: context, message: 'PIN set successfully');
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.dashboardScreen,
              (route) => false,
            );
          }
        });
      } else {
        MessageAlert.error(context: context, message: result.message);
      }
    } catch (e) {
      if (mounted) {
        MessageAlert.error(
            context: context, message: 'An unexpected error occurred');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}
