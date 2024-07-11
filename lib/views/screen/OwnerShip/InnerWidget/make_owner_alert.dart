import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';

class MakeOwnerAlert extends StatelessWidget {
  const MakeOwnerAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: 'Are you Sure Family Ownership',
              fontsize: 16.sp,
              maxline: 2,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    width: 87.w,
                    height: 40.h,
                    child: CustomButton(
                      text: 'No',
                      onTap: () {
                        Get.back();
                      },
                      color: Colors.white,
                      textStyle: TextStyle(color: AppColors.primaryColor),
                    )),
                SizedBox(width: 10.w),
                SizedBox(
                    width: 87.w,
                    height: 40.h,
                    child: CustomButton(
                        text: 'Yes',
                        textColor: Colors.white,
                        onTap: () {
                          Get.back();
                        })),
              ],
            )
          ],
        ),
        elevation: 12.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(width: 1.w, color: AppColors.primaryColor)));
  }
}
