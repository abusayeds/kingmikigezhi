import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/splash_controller.dart';
import '../../../utils/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashController _splashController;
  bool _startedAuthCheck = false;

  @override
  void initState() {
    super.initState();
    _splashController = Get.find<SplashController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_startedAuthCheck) return;
    _startedAuthCheck = true;
    _prepareAndNavigate();
  }

  Future<void> _prepareAndNavigate() async {
    // Precache next-screen assets so the transition does not flash empty frames.
    await Future.wait([
      precacheImage(AssetImage(AppImages.appLogo), context),
      precacheImage(AssetImage(AppImages.onboardingBg), context),
    ]);
    if (!mounted) return;
    await _splashController.checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4C7E95),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff4C7E95),
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
