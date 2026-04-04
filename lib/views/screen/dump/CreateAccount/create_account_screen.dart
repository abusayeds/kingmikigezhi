// import 'package:event_sharing/helpers/route.dart';
// import 'package:event_sharing/utils/app_icons.dart';
// import 'package:event_sharing/utils/app_strings.dart';
// import 'package:event_sharing/views/base/custom_button.dart';
// import 'package:event_sharing/views/base/custom_text.dart';
// import 'package:event_sharing/views/base/custom_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../../utils/app_colors.dart';
//
// class CreateAccountScreen extends StatefulWidget {
//   const CreateAccountScreen({super.key});
//
//   @override
//   State<CreateAccountScreen> createState() => _CreateAccountScreenState();
// }
//
// class _CreateAccountScreenState extends State<CreateAccountScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController emailCTRl = TextEditingController();
//   bool isChecked = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Form(
//             key: _formKey,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 108.h),
//                   //================================> Sign Up  Text Section <========================
//                   CustomText(
//                     text: 'Sign Up ',
//                     fontWeight: FontWeight.w600,
//                     fontsize: 22.sp,
//
//                   ),
//                   SizedBox(height: 74.h),
//                   //=================================> Email Text Field <=========================
//                   CustomTextField(
//                     controller: emailCTRl,
//                     hintText: AppStrings.email,
//                     prifixicon: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12.w),
//                       child: SvgPicture.asset(
//                         AppIcons.mailIcon,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your email";
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 24.h),
//                   //=======================================> CheckBox Section <==============================
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             isChecked = !isChecked;
//                           });
//                         },
//                         child: Container(
//                           width: 20.w,
//                           height: 20.w,
//                           decoration: BoxDecoration(
//                             color: isChecked ? AppColors.primaryColor : Colors.transparent,
//                             border: Border.all(
//                               color: AppColors.primaryColor,
//                               width: 1.w,
//                             ),
//                             borderRadius: BorderRadius.circular(4.r),
//                           ),
//                           child: isChecked
//                               ? Icon(
//                             Icons.check,
//                             color: Colors.white,
//                             size: 14.sp,
//                           )
//                               : null,
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       CustomText(
//                         text: "User agreement",
//                         fontsize: 12.sp,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ],
//                   ),
//
//                   //================================> Continue Button <======================================
//                   SizedBox(height: 24.h),
//                   CustomButton(
//                     onTap: () {
//                       Get.toNamed(AppRoutes.signUpOtpVerificationScreen);
//                     },
//                     text: 'Continue',
//                     color: AppColors.buttonColor,
//                     borderColor: AppColors.buttonColor,
//                     textColor: Colors.white,
//                     textStyle: TextStyle(fontSize: 12.sp),
//                   ),
//                   SizedBox(height: 32.h),
//                   //========================================> Already has an account text <============================
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomText(
//                         fontsize: 12.sp,
//                         text: 'Already has an account ?',
//                         fontWeight: FontWeight.w400,
//                         lineHeight: 1.5.h,
//                       ),
//                       GestureDetector(
//                         onDoubleTap: (){
//                           Get.toNamed(AppRoutes.signInScreen);
//
//                         },
//                         child: Text(' Sign In',style: GoogleFonts.poppins(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w500,
//                             height: 1.5.h,
//                             color: AppColors.primaryColor
//                         ),),
//                       )
//                       // TextButton(
//                       //     onPressed: () {
//                       //       Get.toNamed(AppRoutes.signInScreen);
//                       //     },
//                       //     child: CustomText(
//                       //       fontsize: 12.sp,
//                       //       lineHeight: 1.5.h,
//                       //       text: 'Sign In',
//                       //       color: AppColors.primaryColor,
//                       //       fontWeight: FontWeight.w900,
//                       //       decoration:TextDecoration.underline,
//                       //     ))
//                     ],
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
