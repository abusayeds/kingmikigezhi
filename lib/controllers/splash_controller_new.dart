import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/route.dart';

class SplashController extends GetxController {
  final SharedPreferences sharedPreferences;

  SplashController({required this.sharedPreferences});

  Future<void> checkAuthStatus() async {
    // Check if access token exists
    String? accessToken = sharedPreferences.getString('accessToken');

    // Delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 3));

    if (accessToken != null && accessToken.isNotEmpty) {
      // Token exists, go directly to home screen
      Get.offAllNamed(AppRoutes.homeScreen);
    } else {
      // No token, go to onboarding
      Get.offAllNamed(AppRoutes.onboardScreen);
    }
  }
}
