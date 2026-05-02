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
    String? expiresAtStr = sharedPreferences.getString(ApiConstants.keyAccessTokenExpiresAt);

    // Delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 3));

    if (accessToken != null && accessToken.isNotEmpty) {
      bool isExpired = false;
      if (expiresAtStr != null && expiresAtStr.isNotEmpty) {
        try {
          DateTime expiresAt = DateTime.parse(expiresAtStr);
          if (DateTime.now().isAfter(expiresAt)) {
            isExpired = true;
          }
        } catch (e) {
          // If parsing fails, assume it might be invalid/expired for safety
          isExpired = true;
        }
      }

      if (isExpired) {
        // Token expired, go to sign in screen
        Get.offAllNamed(AppRoutes.signInScreen);
      } else {
        // Token exists and not expired, go directly to home screen
        Get.offAllNamed(AppRoutes.homeScreen);
      }
    } else {
      // No token, go to onboarding
      Get.offAllNamed(AppRoutes.onboardScreen);
    }
  }
}