import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userNameCTRl = TextEditingController();
  final TextEditingController firstNameCTRl = TextEditingController();
  final TextEditingController lastNameCTRl = TextEditingController();
  final TextEditingController emailCTRl = TextEditingController();
  final TextEditingController genderCTRl = TextEditingController();
  final TextEditingController phoneCTRl = TextEditingController();
  final TextEditingController dayCTRl = TextEditingController();
  final TextEditingController monthCTRl = TextEditingController();
  final TextEditingController yearCTRl = TextEditingController();
  final TextEditingController locationCTRl = TextEditingController();
  final TextEditingController passwordCTRl = TextEditingController();
  final TextEditingController confirmPasswordCTRl = TextEditingController();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70.h),
                //================================> Sign Up Text Section <========================
                Center(
                  child: Column(
                    children: [
                      CustomText(
                        text: AppStrings.signUpAn,
                        fontWeight: FontWeight.w600,
                        fontsize: 22.sp,
                        bottom: 8.h,
                      ),
                      CustomText(
                        text: AppStrings.chooseYourDream,
                        bottom: 8.h,
                        maxline: 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 51.h),
                //=================================> User Name Field <=========================
                CustomText(
                  text: AppStrings.userName,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                CustomTextField(
                  controller: userNameCTRl,
                  hintText: 'Enter your user name',
                  prifixicon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      AppIcons.singlePerson,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your user name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                //=================================> First Name Text Field <=========================
                CustomText(
                  text: AppStrings.firstName,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                CustomTextField(
                  controller: firstNameCTRl,
                  hintText: 'Enter your first name',
                  prifixicon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      AppIcons.singlePerson,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your first name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                //=================================> Last Name Text Field <=========================
                CustomText(
                  text: AppStrings.lastName,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                CustomTextField(
                  controller: lastNameCTRl,
                  hintText: 'Enter your last name',
                  prifixicon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      AppIcons.singlePerson,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your last name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                //=================================> Email Text Field <=========================
                CustomText(
                  text: AppStrings.email,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
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
                      return "Please enter your e-mail";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                //=================================> Gender Text Field <=========================
                CustomText(
                  text: AppStrings.gender,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                CustomTextField(
                  controller: genderCTRl,
                  hintText: 'Gender',
                  prifixicon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      AppIcons.singlePerson,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your gender";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                //=================================> Phone Number Text Field <=========================
                CustomText(
                  text: AppStrings.phoneNumber,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                CustomTextField(
                  controller: phoneCTRl,
                  hintText: 'Phone number',
                  prifixicon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      AppIcons.phoneIcon,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your first name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                //=================================> Birthday Text Field <=========================
                CustomText(
                  text: AppStrings.birthday,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 105.w,
                      child: CustomTextField(
                        contenpaddingHorizontal: 30.w,
                        controller: dayCTRl,
                        hintText: 'Day',
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your first name";
                          }
                          return null;
                        },*/
                      ),
                    ),
                    SizedBox(
                      width: 105.w,
                      child: CustomTextField(
                        contenpaddingHorizontal: 20.w,
                        controller: dayCTRl,
                        hintText: 'Month',
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your first name";
                          }
                          return null;
                        },*/
                      ),
                    ),
                    SizedBox(
                      width: 105.w,
                      child: CustomTextField(
                        contenpaddingHorizontal: 20.w,
                        controller: dayCTRl,
                        hintText: 'Year',
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your first name";
                          }
                          return null;
                        },*/
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),
                //=================================> Location Text Field <=========================
                CustomText(
                  text: AppStrings.location,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 105.w,
                      child: CustomTextField(
                        contenpaddingHorizontal: 20.w,
                        controller: dayCTRl,
                        hintText: 'Line 1',
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your first name";
                          }
                          return null;
                        },*/
                      ),
                    ),
                    SizedBox(
                      width: 105.w,
                      child: CustomTextField(
                        contenpaddingHorizontal: 20.w,
                        controller: dayCTRl,
                        hintText: 'Line 2',
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your first name";
                          }
                          return null;
                        },*/
                      ),
                    ),
                    SizedBox(
                      width: 105.w,
                      child: CustomTextField(
                        contenpaddingHorizontal: 20.w,
                        controller: dayCTRl,
                        hintText: 'Line 3',
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your first name";
                          }
                          return null;
                        },*/
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                //=================================> Password Text Field <=========================
                CustomText(
                  text: AppStrings.password,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                CustomTextField(
                  controller: passwordCTRl,
                  hintText: AppStrings.password,
                  isPassword: true,
                  prifixicon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      AppIcons.singlePerson,
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
                SizedBox(height: 24.h),
                //=================================> Confirm Password Text Field <=========================
                CustomText(
                  text: AppStrings.confirmPassword,
                  fontWeight: FontWeight.w500,
                  fontsize: 16.sp,
                  bottom: 8.h,
                ),
                CustomTextField(
                  controller: confirmPasswordCTRl,
                  hintText: AppStrings.confirmpasswords,
                  isPassword: true,
                  prifixicon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      AppIcons.singlePerson,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please re-enter your password";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //=======================================> CheckBox Section <==============================
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
                        color: isChecked
                            ? AppColors.primaryColor
                            : AppColors.primaryColor,
                        width: 1.w,
                      ),
                    ),
                    Text.rich(
                      maxLines: 2,
                      TextSpan(
                        text: 'By creating an account, I accept \nthe ',
                        style: TextStyle(
                            fontSize: 14.w, fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 14.w,
                                fontWeight: FontWeight.w500),
                          ),
                          const TextSpan(
                            text: ' & ',
                          ),
                          TextSpan(
                            text: 'Privacy Policy.',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 14.w,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //================================> Sign Up Button <======================================
                SizedBox(height: 32.h),
                CustomButton(
                  onTap: () {},
                  text: AppStrings.signUp,
                  textColor: Colors.white,
                ),
                SizedBox(height: 32.h),
                //========================================> Already have an account text <============================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: AppStrings.alreadyHaveAccount,
                    ),
                    TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.logInScreen);
                        },
                        child: CustomText(
                          text: AppStrings.logIn,
                        ))
                  ],
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
