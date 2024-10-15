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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Colors.black,size: 20.sp,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )),
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
                  ),
                  SizedBox(height: 80.h),
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
                    color: AppColors.primaryColor,
                  ),
                  //================================> Verify Button <======================================
                  SizedBox(height: 128.h),
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
          fontWeight: FontWeight.w600,
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.signInScreen);
          },
          child: CustomText(
            text: "Sign In",
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
