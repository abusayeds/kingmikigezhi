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
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: Column(
            children: [
              //=========================> Scrollable Content <=======================
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      //=========================> Logo <=======================
                      Image.asset(
                        AppImages.appLogo,
                        height: 90.h,
                      ),
                      SizedBox(height: 32.h),
                      //=========================> Heading <=======================
                      CustomText(
                        text: 'Welcome to DaiWaBuYi\nGezhi Zhong!',
                        color: Colors.white,
                        fontsize: 24.sp,
                        fontWeight: FontWeight.w900,
                        textAlign: TextAlign.center,
                        bottom: 16.h,
                      ),
                      CustomText(
                        text: 'Thank you for joining DaiWaBuYi—a platform designed to help parents organize family activities, discover local events, and connect with the community.',
                        maxline: 15,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontsize: 12.sp,
                        bottom: 16.h,
                      ),
                      CustomText(
                        text: "Here's what you can do with DaiWaBuYi:",
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontsize: 13.sp,
                      ),
                      SizedBox(height: 20.h),
                      //=========================> Feature List <=======================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.circle, color: Colors.white, size: 8.w),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomText(
                              text: 'Create and share public events such as competitions, concerts, performances, shows, and other community activities.',
                              maxline: 5,
                              textAlign: TextAlign.start,
                              color: Colors.white,
                              fontsize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.circle, color: Colors.white, size: 8.w),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomText(
                              text: 'Manage shared family calendars to keep track of activities, appointments, and important events.',
                              maxline: 5,
                              textAlign: TextAlign.start,
                              color: Colors.white,
                              fontsize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.circle, color: Colors.white, size: 8.w),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomText(
                              text: 'Discover personalized local events and activities based on your interests.',
                              maxline: 5,
                              textAlign: TextAlign.start,
                              color: Colors.white,
                              fontsize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.circle, color: Colors.white, size: 8.w),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomText(
                              text: 'Share and explore community resources, including parenting tips, local services, and educational materials.',
                              maxline: 5,
                              textAlign: TextAlign.start,
                              color: Colors.white,
                              fontsize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(Icons.circle, color: Colors.white, size: 8.w),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomText(
                              text: 'Maintain individual profiles to organize personal schedules and preferences.',
                              maxline: 5,
                              textAlign: TextAlign.start,
                              color: Colors.white,
                              fontsize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      //=========================> Closing Note <=======================
                      CustomText(
                        text: "We're excited to have you as part of the DaiWaBuYi community and look forward to helping you stay connected and organized.",
                        maxline: 6,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontsize: 12.sp,
                        bottom: 16.h,
                      ),
                      CustomText(
                        text: 'If you have any questions or need assistance, feel free to contact us at support@wanerdao.com.',
                        maxline: 4,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontsize: 12.sp,
                        bottom: 16.h,
                      ),
                      CustomText(
                        text: 'Welcome aboard!',
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontsize: 13.sp,
                        bottom: 4.h,
                      ),
                      CustomText(
                        text: 'The Wanerdao Team',
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontsize: 12.sp,
                        bottom: 24.h,
                      ),
                      //=========================> Footer <=======================
                      CustomText(
                        text: 'Wanerdao',
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontsize: 12.sp,
                        bottom: 4.h,
                      ),
                      CustomText(
                        text: 'support@wanerdao.com',
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontsize: 12.sp,
                        bottom: 8.h,
                      ),
                      CustomText(
                        text: '© 2026 Wanerdao. All rights reserved.',
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontsize: 11.sp,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              //========================> Bottom Docked Button (navbar style) <====================
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                color: Colors.black.withOpacity(0.35),
                child: CustomButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.signInScreen);
                  },
                  text: AppStrings.getStart,
                  color: Colors.white,
                  borderColor: AppColors.buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}