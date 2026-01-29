
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/app_colors.dart';

class DropdownSearchField extends StatefulWidget {
  final String hint;
  final String label;
  final String? Function(String? value) validator;
  final void Function(String value) onSelected;
  final TextEditingController controller;
  final List<String> dropdownData;
  final bool down;
  final bool readOnly;
  final bool enabled;
  final bool? loading;

  const DropdownSearchField({
    super.key,
    required this.hint,
    required this.label,
    required this.validator,
    required this.controller,
    required this.onSelected,
    required this.dropdownData,
    this.down = false,
    this.readOnly = false,
    this.enabled = true,
    this.loading,
  });

  @override
  State<DropdownSearchField> createState() => _DropdownSearchFieldState();
}

class _DropdownSearchFieldState extends State<DropdownSearchField> {
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
        Container(
          color: widget.readOnly ? const Color(0xffEDEEF2) : null,
          child: TypeAheadField(
            suggestionsCallback: (pattern) {
              return widget.dropdownData
                  .where((data) =>
                  data.toLowerCase().contains(pattern.toLowerCase()))
                  .toList();
            },
            builder: (context, controller, focusNode) {
              return TextFormField(
                enabled: widget.enabled,
                controller: controller,
                focusNode: focusNode,
                validator: widget.validator,
                readOnly: widget.readOnly,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      controller.clear();
                      focusNode.requestFocus();
                    },
                    child: (widget.loading ?? false)
                        ? LoadingAnimationWidget.inkDrop(
                      color: AppColors.primaryColor,
                      size: 18.0.w,
                    )
                        : const Icon(Icons.arrow_drop_down),
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
                  disabledBorder: widget.readOnly
                      ? OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0.w,
                      color: AppColors.borderNeutral,
                    ),
                    borderRadius: BorderRadius.circular(4.0.r),
                  )
                      : InputBorder.none,
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
              );
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            onSelected: (suggestion) {
              try {
                widget.controller.text = suggestion;
                widget.onSelected(suggestion);
              } catch (_) {}
            },
            controller: widget.controller,
            hideKeyboardOnDrag: true,
            direction:
            widget.down ? VerticalDirection.down : VerticalDirection.up,
          ),
        ),
      ],
    );
  }
}
