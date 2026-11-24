import 'package:event_sharing/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Small inline spinner for API-backed dropdown fields.
/// Show only while the first load is in progress — keep the field visible.
class DropdownFieldLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const DropdownFieldLoader({
    super.key,
    this.size = 14,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: CircularProgressIndicator(
        strokeWidth: 1.8,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primaryColor,
        ),
      ),
    );
  }
}
