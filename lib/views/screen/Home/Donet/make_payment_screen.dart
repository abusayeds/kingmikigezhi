import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final TextEditingController _holderNameCTRL = TextEditingController();
  final TextEditingController _cardNumberCTRL = TextEditingController();
  final TextEditingController _cvvCTRL = TextEditingController();
  final TextEditingController _mmCTRL = TextEditingController();

  String? _selectedPaymentMethod;

  _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 18.w,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title:  Text("Make Payment",style: AppStyles.fontSize18()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
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
                prifixicon: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  child: SvgPicture.asset(AppIcons.userIcon, color: AppColors.primaryColor),
                ),
                hintText: 'Card holder name',
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _cardNumberCTRL,
                prifixicon: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  child: SvgPicture.asset(AppIcons.cardIcon),
                ),

                hintText: 'Card number',
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _cvvCTRL,
                prifixicon: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  child: SvgPicture.asset(AppIcons.lockIcon, color: AppColors.primaryColor),
                ),
                hintText: 'CVV/CVC',
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _mmCTRL,
                prifixicon: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  child: SvgPicture.asset(AppIcons.calenderIcon, color: AppColors.primaryColor),
                ),
                hintText: 'MM/YY',
              ),
              SizedBox(height: 175.h),
              CustomButton(
                onTap: (){
                  Get.toNamed(AppRoutes.paymentSuccessScreen);
                },
                  text: 'Payment Now',
                textColor: Colors.white,

                borderColor: AppColors.buttonColor,
              )
            ],
          ),
        ));
  }

  //============================> Payment Option Section <======================
  _paymentOption(String method, String assetPath) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _selectPaymentMethod(method),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              assetPath,
              width: 50.w,
              height: 50.h,
            ),
          ),
        ),
        _selectedPaymentMethod == method
            ? Positioned(
            bottom: 10.h,
            right: 0.w,
            child: SvgPicture.asset(AppIcons.check))
            :const SizedBox()
      ],
    );
  }
}
