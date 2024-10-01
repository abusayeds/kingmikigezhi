import 'package:event_sharing/helpers/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 64.h),
                  //================================> Forgot Password Text Section <========================
                  CustomText(
                    text: AppStrings.forgotPassword,
                    fontWeight: FontWeight.w600,
                    fontsize: 22.sp,
                    bottom: 8.h,
                  ),
                  CustomText(
                    text: 'We just send you authentication code',
                    maxline: 2,
                  ),
                  CustomText(
                    text: 'Basharxxxxxx@gmail.com',
                    fontWeight: FontWeight.w600,
                    fontsize: 16.sp,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: 122.h),
                  //==============================> Pin Code Text Field <=====================
                  CustomPinCodeTextField(),
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
                      Get.toNamed(AppRoutes.verificationCodeScreen);
                    },
                    text: 'Resend code',
                    textColor: Colors.white,
                  ),
                  //================================> Verify Button <======================================
                  SizedBox(height: 32.h),
                  CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.verificationCodeScreen);
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
          fontWeight: FontWeight.w700,

        ),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.signInScreen);
          },
          child: CustomText(
            text: "Sign In",
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
