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
  
  String sessionId = '';

  @override
  void initState() {
    super.initState();
    // Get email and sessionId from arguments or stored values
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    
    if (args['sessionId'] != null) {
      sessionId = args['sessionId'];
    } else {
      sessionId = authController.forgotPasswordSessionId.value;
    }
    
    if (args['email'] != null) {
      emailCTRl.text = args['email'];
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
                      if (sessionId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Session not found. Please enter your email again.')),
                        );
                        return;
                      }

                      await authController.resendForgotPasswordOTP(
                        sessionId: sessionId,
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

                      if (sessionId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Session not found. Please enter your email again.')),
                        );
                        return;
                      }

                      var successResponse = await authController.verifyForgotPasswordOTP(
                        sessionId: sessionId,
                        otp: otpController.text.trim(),
                      );

                      if (successResponse != null) {
                        // Get resetToken from response or storage
                        String resetToken = successResponse['data']?['resetToken'] ?? 
                                           authController.sharedPreferences.getString('reset_token') ?? '';
                        
                        // Navigate to reset password screen with resetToken
                        Get.toNamed(AppRoutes.resetPasswordScreen, arguments: {
                          'resetToken': resetToken,
                          'email': emailCTRl.text.trim(),
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
