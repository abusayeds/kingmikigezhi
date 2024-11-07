import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3),(){
      Get.offAllNamed(AppRoutes.onboardScreen);
    });
    // TODO: implement initState
    super.initState();
  }

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
            width: 191.w,
            height: 189.h,
          ),
        ),
      ),
    );
  }
}
