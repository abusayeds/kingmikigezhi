import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/route.dart';
import '../utils/api_constants.dart';

class SplashController extends GetxController {
  final SharedPreferences sharedPreferences;

  SplashController({required this.sharedPreferences});



  Future<void> checkAuthStatus() async {
    // Check if access token exists using the correct key from ApiConstants
    String? accessToken = sharedPreferences.getString(ApiConstants.keyAccessToken);

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