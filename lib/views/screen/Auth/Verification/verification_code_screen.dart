import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import 'InnerWidget/pin_code_text_field.dart';

class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 64.h),
              CustomText(
                text: AppStrings.verificationCode,
                fontWeight: FontWeight.w500,
                fontsize: 20.sp,
                bottom: 12.h,
              ),
              CustomText(
                text: AppStrings.enterTheCode,
                maxline: 4,
                bottom: 16.h,
              ),
              SizedBox(height: 77.h),
              //==============================> Pin Code Text Field <=====================
              CustomPinCodeTextField(),
              SizedBox(height: 22.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //===============================> Didn't receive the Code Text <=========================
                  CustomText(
                    text: AppStrings.didNotReceiveCode,
                  ),
                  //===============================> Resent Text <=========================
                  InkWell(
                    onTap: () {},
                    child: CustomText(
                      text: AppStrings.resend,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),

              //===============================> Verify Button  <=========================
              SizedBox(height: 23.h),
              CustomButton(
                  text: AppStrings.verificationCode,
                  textColor: Colors.white,
                  onTap: () {
                    //Get.toNamed(AppRoutes.resetScreen);
                  }),
              SizedBox(height: 74.h)
            ],
          ),
        ),
      ),
    );
  }
}
