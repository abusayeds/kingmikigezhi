import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/app_images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff4C7E95),
          /*image: DecorationImage(
                image: AssetImage(AppImages.splashBg), fit: BoxFit.cover)*/
        ),
        child: Center(
          child: Image.asset(
            AppImages.appLogo,

            width: 197.w,
            height: 208.h,
          ),
        ),
      ),
    );
  }
}
