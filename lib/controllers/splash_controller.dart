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
        final msg = e.toString().toLowerCase();
        final isAuthFailure = msg.contains('token') ||
            msg.contains('unauthorized') ||
            msg.contains('session expired') ||
            msg.contains('unauthenticated') ||
            msg.contains('invalidated');
        if (isAuthFailure) {
          // ApiService also force-logouts on 401; this covers splash edge cases.
          await apiService.forceLogout(reason: e.toString());
        } else {
          // Network / other errors — still open the app; later API calls
          // will force-logout if the token is actually invalid.
          Get.offAllNamed(AppRoutes.homeScreen);
        }
      }
    } else {
      // No token, go to onboarding with a soft fade (see AppRoutes.onboardScreen).
      Get.offAllNamed(AppRoutes.onboardScreen);
    }
  }
}
