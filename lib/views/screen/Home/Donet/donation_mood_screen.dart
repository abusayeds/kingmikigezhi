import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class DonationMoodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate",style: AppStyles.fontSize18()),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,size: 18.sp,),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Text('Donation helps us to grow',style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.w600),),
          SizedBox(height: 12.h),
          Text('We do not sell or trade your information to anyone. \nBy donating, you agree to share your personal information with Savorboard Co..',textAlign: TextAlign.center,style: TextStyle(fontSize: 10.sp),),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onTap: (){
                Get.toNamed(AppRoutes.donationScreen);
              },
              text: 'Just Once',
              textStyle:TextStyle(color: Colors.black),
              color: AppColors.fillColor,
              borderColor: AppColors.buttonA47059,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onTap: (){
                Get.toNamed(AppRoutes.donationScreen);
              },
              text: 'Give Monthly',
              textStyle:TextStyle(color: Colors.black),
              color: AppColors.buttonA47059,
              borderColor: AppColors.buttonA47059,
              textColor: AppColors.textColor,
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}