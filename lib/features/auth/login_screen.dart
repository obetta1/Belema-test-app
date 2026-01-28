import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/app_colors.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/password_input_field.dart';
import '../../core/widgets/primary_button.dart';

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
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: _buildBody()
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Center(
            child: Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24.0.sp,
                color: AppColors.textNeutral,
              ),
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
            textInputType: TextInputType.number,
            controller: _userNameController,
            autoValidate: AutovalidateMode.onUserInteraction,
            hint: 'Enter Your User name',
            label: 'User Name',
            maxLength: 10,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your  User name';
              }
              if (value.length != 6 && value.length != 10) {
                return ' User name must be 6 or 10 Digits';
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(height: 40.0.h),
          PrimaryButton(
            buttonText: 'Login',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Perform login action
              }
            },
            isLoading: _loading,
          ),
          SizedBox(height: 20.0.h),
        ],
      ),
    );
  }
}
