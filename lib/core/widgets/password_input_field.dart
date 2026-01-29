import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String label;
  final String? Function(String?) validator;
  final bool isConfirmPassword;
  final List<TextInputFormatter>? formatters;
  final TextInputType textInputType;
  final ValueChanged<String>? onChange;

  const PasswordInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.validator,
    this.isConfirmPassword = false,
    this.formatters,
    this.textInputType = TextInputType.text,
    this.onChange,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  final FocusNode _focus = FocusNode();
  bool _containsUpperCase = false;
  bool _lengthOf8 = false;
  bool _containsLowerCase = false;
  bool _containsNumber = false;
  bool _containsSpecialCharacter = false;

  @override
  void initState() {
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focus.dispose();
    _focus.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void validate(value) {
    final upperCase = RegExp(r".*[A-Z].*");
    final lowerCase = RegExp(r".*[a-z].*");
    final number = RegExp(r".*[0-9].*");
    final specialCharacter = RegExp(r"[`!@#$%^&*()_+\-=\[\]{};':\\|,.<>\/?~]");

    if (upperCase.hasMatch(value)) {
      _containsUpperCase = true;
    } else {
      _containsUpperCase = false;
    }

    if (value.length > 7) {
      _lengthOf8 = true;
    } else {
      _lengthOf8 = false;
    }

    if (lowerCase.hasMatch(value)) {
      _containsLowerCase = true;
    } else {
      _containsLowerCase = false;
    }

    if (number.hasMatch(value)) {
      _containsNumber = true;
    } else {
      _containsNumber = false;
    }

    if (specialCharacter.hasMatch(value)) {
      _containsSpecialCharacter = true;
    } else {
      _containsSpecialCharacter = false;
    }

    setState(() {});
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textNeutral2,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.textInputType,
            inputFormatters: widget.formatters,
            focusNode: _focus,
            cursorColor: AppColors.textNeutral2,
            controller: widget.controller,
            autocorrect: false,
            validator: widget.validator,
            onChanged: widget.onChange ?? validate,
            obscureText: _obscureText,
            onTapOutside: (PointerDownEvent event) {
              FocusScope.of(context).unfocus();
            },
            style: TextStyle(
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textNeutral2,
            ),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1.0,
                  color: AppColors.borderNeutral,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1.0,
                  color: AppColors.textNeutral2,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1.0,
                  color: AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1.0,
                  color: AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              errorMaxLines: 3,
              contentPadding: EdgeInsets.fromLTRB(
                12.0.w,
                15.0.h,
                12.0.w,
                15.0.h,
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  child: _obscureText
                      ? Icon(
                          Icons.visibility_off,
                          color: AppColors.textNeutral2,
                        )
                      : Icon(
                          Icons.visibility,
                          color: AppColors.textNeutral2,)
                ),
                onTap: () => setState(() {
                  _obscureText = !_obscureText;
                }),
              ),
            ),
          ),
        ),
        if (_focus.hasFocus && !widget.isConfirmPassword)
          _buildPasswordConditions(),
      ],
    );
  }

  Widget _buildPasswordConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0.h),
        Row(
          children: [
            Icon(_containsUpperCase ? Icons.check : Icons.close,
                color: _containsUpperCase
                    ? const Color(0xff44AC21)
                    : AppColors.red),
            SizedBox(width: 10.0.w),
            FittedBox(
              child: Text(
                "Minimum of one uppercase letter",
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff999999),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0.h),
        Row(
          children: [
            Icon(_lengthOf8 ? Icons.check : Icons.close,
                color: _lengthOf8
                    ? const Color(0xff44AC21)
                    : AppColors.red),
            SizedBox(width: 10.0.w),
            FittedBox(
              child: Text(
                "Must be greater than 7 characters",
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff999999),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0.h),
        Row(
          children: [
            Icon(_containsLowerCase ? Icons.check : Icons.close,
                color: _containsLowerCase
                    ? const Color(0xff44AC21)
                    : AppColors.red),
            SizedBox(width: 10.0.w),
            FittedBox(
              child: Text(
                "Minimum of one lowercase letter",
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff999999),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0.h),
        Row(
          children: [
            Icon(_containsNumber ? Icons.check : Icons.close,
                color: _containsNumber
                    ? const Color(0xff44AC21)
                    : AppColors.red),
            SizedBox(width: 10.0.w),
            FittedBox(
              child: Text(
                "Minimum of one number",
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff999999),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0.h),
        Row(
          children: [
            Icon(_containsSpecialCharacter ? Icons.check : Icons.close,
                color: _containsSpecialCharacter
                    ? const Color(0xff44AC21)
                    : AppColors.red),
            SizedBox(width: 10.0.w),
            FittedBox(
              child: Text(
                "Minimum of one special character",
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff999999),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
