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
    return SizedBox(
      height: widget.height ?? AppStyles.standardHeight,
      child: TextFormField(
      maxLines: widget.maxLines,
      onTap: widget.onTab,
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscureCharacrter ?? '*',
      validator: widget.validator ?? _defaultValidator,
      cursorColor: AppColors.primaryColor,
      obscureText: widget.isPassword ? obscureText : false,
      style: const TextStyle(
        color: Colors.black,
        height: 1.0, // Add line height for proper vertical centering
      ),
      decoration: InputDecoration(
        // Solution 1: Use fixed values with minimal responsive scaling
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contenpaddingHorizontal ?? 16.w, // Fixed value
          vertical: widget.contenpaddingVertical ?? 12.h,     // Reduced for better centering
        ),

        // Alternative Solution 2: Use clamped responsive values with better centering
        // contentPadding: EdgeInsets.symmetric(
        //   horizontal: widget.contenpaddingHorizontal ?? (12.w).clamp(12.0, 20.0),
        //   vertical: widget.contenpaddingVertical ?? (12.h).clamp(10.0, 16.0),
        // ),

        filled: true,
        fillColor: widget.filColor ?? AppColors.fillColor,
        prefixIcon: widget.prifixicon,
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: toggle,
          child: _suffixIcon(obscureText ? AppIcons.eyeOffIcon : AppIcons.eyeIcon),
        )
            : widget.sufixicons,

        // Solution 3: Fixed icon constraints to prevent excessive scaling
        prefixIconConstraints: BoxConstraints(
          minHeight: AppStyles.standardHeight,
          minWidth: 48.w,  // Increased for better touch target
          maxHeight: AppStyles.standardHeight, // Match field height
          maxWidth: 56.w,
        ),
        suffixIconConstraints: BoxConstraints(
          minHeight: AppStyles.standardHeight,
          minWidth: 48.w,  // Increased for better touch target
          maxHeight: AppStyles.standardHeight, // Match field height
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
              fontSize: 14.sp, // Fixed font size for consistency
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