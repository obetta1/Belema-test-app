import 'package:belema_test_app/core/routes/app_routes.dart';
import 'package:belema_test_app/core/utils/validator.dart';
import 'package:belema_test_app/features/auth/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custome_snackbar.dart';
import '../../../core/widgets/input_field.dart';
import '../../../core/widgets/password_input_field.dart';
import '../../../core/widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.0.h),
          Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24.0.sp,
              color: AppColors.textNeutral,
            ),
          ),
          SizedBox(height: 40.0.h),
          _buildForm(),
          SizedBox(height: 40.0.h),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputField(
            formatters: [LengthLimitingTextInputFormatter(10)],
            textInputType: TextInputType.text,
            controller: _userNameController,
            autoValidate: AutovalidateMode.onUserInteraction,
            hint: 'Enter Your User name',
            label: 'User Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          SizedBox(height: 24.0.h),
          PasswordInputField(
            isConfirmPassword: true,
            controller: _passwordController,
            hint: 'Enter Your Password',
            label: 'Password',
            validator: (value) => Validator.validatePassword(value),
          ),
          SizedBox(height: 40.0.h),
          PrimaryButton(
            buttonText: 'Login',
            onPressed: _handleLogin,
            isLoading: _loading,
          ),
          SizedBox(height: 20.0.h),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);

    try {
      final authService = ref.read(authProvider);
      final result = await authService.login(
        username: _userNameController.text.trim(),
        password: _passwordController.text.trim(),
        ref: ref,
        onError: (message) {
          MessageAlert.error(context: context, message: message);
        },
      );

      if (!mounted) return;

      if (result['success']) {
        final hasPin = result['hasPin'] as bool;
        if (hasPin) {
          // User has PIN set - navigate to dashboard
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboardScreen,
            (route) => false,
          );
        } else {
          // User doesn't have PIN - show dialog to set PIN
          _showSetPinDialog();
        }
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

  /// this is used to show dialog to prompt setting transaction PIN
  void _showSetPinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Set Transaction PIN'),
          content: const Text(
            'You need to set a transaction PIN to proceed. Would you like to set it now?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Navigate to set PIN screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.setTransactionPin,
                  (route) => false,
                );
              },
              child: const Text(
                'Set PIN',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.dashboardScreen);
              },
              child: const Text('Later'),
            ),
          ],
        );
      },
    );
  }
}
