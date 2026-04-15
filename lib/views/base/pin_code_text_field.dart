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
    return  MaterialPinField(
      pinController: PinInputController(text: textEditingController?.text ?? ''),
      length: 6,
      onChanged: (value) {
        textEditingController?.text = value;
      },
      onCompleted: (value) {
        textEditingController?.text = value;
      },
      theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          cellSize: Size(47.w, 60.h),
          borderRadius: BorderRadius.circular(4.r),
          borderWidth: 1,
          borderColor: Colors.grey,
          focusedBorderColor: AppColors.primaryColor,
          textStyle: GoogleFonts.poppins(
            fontSize: 22.sp,
            color: AppColors.bottomBarColor,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}
