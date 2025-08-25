import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';


class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
        this.color,
        this.borderColor,
        this.textStyle,
        this.padding = EdgeInsets.zero,
        required this.onTap,
        required this.text,
        this.loading = false,
        this.width,
        this.height,
        this.textColor});
  final Function() onTap;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    // Determine the final border color based on your logic
    final finalBorderColor = borderColor ?? (color ?? AppColors.buttonColor);

    return Padding(
        padding: padding,
        child: ElevatedButton(
          onPressed: loading ? () {} : onTap,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: finalBorderColor),
                borderRadius: BorderRadius.circular(8.r)),
            backgroundColor: color ?? AppColors.buttonColor,
            minimumSize: Size(width ?? Get.width, height ?? 50.h),
          ),
          child: loading
              ? SizedBox(
            height: 20.h,
            width: 20.h,
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          )
              : CustomText(
              text: text,
              fontWeight: FontWeight.w500,
              fontsize: 16.sp,
              color: textColor ?? Colors.black),
        ));
  }
}