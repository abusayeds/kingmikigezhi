import 'package:event_sharing/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../../utils/style.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscureCharacrter;
  final Color? filColor;
  final int? maxLines;
  final Widget? prifixicon;
  final String? labelText;
  final String? hintText;
  final double? contenpaddingHorizontal;
  final double? contenpaddingVertical;
  final Widget? sufixicons;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTab;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final TextStyle? hintTextStyle;
  final Color? borderColor; // Added border color parameter
  final double? height; // Standard height parameter

  const CustomTextField({
    super.key,
    this.contenpaddingHorizontal,
    this.contenpaddingVertical,
    this.hintText,
    this.prifixicon,
    this.sufixicons,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.isEmail,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscureCharacrter = '*',
    this.filColor,
    this.maxLines = 1,
    this.labelText,
    this.isPassword = false,
    this.readOnly = false,
    this.onTab,
    this.hintTextStyle,
    this.borderColor, // Added to constructor
    this.height, // Added height parameter
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMultiLine = (widget.maxLines ?? 1) > 1;
    final lines = widget.maxLines ?? 1;
    // Don't multiply the full single-line field height by maxLines —
    // that made Note/Description fields huge with empty space inside.
    final fieldHeight = widget.height ??
        (isMultiLine
            ? (AppStyles.standardHeight + (18.h * (lines - 1)))
            : AppStyles.standardHeight);
    return SizedBox(
      height: fieldHeight,
      child: TextFormField(
        maxLines: widget.maxLines,
        textAlignVertical:
            isMultiLine ? TextAlignVertical.top : TextAlignVertical.center,
        onTap: widget.onTab,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        readOnly: widget.readOnly ?? false,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscuringCharacter: widget.obscureCharacrter ?? '*',
        validator: widget.validator ?? _defaultValidator,
        cursorColor: AppColors.primaryColor,
        obscureText: widget.isPassword ? obscureText : false,
        enableInteractiveSelection:
            !(widget.readOnly ?? false) || widget.onTab != null,
        style: TextStyle(
          color: Colors.black,
          fontSize: 13.sp,
          height: isMultiLine ? 1.35 : 1.0,
        ),
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: isMultiLine,
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.contenpaddingHorizontal ?? 16.w,
            vertical:
                widget.contenpaddingVertical ?? (isMultiLine ? 10.h : 12.h),
          ),
          filled: true,
          fillColor: widget.filColor ?? AppColors.fillColor,
          prefixIcon: widget.prifixicon,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: toggle,
                  child: _suffixIcon(
                      obscureText ? AppIcons.eyeOffIcon : AppIcons.eyeIcon),
                )
              : widget.sufixicons,
          prefixIconConstraints: BoxConstraints(
            minHeight: isMultiLine ? 24.h : AppStyles.standardHeight,
            minWidth: 48.w,
            maxHeight: isMultiLine ? 40.h : AppStyles.standardHeight,
            maxWidth: 56.w,
          ),
          suffixIconConstraints: BoxConstraints(
            minHeight: isMultiLine ? 24.h : AppStyles.standardHeight,
            minWidth: 48.w,
            maxHeight: isMultiLine ? 40.h : AppStyles.standardHeight,
            maxWidth: 56.w,
          ),
          errorStyle: const TextStyle(color: Colors.red),
          suffixIconColor: AppColors.primaryColor,
          prefixIconColor: AppColors.primaryColor,
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: widget.hintTextStyle ??
              TextStyle(
                color: AppColors.hintColor,
                fontFamily: 'Poppins',
                fontSize: 13.sp,
              ),
          border: _buildOutlineInputBorder(),
          errorBorder: _buildOutlineInputBorder(),
          focusedBorder: _buildOutlineInputBorder(),
          enabledBorder: _buildOutlineInputBorder(),
          disabledBorder: _buildOutlineInputBorder(),
        ),
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (widget.isEmail == null) {
      if (value?.isEmpty ?? true) {
        return "Please enter ${widget.hintText?.toLowerCase() ?? 'value'}";
      } else if (widget.isPassword) {
        bool data = AppConstants.passwordValidator.hasMatch(value!);
        if (value.isEmpty) {
          return "Please enter ${widget.hintText?.toLowerCase() ?? 'password'}";
        } else if (!data) {
          return "Insecure password detected.";
        }
      }
    } else {
      bool data = AppConstants.emailValidator.hasMatch(value ?? '');
      if (value?.isEmpty ?? true) {
        return "Please enter ${widget.hintText?.toLowerCase() ?? 'email'}";
      } else if (!data) {
        return "Please check your email!";
      }
    }
    return null;
  }

  Widget _suffixIcon(String icon) {
    return Container(
      // Solution 4: Fixed container size for suffix icon
      width: 48.w,
      height: 32.h,
      alignment: Alignment.centerRight, // Changed from center to centerRight
      padding: const EdgeInsets.only(right: 12.0), // Added right padding
      child: SvgPicture.asset(
        icon,
        color: AppColors.primaryColor,
        width: 20.w,  // Fixed icon size
        height: 20.h,
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0), // Fixed border radius
      borderSide: BorderSide(
        width: 1.w, // Fixed border width
        color: widget.borderColor ?? AppColors.primaryColor, // Use custom border color or fallback to primary color
      ),
    );
  }
}