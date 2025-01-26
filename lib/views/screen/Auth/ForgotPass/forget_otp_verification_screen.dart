import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';

class ForgetPasswordOtpScreen extends StatefulWidget {
  const ForgetPasswordOtpScreen({super.key});

  @override
  State<ForgetPasswordOtpScreen> createState() => _ForgetPasswordOtpScreenState();
}

class _ForgetPasswordOtpScreenState extends State<ForgetPasswordOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCTRl = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  SizedBox(height: 150.h),
                  //================================> Sign Up  Text Section <========================
                  CustomText(
                    text: 'Forget Password',
                    fontWeight: FontWeight.w600,
                    fontsize: 22.sp,
                    bottom: 8.h,
                  ),
                  SizedBox(height: 56.h),
                  //=================================> Email Text Field <=========================
                  CustomTextField(
                    controller: emailCTRl,
                    hintText: AppStrings.email,
                    prifixicon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SvgPicture.asset(
                        AppIcons.mailIcon,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  //================================> Continue Button <======================================
                  SizedBox(height: 24.h),
                  CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.forgotPasswordScreen);
                    },
                    text: 'Send Verification Code',
                    color: AppColors.buttonColor,
                    textColor: Colors.white,
                    textStyle: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
