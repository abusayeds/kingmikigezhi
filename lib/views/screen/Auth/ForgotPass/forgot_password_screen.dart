import 'package:event_sharing/helpers/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../controllers/auth_controller.dart';
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
  final TextEditingController otpController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final String emailFromArgs = Get.arguments as String? ?? '';
    if (emailFromArgs.isNotEmpty) {
      emailCTRl.text = emailFromArgs;
    } else {
      emailCTRl.text = authController.getStoredEmail();
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    emailCTRl.dispose();
    super.dispose();
  }
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
                    text: emailCTRl.text.isNotEmpty ? emailCTRl.text : 'email@example.com',
                    fontWeight: FontWeight.bold,
                    fontsize: 16.sp,
                    color: const Color(0xff20353F),
                  ),
                  SizedBox(height: 80.h),
                  //==============================> Pin Code Text Field <=====================
                  CustomPinCodeTextField(
                    textEditingController: otpController,
                  ),
                  const CustomText(
                    text: 'Code Time',
                  ),
                  const CustomText(
                    text: '00.60s',
                  ),
                  //================================> Resend code Button <======================================
                  SizedBox(height: 32.h),
                  Obx(() => CustomButton(
                    onTap: authController.isLoading.value ? () {} : () async {
                      if (emailCTRl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email not found. Please enter your email again.')),
                        );
                        return;
                      }

                      await authController.forgotPassword(
                        email: emailCTRl.text.trim(),
                      );
                    },
                    text: 'Resend code',
                    textColor: Colors.white,
                    color: AppColors.primaryColor,
                    loading: authController.isLoading.value,
                  )),
                  //================================> Verify Button <======================================
                  SizedBox(height: 128.h),
                  Obx(() => CustomButton(
                    onTap: authController.isLoading.value ? () {} : () async {
                      if (otpController.text.isEmpty || otpController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter valid OTP code')),
                        );
                        return;
                      }

                      if (emailCTRl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email not found. Please enter your email again.')),
                        );
                        return;
                      }

                      bool success = await authController.verifyForgotPasswordOTP(
                        email: emailCTRl.text.trim(),
                        otp: otpController.text.trim(),
                      );

                      if (success) {
                        Get.toNamed(AppRoutes.resetPasswordScreen, arguments: {
                          'email': emailCTRl.text.trim(),
                          'token': otpController.text.trim(),
                        });
                      }
                    },
                    text: 'Verify',
                    textColor: Colors.white,
                    color: AppColors.buttonColor,
                    loading: authController.isLoading.value,
                  )),
                  SizedBox(height: 32.h),
                  _alreadyHaveAccountText(),

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
    return   Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          fontsize: 12.sp,
          text: AppStrings.alreadyHaveAccount,
          fontWeight: FontWeight.w400,
        ),
        TextButton(
            onPressed: () {
              Get.toNamed(AppRoutes.signInScreen);
            },
            child: CustomText(
              fontsize: 12.sp,
              text:   "Sign In",
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w400,
              decoration:TextDecoration.underline,
              lineHeight: 1.5.h,
            ))
      ],
    );
  }
}
