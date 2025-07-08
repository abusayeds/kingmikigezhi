import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../utils/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({super.key,this.textEditingController});
  final TextEditingController? textEditingController;
  @override
  Widget build(BuildContext context) {
    return  PinCodeTextField(
      backgroundColor: Colors.transparent,
      cursorColor: AppColors.primaryColor,
      controller: textEditingController,


      textStyle: GoogleFonts.poppins( // Replace 'poppins' with any font you want
        fontSize: 22.sp,
        color: AppColors.bottomBarColor, // Or whatever color you need
        fontWeight: FontWeight.w600,
      ),
      autoFocus: false,
      appContext: context,
      length: 6,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(4.r),
          selectedColor: AppColors.primaryColor,

          activeFillColor: AppColors.fillColor,
          selectedFillColor: AppColors.fillColor,
          inactiveFillColor: AppColors.fillColor,
          fieldHeight: 60.h,
          fieldWidth: 47.w,
          inactiveColor: Colors.grey,
          activeColor: AppColors.primaryColor),
      obscureText: false,
      keyboardType: TextInputType.number,
      onChanged: (value) {},
    );
  }
}