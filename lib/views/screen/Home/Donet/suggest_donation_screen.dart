import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
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
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18.w,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
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
              textStyle:TextStyle(color: Colors.black),
              color: AppColors.fillColor,
              borderColor: AppColors.buttonA47059,
            ),
            SizedBox(height: 10.h),
            const Text('OR', style: TextStyle(fontSize: 16, color: Colors.black54,)),
            SizedBox(height: 10.h),

            CustomButton(
              onTap: (){
                Get.toNamed(AppRoutes.donationScreen);
              },
              text: 'Donation',
              textStyle:const TextStyle(color: Colors.black),
              color: AppColors.buttonA47059,
              borderColor: AppColors.buttonA47059,
              textColor: AppColors.textColor,
            ),
            SizedBox(height: 125.h),
          ],
        ),
      ),
    );
  }
}