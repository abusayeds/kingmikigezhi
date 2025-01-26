import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SuggestionDonationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,size: 18.sp,),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            const Spacer(),
            CustomButton(
                onTap: (){
                  Get.toNamed(AppRoutes.suggestionScreen);
                },
                text: 'Suggestion',
              textStyle: AppStyles.fontSize16(),
              color: AppColors.fillColor,
              borderColor: AppColors.buttonColor,
            ),
            SizedBox(height: 10.h),
            const Text('OR', style: TextStyle(fontSize: 16, color: Colors.black54,)),
            SizedBox(height: 10.h),

            CustomButton(
              onTap: (){
                Get.toNamed(AppRoutes.donationMoodScreen);
              },
              text: 'Donation',
              textStyle:AppStyles.fontSize16(),
              color: AppColors.buttonColor,
              borderColor: AppColors.buttonColor,
              textColor: AppColors.textColor,
            ),
            SizedBox(height: 125.h),
          ],
        ),
      ),
    );
  }
}