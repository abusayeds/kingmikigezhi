import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_images.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.onboardingBg), fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //=========================> Text Section <=======================
                SizedBox(height: 300.h),
                CustomText(
                  text: AppStrings.yourEvent,
                  color: Colors.white,
                  fontsize: 22.sp,
                  fontWeight: FontWeight.w700,
                  bottom: 16.h,
                ),
                CustomText(
                  text: AppStrings.letStart,
                  bottom: 32.h,
                  color: Colors.white,
                ),
                //========================> Get Start Button <====================
                CustomButton(
                  onTap: () {
                  Get.toNamed(AppRoutes.onboardSecondScreen);
                },
                  text: AppStrings.getStart, color: Colors.white,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
