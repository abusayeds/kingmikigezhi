import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/app_strings.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';



class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCTRl = TextEditingController();
  final TextEditingController passwordCTRl = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h,vertical: 24.w),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(

                children: [
                  SizedBox(height: 108.h),
                  //================================> Log In Text Section <========================
                  CustomText(
                    text: 'Sign In',
                    fontWeight: FontWeight.w600,
                    fontsize: 22.sp,
                    bottom: 8.h,
                  ),
                  SizedBox(height: 117.h),
                  //=================================> Email Text Field <=========================
                  CustomTextField(
                    controller: emailCTRl,
                    hintText: AppStrings.userName,
                    prifixicon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SvgPicture.asset(
                        AppIcons.userIcon,
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
                  SizedBox(height: 19.h),
                  //=================================> Password Text Field <=========================
                  CustomTextField(
                    controller: passwordCTRl,
                    hintText: AppStrings.password,
                    isPassword: true,
                    prifixicon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SvgPicture.asset(
                        AppIcons.lockIcon,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  //================================> Sign In Button <======================================
                  SizedBox(height: 35.h),
                  CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.homeScreen);
                    },
                    text: 'Sign In',
                    color: AppColors.buttonColor,
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 16.h),
                  //=======================================> CheckBox Section <==============================


                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: isChecked ? AppColors.primaryColor : Colors.transparent,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: isChecked
                              ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14.sp,
                          )
                              : null,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: AppStrings.rememberMe,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onDoubleTap: (){
                          Get.toNamed(AppRoutes.forgetPasswordOtpScreen);
                        },
                        child: CustomText(
                          text: 'Forgot Password?',
                          fontWeight: FontWeight.w600,
                          fontsize: 12.sp,
                          lineHeight: 1.5,
                          color: AppColors.primaryColor,

                        ),
                      )
                      // TextButton(
                      //   onPressed: () {
                      //     Get.toNamed(AppRoutes.forgetPasswordOtpScreen);
                      //   },
                      //   child: CustomText(
                      //     fontWeight: FontWeight.bold,
                      //     text: AppStrings.forgotPassword,
                      //     color: AppColors.primaryColor,
                      //     fontsize: 12.sp,
                      //   ),
                      // ),
                    ],
                  ),
                      //=================================> Forgot Password Button <================================




                  SizedBox(height: 32.h),
                  //========================================> Don't have an account text <============================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        fontsize: 12.sp,
                        text: AppStrings.doNotHaveAccount,
                        fontWeight: FontWeight.w400,
                      ),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.signUpScreen);
                          },
                          child: CustomText(
                            fontsize: 12.sp,
                            text: AppStrings.signUp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                            decoration:TextDecoration.underline,
                            lineHeight: 1.5.h,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
