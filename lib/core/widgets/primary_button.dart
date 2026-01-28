
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final Widget? suffixIcon;
  final double? width;
  final Color? color;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.color,
    this.suffixIcon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading || isDisabled ? () {} : onPressed,
      child: Container(
        height: 48.h,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0.r),
          color: isDisabled
              ? color != null
              ? color!.withOpacity(0.5)
              : AppColors.primaryColor.withOpacity(0.5)
              : isLoading
              ? color != null
              ? color!.withOpacity(0.5)
              : AppColors.primaryColor.withOpacity(0.6)
              : color ?? AppColors.primaryColor,
        ),
        child: isLoading
            ? Center(
          child: LoadingAnimationWidget.inkDrop(
            color: Colors.white,
            size: 18.0.w,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null) SizedBox(width: 10.0.w),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w500,
                color: textColor ?? Colors.white,
              ),
            ),
            if (suffixIcon != null) SizedBox(width: 10.0.w),
            if (suffixIcon != null) suffixIcon!,
          ],
        ),
      ),
    );
  }
}
