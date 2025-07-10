import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
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
            image: AssetImage(AppImages.onboardingBg),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),
                //=========================> Text Section <=======================
                // SizedBox(height: 150.h),
                CustomText(
                  text: 'What is Dai Wa Bu Yi?',
                  color: Colors.white,
                  fontsize: 22.sp,
                  fontWeight: FontWeight.w900,
                  bottom: 16.h,
                ),
                CustomText(
                  text: 'This is a first platform for parents to manage and share activities and events for their families:',
                  maxline: 15,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  color: Colors.white,
                  fontsize: 12.sp,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 8.w),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Event Calendars:',
                      textAlign: TextAlign.start,
                      color: Colors.white,
                      fontsize: 12.sp,
                    ),
                  ],
                ),
                CustomText(
                  left: 16.w,
                  text: 'Shared calendars for tracking family activities and appointments.',
                  maxline: 5,
                  textAlign: TextAlign.start,
                  color: Colors.white,
                  fontsize: 12.sp,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 8.w),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Activity Suggestions: ',
                      textAlign: TextAlign.start,
                      color: Colors.white,
                      fontsize: 12.sp,
                    ),
                  ],
                ),
                CustomText(
                  left: 16.w,
                  text: 'Recommendations for local events and activities based on interests.',
                  maxline: 5,
                  textAlign: TextAlign.start,
                  color: Colors.white,
                  fontsize: 12.sp,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 8.w),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Resource Sharing: ',
                      textAlign: TextAlign.start,
                      color: Colors.white,
                      fontsize: 12.sp,
                    ),
                  ],
                ),
                CustomText(
                  left: 16.w,
                  text: 'Sections for sharing parenting tips, local services, and educational materials.',
                  maxline: 5,
                  textAlign: TextAlign.start,
                  color: Colors.white,
                  fontsize: 12.sp,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 8.w),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: 'Customizable Profiles: ',
                      textAlign: TextAlign.start,
                      color: Colors.white,
                      fontsize: 12.sp,
                    ),
                  ],
                ),
                CustomText(
                  left: 16.w,
                  text: 'Individual profiles for tracking personal schedules and preferences.',
                  maxline: 5,
                  textAlign: TextAlign.start,
                  color: Colors.white,
                  fontsize: 12.sp,
                ),
                SizedBox(height: 89.h),
                //========================> Get Start Button <====================
                CustomButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.signInScreen);
                  },
                  text: AppStrings.getStart,
                  color: Colors.white,
                  borderColor: AppColors.buttonColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
