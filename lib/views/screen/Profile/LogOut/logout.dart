import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../helpers/route.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
        title: Text(
          "Confirm Logout !",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        content: const CustomText(
          text: "Are you sure that you want to log out?",
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("No",style: TextStyle(fontSize: 20.sp, color: Colors.grey),
              )),
          TextButton(
              onPressed: () async {
                /* await PrefsHelper.remove(AppConstants.role);
                await PrefsHelper.remove(AppConstants.isLogged);
                await PrefsHelper.remove(AppConstants.bearerToken);
                await PrefsHelper.remove(AppConstants.userId);*/
                Get.offAllNamed(AppRoutes.signInScreen);

              },
              child: Text(
                "Yes",
                style:
                TextStyle(fontSize: 20.sp, color: AppColors.primaryColor),
              )),
        ],
        elevation: 12.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(width: 1.w, color: AppColors.primaryColor)));
  }
}
