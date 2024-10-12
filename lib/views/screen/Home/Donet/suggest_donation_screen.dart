import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SuggestionDonationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
                onTap: (){
                  Get.toNamed(AppRoutes.suggestionScreen);
                },
                text: 'Suggestion',
              textStyle:TextStyle(color: Colors.black),
              color: AppColors.fillColor,
              borderColor: AppColors.buttonA47059,
            ),
          ),
          SizedBox(height: 10),
          Text('OR', style: TextStyle(fontSize: 16, color: Colors.black54,)),
          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onTap: (){
                Get.toNamed(AppRoutes.donationScreen);
              },
              text: 'Donation',
              textStyle:TextStyle(color: Colors.black),
              color: AppColors.buttonA47059,
              borderColor: AppColors.buttonA47059,
              textColor: AppColors.textColor,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}