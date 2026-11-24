import 'package:event_sharing/helpers/route_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordCTRl = TextEditingController();
  final TextEditingController confirmPasswordCTRl = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  late String userEmail;
  late String resetToken;

  @override
  void initState() {
    super.initState();
    final args = routeArgsMap();
    userEmail = args['email']?.toString() ?? authController.getStoredEmail();
    resetToken = args['resetToken']?.toString() ??
        authController.sharedPreferences.getString('reset_token') ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18.w,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //================================> Reset Password Text Section <========================
                  CustomText(
                    text: AppStrings.resetPassword,
                    fontWeight: FontWeight.w600,
                    fontsize: 22.sp,
                    bottom: 8.h,
                  ),
                  SizedBox(height: 94.h),
                  //=================================> Password Text Field <=========================
                  CustomTextField(
                    controller: passwordCTRl,
                    hintText: AppStrings.setNewPassword,
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
                  SizedBox(height: 19.h),
                  //=================================> Confirm Password Text Field <=========================
                  CustomTextField(
                    controller: confirmPasswordCTRl,
                    hintText: AppStrings.confirmpasswords,
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
                        return "Please re-enter your password";
                      }
                      return null;
                    },
                  ),
                  //================================> Reset Password Button <======================================
                  SizedBox(height: 35.h),
                  Obx(() => CustomButton(
                    onTap: authController.isLoading.value ? () {} : () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      if (passwordCTRl.text != confirmPasswordCTRl.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Passwords do not match')),
                        );
                        return;
                      }

                      await authController.resetPassword(
                        resetToken: resetToken,
                        newPassword: passwordCTRl.text,
                      );
                    },
                    text: AppStrings.resetPassword,
                    textColor: Colors.white,
                    color: AppColors.buttonColor,
                    loading: authController.isLoading.value,
                  )),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
