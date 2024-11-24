import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_images.dart';
import 'package:event_sharing/views/base/custom_background.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImages.errorPageImage),
              Text('Oops!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
              Text('The page you were looking for can’t be found.',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                    onTap: () {
                      Get.toNamed(AppRoutes.homeScreen);
                      },
                    color: AppColors.buttonA47059,
                    borderColor: AppColors.buttonA47059,
                    textColor: AppColors.textColor,
                    text: 'Back to Home Page'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
