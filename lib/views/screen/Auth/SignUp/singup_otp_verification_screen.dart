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

class SignUpOtpVerificationScreen extends StatefulWidget {
  const SignUpOtpVerificationScreen({super.key});

  @override
  State<SignUpOtpVerificationScreen> createState() => _SignUpOtpVerificationScreenState();
}

class _SignUpOtpVerificationScreenState extends State<SignUpOtpVerificationScreen> {
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
      sessionId = authController.storedSessionId.value;
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
                    text: emailCTRl.text.isNotEmpty ? emailCTRl.text : 'email@example.com',
                    fontWeight: FontWeight.bold,
                    fontsize: 16.sp,
                    color: const Color(0xff20353F),
                  ),
                  SizedBox(height: 53.h),
                  //==============================> Pin Code Text Field <=====================
                  CustomPinCodeTextField(
                    textEditingController: otpController,
                  ),
                  SizedBox(height: 48.h),
                  CustomText(
                    text: 'Code Time',
                  ),
                  CustomText(
                    text: '00.60s',
                  ),
                  //================================> Resend code Button <======================================
                  SizedBox(height: 32.h),
                  Obx(() => CustomButton(
                    onTap: authController.isLoading.value ? () {} : () async {
                      if (sessionId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Session not found. Please register again.')),
                        );
                        return;
                      }

                      await authController.resendVerificationOTP(
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
                    onTap: () async {
                      // Prevent multiple taps while loading
                      if (authController.isLoading.value) return;

                      // Validate OTP code
                      if (otpController.text.isEmpty || otpController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter valid OTP code')),
                        );
                        return;
                      }

                      if (sessionId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Session not found. Please register again.')),
                        );
                        return;
                      }

                      // Call verify email API with sessionId
                      await authController.verifyEmail(
                        sessionId: sessionId,
                        otp: otpController.text.trim(),
                      );

                      // Navigation is handled in the controller on success
                    },
                    text: 'Verify',
                    textColor: Colors.white,
                    borderColor: AppColors.buttonColor,
                    loading: authController.isLoading.value,
                  )),
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

            color: AppColors.primaryColor,
            decoration: TextDecoration.underline,
            lineHeight: 4.h,
          ),
        ),
      ],
    );
  }
}
