import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../utils/app_colors.dart';

class CustomPinCodeTextField extends StatefulWidget {
  const CustomPinCodeTextField({
    super.key,
    this.textEditingController,
    this.pinController,
  });

  final TextEditingController? textEditingController;

  /// Optionally pass a pre-created [PinInputController] so it survives
  /// parent rebuilds (e.g. a countdown timer calling setState every second).
  final PinInputController? pinController;

  @override
  State<CustomPinCodeTextField> createState() => _CustomPinCodeTextFieldState();
}

class _CustomPinCodeTextFieldState extends State<CustomPinCodeTextField> {
  late final PinInputController _pinController;

  @override
  void initState() {
    super.initState();
    // Use the externally supplied controller if provided, otherwise create one.
    _pinController =
        widget.pinController ?? PinInputController(text: widget.textEditingController?.text ?? '');
  }

  @override
  void dispose() {
    // Only dispose if we own the controller (i.e. it was not passed in).
    if (widget.pinController == null) {
      _pinController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialPinField(
      pinController: _pinController,
      length: 6,
      onChanged: (value) {
        widget.textEditingController?.text = value;
      },
      onCompleted: (value) {
        widget.textEditingController?.text = value;
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
        ),
      ),
    );
  }
}
