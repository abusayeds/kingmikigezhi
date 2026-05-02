import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/route.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class SplashController extends GetxController {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;

  SplashController({required this.sharedPreferences, required this.apiService});

  Future<void> checkAuthStatus() async {
    // Check if access token exists using the correct key from ApiConstants
    String? accessToken =
        sharedPreferences.getString(ApiConstants.keyAccessToken);

    // Delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 3));

    if (accessToken != null && accessToken.isNotEmpty) {
      try {
        // Try to fetch profile to verify token
        await apiService.get(ApiConstants.myProfile);
        // Token is valid, go to home screen
        Get.offAllNamed(AppRoutes.homeScreen);
      } catch (e) {
        print("Splash check auth error: $e");
        if (e.toString().contains("Token expired") ||
            e.toString().contains("Unauthorized")) {
          // Token expired or invalid, clear data and go to sign in
          await apiService.clearUserData();
          Get.offAllNamed(AppRoutes.signInScreen);
        } else {
          // For other errors (e.g. network), we might still want to try going to home
          // or handle it differently. For now, let's proceed to home if it's not a token error
          Get.offAllNamed(AppRoutes.homeScreen);
        }
      }
    } else {
      // No token, go to onboarding
      Get.offAllNamed(AppRoutes.onboardScreen);
    }
  }
}
