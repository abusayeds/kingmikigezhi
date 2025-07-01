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
          padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(

                children: [
                  SizedBox(height: 150.h),
                  //================================> Log In Text Section <========================
                  CustomText(
                    text: 'Sign In',
                    fontWeight: FontWeight.w600,
                    fontsize: 22.sp,
                    bottom: 8.h,
                  ),
                  SizedBox(height: 56.h),
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
                  SizedBox(height: 16.h),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(

                            checkColor: Colors.white,
                            activeColor: AppColors.primaryColor,
                            focusColor: AppColors.greyColor,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                            side: BorderSide(
                              color: isChecked ? AppColors.primaryColor : AppColors.primaryColor,
                              width: 1.w,
                            ),
                          ),
                          CustomText(
                            text: AppStrings.rememberMe,
                            fontsize: 12.sp,
                          ),
                        ],
                      ),
                      //=================================> Forgot Password Button <================================
                      TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.forgetPasswordOtpScreen);
                        },
                        child: CustomText(
                          fontWeight: FontWeight.bold,
                          text: AppStrings.forgotPassword,
                          color: AppColors.primaryColor,
                          fontsize: 12.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                  //========================================> Don't have an account text <============================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: AppStrings.doNotHaveAccount,
                        fontWeight: FontWeight.w400,
                      ),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.signUpScreen);
                          },
                          child: CustomText(
                            text: AppStrings.signUp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w900,
                            decoration:TextDecoration.underline,
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
