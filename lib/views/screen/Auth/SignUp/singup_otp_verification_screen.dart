import 'package:event_sharing/helpers/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/pin_code_text_field.dart';

class SignUpOtpVerificationScreen extends StatefulWidget {
  const SignUpOtpVerificationScreen({super.key});

  @override
  State<SignUpOtpVerificationScreen> createState() => _SignUpOtpVerificationScreenState();
}

class _SignUpOtpVerificationScreenState extends State<SignUpOtpVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCTRl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading:  IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 18.w),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.h),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //SizedBox(height: 64.h),
                  //================================> Forgot Password Text Section <========================
                  CustomText(
                    text: 'Sign Up',
                    fontWeight: FontWeight.w600,
                    fontsize: 22.sp,

                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CustomText(
                    text: 'We just send you authentication code',
                    maxline: 2,
                  ),
                  CustomText(
                    text: 'Basharxxxxxx@gmail.com',
                    fontWeight: FontWeight.bold,
                    fontsize: 16.sp,
                    color: const Color(0xff20353F),
                  ),
                  SizedBox(height: 53.h),
                  //==============================> Pin Code Text Field <=====================
                  const CustomPinCodeTextField(),
                  SizedBox(height: 48.h),
                  CustomText(
                    text: 'Code Time',
                  ),
                  CustomText(
                    text: '00.60s',
                  ),
                  //================================> Resend code Button <======================================
                  SizedBox(height: 32.h),
                  CustomButton(
                    onTap: () {
                      // Get.toNamed(AppRoutes.verificationCodeScreen);
                    },
                    text: 'Resend code',
                    textColor: Colors.white,
                    color: AppColors.primaryColor,
                  ),
                  //================================> Verify Button <======================================
                  SizedBox(height: 128.h),
                  CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.createAccountScreen);
                    },
                    text: 'Verify',
                    textColor: Colors.white,
                    borderColor:AppColors.buttonColor,
                    //color: AppColors.buttonColor,
                  ),
                  SizedBox(height: 12.h),
                  _alreadyHaveAccountText()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //==========================> Already Have Account Text <=======================
  _alreadyHaveAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: AppStrings.alreadyHaveAccount,
          fontWeight: FontWeight.w600,
          fontsize: 12.sp,
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.signInScreen);
          },
          child: CustomText(
            text: "Sign In",
            fontsize: 12.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryColor,
            decoration: TextDecoration.underline,
            lineHeight: 4.h,
          ),
        ),
      ],
    );
  }
}
