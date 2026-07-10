import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';

class DottedBorderContainer extends StatelessWidget {
  final Widget child;

  const DottedBorderContainer({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: AppColors.primaryColor,
        strokeWidth: 1.w,
        radius: Radius.circular(8.r),
        dashPattern: const [6, 3],
        padding: EdgeInsets.zero,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        child: child,
      ),
    );
  }
}