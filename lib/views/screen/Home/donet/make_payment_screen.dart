import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_images.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class MakePaymentScreen extends StatefulWidget {
  const MakePaymentScreen({super.key});

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _holderNameCTRL = TextEditingController();
  final TextEditingController _cardNumberCTRL = TextEditingController();
  final TextEditingController _cvvCTRL = TextEditingController();
  final TextEditingController _mmCTRL = TextEditingController();

  String? _selectedPaymentMethod;

  @override
  void dispose() {
    _holderNameCTRL.dispose();
    _cardNumberCTRL.dispose();
    _cvvCTRL.dispose();
    _mmCTRL.dispose();
    super.dispose();
  }

  void _selectPaymentMethod(String method) {
    setState(() => _selectedPaymentMethod = method);
  }

  void _submitPayment() {
    if (_selectedPaymentMethod == null) {
      Fluttertoast.showToast(msg: 'Please select a payment method');
      return;
    }
    if (_holderNameCTRL.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter card holder name');
      return;
    }
    if (_cardNumberError != null || _cvvError != null || _expiryError != null) {
      Fluttertoast.showToast(msg: 'Please fix card details');
      setState(() {});
      return;
    }
    final card = _cardNumberCTRL.text.replaceAll(RegExp(r'\D'), '');
    final cvv = _cvvCTRL.text.replaceAll(RegExp(r'\D'), '');
    if (card.length < 13 || cvv.length < 3 || _mmCTRL.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please complete all card fields');
      return;
    }
    Get.toNamed(AppRoutes.paymentSuccessScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18.w),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Make Payment', style: AppStyles.fontSize18()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Select Payment Method',
                fontWeight: FontWeight.w600,
                fontsize: 18.sp,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _paymentOption('Visa', AppImages.visaImage),
                  _paymentOption('Mastercard', AppImages.masterCardImage),
                  _paymentOption('Paypal', AppImages.payPalImage),
                ],
              ),
              SizedBox(height: 32.h),
              CustomTextField(
                controller: _holderNameCTRL,
                validator: (_) => null,
                prifixicon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  child: SvgPicture.asset(AppIcons.userIcon,
                      color: AppColors.primaryColor),
                ),
                hintText: 'Card holder name',
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _cardNumberCTRL,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  _CardNumberFormatter(),
                ],
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.fillColor,
                  hintText: 'Card number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 16.h),
                    child: SvgPicture.asset(AppIcons.cardIcon),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
              if (_cardNumberError != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 4.w),
                  child: Text(
                    _cardNumberError!,
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _cvvCTRL,
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.fillColor,
                  hintText: 'CVV/CVC',
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 16.h),
                    child: SvgPicture.asset(AppIcons.lockIcon,
                        color: AppColors.primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
              if (_cvvError != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 4.w),
                  child: Text(
                    _cvvError!,
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _mmCTRL,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateFormatter(),
                ],
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.fillColor,
                  hintText: 'MM/YY',
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 16.h),
                    child: SvgPicture.asset(AppIcons.calenderIcon,
                        color: AppColors.primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
              if (_expiryError != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 4.w),
                  child: Text(
                    _expiryError!,
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              SizedBox(height: 40.h),
              CustomButton(
                onTap: _submitPayment,
                text: 'Payment Now',
                textColor: Colors.white,
                borderColor: AppColors.buttonColor,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  String? get _cardNumberError {
    final digits = _cardNumberCTRL.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    if (digits.length < 13 || digits.length > 19) {
      return 'Enter a valid card number (13–19 digits)';
    }
    return null;
  }

  String? get _cvvError {
    final digits = _cvvCTRL.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    if (digits.length < 3 || digits.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }
    return null;
  }

  String? get _expiryError {
    final raw = _mmCTRL.text.trim();
    if (raw.isEmpty) return null;
    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(raw)) {
      return 'Use MM/YY format (e.g. 09/28)';
    }
    return null;
  }

  Widget _paymentOption(String method, String assetPath) {
    final selected = _selectedPaymentMethod == method;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _selectPaymentMethod(method),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? AppColors.primaryColor : Colors.transparent,
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(assetPath, width: 50.w, height: 50.h),
          ),
        ),
        if (selected)
          Positioned(
            bottom: 10.h,
            right: 0.w,
            child: SvgPicture.asset(AppIcons.check),
          )
        else
          const SizedBox(),
      ],
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}