import 'package:event_sharing/helpers/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/pin_code_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //================================> Forgot Password Text Section <========================
                  CustomText(
                    text: 'Forget Password?',
                    fontWeight: FontWeight.w600,
                    fontsize: 12.sp,
                    bottom: 8.h,
                  ),
                  const CustomText(
                    text: 'We just send you authentication code',
                    maxline: 2,
                  ),
                  CustomText(
                    text: 'Basharxxxxxx@gmail.com',
                    fontWeight: FontWeight.bold,
                    fontsize: 16.sp,
                    color: const Color(0xff20353F),
                  ),
                  SizedBox(height: 80.h),
                  //==============================> Pin Code Text Field <=====================
                  const CustomPinCodeTextField(),
                  const CustomText(
                    text: 'Code Time',
                  ),
                  const CustomText(
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
                      Get.toNamed(AppRoutes.resetPasswordScreen);
                    },
                    text: 'Verify',
                    textColor: Colors.white,
                    color: AppColors.buttonColor,
                  ),
                  SizedBox(height: 32.h),
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
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.signInScreen);
          },
          child: CustomText(
            text: "Sign In",
            fontWeight: FontWeight.w400,
            color: AppColors.primaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
