import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import 'custom_text.dart';


class CustomListTile extends StatelessWidget {
  final String title;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final Color? titleColor;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  CustomListTile({
    super.key,
    required this.title,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
    this.backgroundColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color:backgroundColor,
              border: Border.all(
                  width: 1.w, color: borderColor ?? AppColors.borderColor)),
          child: ListTile(
            leading: prefixIcon,
            trailing: suffixIcon,
            horizontalTitleGap: 16.w,
            dense: true,
            title: Text(
              title,style: TextStyle(
                color: titleColor ?? AppColors.blackColor ,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
              maxLines: 2,
            )
          ),
        ),
      ),
    );
  }
}