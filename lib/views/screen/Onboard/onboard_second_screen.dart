import 'package:event_sharing/helpers/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';

class OnboardSecondScreen extends StatelessWidget {
  const OnboardSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.onboardingBg2), fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //=========================> Text Section <=======================
                SizedBox(height: 200.h),
                CustomText(
                  text: AppStrings.beautifulPlaces,
                  color: Colors.white,
                  fontsize: 22.sp,
                  maxline: 2,
                  fontWeight: FontWeight.w700,
                  bottom: 8.h,
                ),
                CustomText(
                  text: AppStrings.chooseYourDream,
                  bottom: 16.h,
                  color: Colors.white,
                  maxline: 2,
                ),
                //=====================> Continue With Google Button <==============
                GestureDetector(
                  onTap: (){},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 57.w, vertical: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(AppIcons.googleIcon),
                          CustomText(
                            text: AppStrings.continueWithGoogle,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontsize: 16.sp,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //========================> Sign Up Button <====================
                SizedBox(height: 16.h),
                CustomButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.createAccountScreen);
                  },
                  text: AppStrings.signUp,
                  color: Colors.white,
                ),
                //========================> Log In Button <====================
                SizedBox(height: 32.h),
                TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.signInScreen);
                    },
                    child: CustomText(
                      text: AppStrings.logIn,
                      color: Colors.white,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
