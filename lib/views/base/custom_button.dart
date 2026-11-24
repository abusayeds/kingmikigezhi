import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/style.dart';


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
        this.enabled = true,
        this.width,
        this.height,
        this.textColor});
  final Function() onTap;
  final String text;
  final bool loading;
  final bool enabled;
  final double? height;
  final double? width;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled || loading;
    final baseColor = color ?? AppColors.buttonColor;
    final finalBorderColor = borderColor ?? baseColor;
    final bgColor = (!enabled && !loading)
        ? AppColors.greyColor
        : baseColor;

    return Padding(
        padding: padding,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onTap,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: bgColor,
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: finalBorderColor),
                borderRadius: BorderRadius.circular(8.r)),
            backgroundColor: bgColor,
            minimumSize: Size(width ?? Get.width, height ?? AppStyles.standardHeight),
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