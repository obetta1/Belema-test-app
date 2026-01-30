
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class MessageAlert {
  static void error({
    required BuildContext context,
    required String message,
    bool popTwice = false,
  }) {
    Timer timer = Timer(const Duration(seconds: 3), () {
      Navigator.pop(context);
      if (popTwice) Navigator.pop(context);
    });

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SafeArea(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 50,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.splashBGColor),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_outlined, color: AppColors.red,),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: Text(
                          message,
                          style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textNeutral),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    timer.cancel();
                    Navigator.of(context).pop();
                    if (popTwice) Navigator.of(context).pop();
                  },
                  child: Container(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void success({
    required BuildContext context,
    required String message,
    bool popTwice = false,
  }) {
    Timer timer = Timer(const Duration(seconds: 3), () {
      Navigator.pop(context);
      if (popTwice) Navigator.pop(context);
    });

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SafeArea(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 50,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                      color: AppColors.splashBGColor
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: AppColors.green,),
                      SizedBox(width: 10.0.w),
                      Expanded(
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    timer.cancel();
                    Navigator.of(context).pop();
                    if (popTwice) Navigator.of(context).pop();
                  },
                  child: Container(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}