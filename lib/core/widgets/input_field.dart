import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class InputField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final String label;
  final String? Function(String?) validator;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final TextInputType textInputType;
  final bool notEditable;
  final bool enabled;
  final AutovalidateMode? autoValidate;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? formatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? filled;
  final bool showLabel;
  final bool grayOut;

  const InputField(
      {super.key,
        this.controller,
        required this.hint,
        required this.validator,
        this.notEditable = false,
        this.autoValidate,
        this.textInputType = TextInputType.text,
        this.focusNode,
        this.prefixIcon,
        this.maxLength,
        this.onChanged,
        this.formatters,
        this.onTap,
        this.suffixIcon,
        required this.label,
        this.filled,
        // this.readOnly = false,
        this.enabled = true,
        this.showLabel = true,
        this.grayOut = true,
        this.maxLines});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showLabel
            ? Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textNeutral2,
            fontSize: 14.sp,
          ),
        )
            : const SizedBox.shrink(),
        SizedBox(height: 6.h),
        Container(
          width: MediaQuery.of(context).size.width,
          color: widget.notEditable && widget.grayOut ? const Color(0xffEDEEF2) : null,
          child: TextFormField(
            enabled: widget.enabled,
            focusNode: widget.focusNode,
            cursorColor: AppColors.textNeutral2,
            controller: widget.controller,
            autocorrect: false,
            maxLines: widget.maxLines ?? 1,
            onTapOutside: (PointerDownEvent event) {
              FocusScope.of(context).unfocus();
            },
            autovalidateMode:
            widget.autoValidate ?? AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            onChanged: widget.onChanged,
            keyboardType: widget.textInputType,
            maxLength: widget.maxLength,
            readOnly: widget.notEditable,
            inputFormatters: widget.formatters,
            onTap: widget.onTap,
            decoration: InputDecoration(
              filled: widget.filled,
              fillColor: AppColors.textNeutral,
              counterText: "",
              prefix: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0.w,
                  color: AppColors.borderNeutral,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0.w,
                  color: AppColors.borderNeutral,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0.w,
                  color: AppColors.textNeutral2,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0.w,
                  color: AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0.w,
                  color: AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              disabledBorder: widget.notEditable ? null : OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0.w, color: AppColors.borderNeutral,),
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
            ),
            style: TextStyle(
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textNeutral2,
            ),
          ),
        ),
      ],
    );
  }
}
